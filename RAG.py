import os
import google.generativeai as genai
import chromadb
from chromadb import Documents, EmbeddingFunction, Embeddings
import os
import re
from PyPDF2 import PdfReader
from typing import List

os.environ["GEMINI_API_KEY"]="AIzaSyDKHlerdweaJEA078WtPwWgWRJUF01WukE"

class GeminiEmbeddingFunction(EmbeddingFunction):
    """
    Custom embedding function using the Gemini AI API for document retrieval.

    This class extends the EmbeddingFunction class and implements the __call__ method
    to generate embeddings for a given set of documents using the Gemini AI API.

    Parameters:
    - input (Documents): A collection of documents to be embedded.

    Returns:
    - Embeddings: Embeddings generated for the input documents.
    """
    def __call__(self, input: Documents) -> Embeddings:
        gemini_api_key = os.getenv("GEMINI_API_KEY")
        if not gemini_api_key:
            raise ValueError("Gemini API Key not provided. Please provide GEMINI_API_KEY as an environment variable")
        genai.configure(api_key=gemini_api_key)
        model = "models/text-embedding-004"
        title = "Custom query"
        return genai.embed_content(model=model,
                                   content=input,
                                   task_type="retrieval_document",
                                   title=title)["embedding"]

def load_pdf(file_path):
    """
    Reads the text content from a PDF file and returns it as a single string.

    Parameters:
    - file_path (str): The file path to the PDF file.

    Returns:
    - str: The concatenated text content of all pages in the PDF.
    """
    # Logic to read pdf
    reader = PdfReader(file_path)

    # Loop over each page and store it in a variable
    text = ""
    for page in reader.pages:
        text += page.extract_text()

    return text

def split_text(text, chunk_size=512, overlap=128):
    
    words = text.split()
    chunks = []
    start_index = 0

    while start_index < len(words):
        end_index = start_index + chunk_size
        chunk = words[start_index:end_index]
        chunks.append(' '.join(chunk))
        
        # Yeni başlangıç indeksi, mevcut başlangıç indeksine overlap kadar eklenir
        start_index += chunk_size - overlap

    return chunks

def create_chroma_db(documents:List, path:str, name:str):
    """
    Creates a Chroma database using the provided documents, path, and collection name.

    Parameters:
    - documents: An iterable of documents to be added to the Chroma database.
    - path (str): The path where the Chroma database will be stored.
    - name (str): The name of the collection within the Chroma database.

    Returns:
    - Tuple[chromadb.Collection, str]: A tuple containing the created Chroma Collection and its name.
    """
    chroma_client = chromadb.PersistentClient(path=path)
    db = chroma_client.create_collection(name=name, embedding_function=GeminiEmbeddingFunction())

    for i, d in enumerate(documents):
        db.add(documents=d, ids=str(i))

    return db, name

def load_chroma_collection(path, name):
    """
    Loads an existing Chroma collection from the specified path with the given name.

    Parameters:
    - path (str): The path where the Chroma database is stored.
    - name (str): The name of the collection within the Chroma database.

    Returns:
    - chromadb.Collection: The loaded Chroma Collection.
    """
    chroma_client = chromadb.PersistentClient(path=path)
    db = chroma_client.get_collection(name=name, embedding_function=GeminiEmbeddingFunction())

    return db

def get_relevant_passage(query, db, n_results):
  passage = db.query(query_texts=[query], n_results=n_results)['documents'][0]
  return passage

def main(text=None, prompt=None):

    path = os.path.join(os.getcwd(), "content")

    if text != None:
        
        chroma_client = chromadb.PersistentClient(path=path)
        existing_collections = chroma_client.list_collections()
        collection_names = [collection.name for collection in existing_collections]  # Extract collection names

        if "rag" in collection_names:
            chroma_client.delete_collection("rag")
        
        chunked_text = split_text(text=text)
        db, name = create_chroma_db(documents=chunked_text, path=path, name="rag")

    if prompt != None:
        db=load_chroma_collection(path, name="rag")
        relevant_text = get_relevant_passage(query=prompt,db=db,n_results=3)
    else:
        relevant_text = ""

    return relevant_text