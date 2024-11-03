import google.generativeai as genai
import PyPDF2
import csv
import os
import re
from PIL import Image
import io
from flask import Flask, request, jsonify
from google.generativeai.types import HarmCategory, HarmBlockThreshold
from google.ai.generativelanguage_v1beta.types import content
import RAG

# Configure the Google GenAI API
genai.configure(api_key="GEMINI_API_KEY")

app = Flask(__name__)

# Create the model
generation_config = {
"temperature": 0,
"top_p": 0.95,
"top_k": 40,
"max_output_tokens": 8192,
"response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
  model_name="gemini-1.5-flash-002",
  generation_config=generation_config,
  tools = [
    genai.protos.Tool(
      function_declarations = [
        genai.protos.FunctionDeclaration(
          name = "get_new_question",
          description = "Kullanıcı tarafından PDF yüklendi. İlk soru istendiğinde, yeni bir soru talep edildiğinde veya mevcut konuşmada farkli soruya geçmek istendiğinde bu fonksiyon çağrılmalıdır.",
        ),
      ],
    ),
  ],
  tool_config={'function_calling_config':'AUTO'},
)

chat_session = model.start_chat(history=[])

qa = ["",""]

pdf = None
img = None

def load_pdf(file_path):
    if not os.path.isfile(file_path):
        raise ValueError(f"File path {file_path} is not a valid file.")

    with open(file_path, 'rb') as file:
        reader = PyPDF2.PdfReader(file)
        text = ''
        for page in reader.pages:
            text += page.extract_text() or ''  # Sayfa metni None dönebilir, bunu kontrol et
    return text

def extract_qa(text):
    q_pattern = r'\[q\](.*?)\[/q\]'
    a_pattern = r'\[a\](.*?)\[/a\]'
    questions = re.findall(q_pattern, text, re.DOTALL)
    answers = re.findall(a_pattern, text, re.DOTALL)
    questions = [q.strip() for q in questions]
    answers = [a.strip() for a in answers]
    qa_pairs = list(zip(questions, answers))
    return qa_pairs

def generate_questions_and_answers(text):

    model = genai.GenerativeModel(
    model_name="gemini-1.5-flash-002",
    generation_config=generation_config,
    )

    session = model.start_chat(history=[])

    prompt = f"{text}\n\nBu metinden çok fazla ve çeşitli soru üret. Daha sonra her sorunun cevaplarını bu metinden bul.\nFormat: [q]soru1 burada olacak[/q]\n[a]cevap1 burada olacak[/a]\n[q]soru_n burada olacak[/q]\n[a]cevap_n burada olacak[/a]"

    try:
        response = session.send_message(prompt,
                                               safety_settings={
                                                   HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_NONE,
                                                   HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_NONE,
                                                   HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_NONE,
                                                   HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
                                               })
        qa_pairs = extract_qa(response.text.strip())

    except ValueError as e:

        print(f"Error generating questions: {e}")
        qa_pairs = []

    chat_session.history = []

    return qa_pairs

def save_to_csv(qa_pairs, output_file):
    os.makedirs(os.path.dirname(output_file), exist_ok=True)

    with open(output_file, "w", newline="", encoding="utf-8") as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(["Question", "Answer"])

        for question, answer in qa_pairs:
            csv_writer.writerow([question, answer])

def get_qa_pairs(file_path):
    # CSV dosyasını aç ve tüm kayıtları oku
    with open(file_path, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        qa_pairs = []

        # Her kayıt için soru ve cevabı kontrol et
        for row in reader:
            if row.get('Question') and row.get('Answer'):
                qa_pairs.append((row['Question'], row['Answer']))

    # Eğer hiç kayıt yoksa ["", ""] ekle
    if not qa_pairs:
        qa_pairs.append(["", ""])

    # İlk kayıt
    selected_pair = qa_pairs[0]

    # Kalan kayıtları yazmak için dosyayı yeniden aç
    with open(file_path, "w", newline='', encoding='utf-8') as csvfile:
        # Başlıkları yaz
        csv_writer = csv.writer(csvfile)
        csv_writer.writerow(["Question", "Answer"])

        # Sadece kalan kayıtları yaz (ilk kaydı çıkart)
        for question, answer in qa_pairs[1:]:
            csv_writer.writerow([question, answer])

    # Seçilen soru-cevap çiftini döndür
    return selected_pair

@app.route('/get_question_document', methods=['POST'])
def get_question_document():
    global qa

    # PDF dosyasını form verisi olarak al
    if 'pdf' in request.files:
        
        qa = ["",""]
        file = request.files['pdf']

        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400

        # Geçici bir dosyaya yaz
        temp_file_path = os.path.join("temp", file.filename)
        os.makedirs("temp", exist_ok=True)
        file.save(temp_file_path)

        # PDF dosyasını işle
        try:
            text = load_pdf(temp_file_path)
            qa_pairs = generate_questions_and_answers(text)
            
            # CSV dosyasını kaydetme
            output_file = os.path.join(os.getcwd(), "QA.csv")
            save_to_csv(qa_pairs, output_file)

            return jsonify({}), 200

        except Exception as e:
            return jsonify({"error": str(e)}), 500

        finally:
            # Geçici dosyayı sil
            if os.path.isfile(temp_file_path):
                os.remove(temp_file_path)

@app.route('/get_question', methods=['POST']) 
def get_question():
    global qa

    # JSON formatında gelen verileri al
    data = request.get_json()

    # 'prompt' ve 'reply' alanlarını al
    prompt = data.get('prompt')
    reply = data.get('reply')
    
    if qa == ["",""]:
        prompt = f"Kullanıcı:{prompt}\n\nKullanıcıya bir eğitim asistanı gibi davran. Senden soru isterse o zaman function call yapabilirsin"

        try:
            response = chat_session.send_message(prompt,
                                                safety_settings={
                                                    HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
                                                })
            # Process the response
            for part in response.parts:
                if fn := part.function_call:
                    
                    qa = get_qa_pairs("QA.csv")

                    return jsonify({"question": qa[0],
                        "answer" : qa[1]}), 200
                else:
                    return jsonify({"question": part.text.strip(),
                        "answer" : ""}), 200
        except ValueError as e:
            print(f"Error generating questions: {e}")
    else:
        prompt = f"Soru:{qa[0]}\nDoğru Cevap:{qa[1]}\n\nÖğrenci cevabı:{prompt}\n\nSen bir eğitim asistanısın ve öğrenciye direkt cevabını ver."

        try:
            response = chat_session.send_message(prompt,
                                                safety_settings={
                                                    HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
                                                })
            # Process the response
            for part in response.parts:
                if fn := part.function_call:
                    
                    qa = get_qa_pairs("QA.csv")

                    return jsonify({"question": qa[0],
                        "answer" : qa[1]}), 200
                else:
                    return jsonify({"question": part.text.strip(),
                        "answer" : ""}), 200
        except ValueError as e:
            print(f"Error generating questions: {e}")
        
    return jsonify({"question": qa[0],
                        "answer" : qa[1]}), 200

@app.route('/ask_question_document', methods=['POST'])
def ask_question_document():
    global pdf
    global img
    
    if 'img' in request.files:
        
        file = request.files['img']
        
        # Görüntüyü açma ve OCR işlemi
        img = Image.open(io.BytesIO(file.read()))
        pdf = None

        return jsonify({}), 200
    
    # PDF dosyasını form verisi olarak al
    if 'pdf' in request.files:
        
        file = request.files['pdf']

        pdf = file
        img = None

        # Geçici bir dosyaya yaz
        temp_file_path = os.path.join("temp", file.filename)
        os.makedirs("temp", exist_ok=True)
        file.save(temp_file_path)

        # PDF dosyasını işle
        try:
            text = load_pdf(temp_file_path)
            retrieved_text = RAG.main(text, prompt=None)

            return jsonify({}), 200

        except Exception as e:
            return jsonify({"error": str(e)}), 500

        finally:
            # Geçici dosyayı sil
            if os.path.isfile(temp_file_path):
                os.remove(temp_file_path)

@app.route('/ask_question', methods=['POST']) 
def ask_question():
    global qa
    global pdf
    global img

    if img != None:

        # JSON formatında gelen verileri al
        data = request.get_json()

        # 'prompt' ve 'reply' alanlarını al
        prompt = data.get('prompt')
        reply = data.get('reply')

        prompt = f"{prompt}\n\nBir eğitim asistanısın. Fotoğrafa göre cevap ver."

        try:
            response = chat_session.send_message([img, prompt],
                                                safety_settings={
                                                    HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
                                                })
            
            return jsonify({"question": response.text.strip(),
                "answer" : ""}), 200
        except ValueError as e:
            print(f"Error generating questions: {e}")
            
            return jsonify({}), 200

    else:
        # JSON formatında gelen verileri al
        data = request.get_json()

        # 'prompt' ve 'reply' alanlarını al
        prompt = data.get('prompt')
        reply = data.get('reply')
        
        retrieved_text = RAG.main(text=None, prompt=prompt)

        qa = [prompt, retrieved_text]
        
        prompt = f"Retrieved Cevap:{qa[1]}\nSoru:{qa[0]}\nBir RAG sistemnin son katmanısın. Bu soruya yukarıdaki bilgilere göre doğru cevabı bul ve bana ver."

        try:
            response = chat_session.send_message(prompt,
                                                safety_settings={
                                                    HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_NONE,
                                                    HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
                                                })
            
            return jsonify({"question": response.text.strip(),
                "answer" : ""}), 200
        except ValueError as e:
            print(f"Error generating questions: {e}")
            
            return jsonify({})
        
@app.route('/chat', methods=['POST']) 
def chat():

    # JSON formatında gelen verileri al
    data = request.get_json()

    # 'prompt' ve 'reply' alanlarını al
    prompt = data.get('prompt')
    reply = data.get('reply')

    prompt = f"Sen bir eğitim asistanısın. Yalnızca eğitimi ve öğrencileri ilgilediren konulara cevap ver. Diğer konulara 'Ben bir eğitim asistanıyım, buna cevap vermeyi tercih etmiyorum.' de.\n\n{prompt}"

    try:
        response = chat_session.send_message(prompt,
                                            safety_settings={
                                                HarmCategory.HARM_CATEGORY_HATE_SPEECH: HarmBlockThreshold.BLOCK_NONE,
                                                HarmCategory.HARM_CATEGORY_HARASSMENT: HarmBlockThreshold.BLOCK_NONE,
                                                HarmCategory.HARM_CATEGORY_SEXUALLY_EXPLICIT: HarmBlockThreshold.BLOCK_NONE,
                                                HarmCategory.HARM_CATEGORY_DANGEROUS_CONTENT: HarmBlockThreshold.BLOCK_NONE,
                                            })
        
        return jsonify({"question": response.text.strip(),
            "answer" : ""}), 200
    except ValueError as e:
        print(f"Error generating questions: {e}")
        
        return jsonify({}), 200

if __name__ == "__main__":
    
    app.run(host='0.0.0.0', port=8080, debug=True)
