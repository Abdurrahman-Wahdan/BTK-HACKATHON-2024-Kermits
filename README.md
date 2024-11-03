# Kermits
## Quick start Guide
### Requirements
 1. **Flutter:** To use this code you have to be using SDK version of '>=3.3.0 <4.0.0'.
 2. **Dependencies:** Install dependencies in the `pubspec.yaml` file using the following code:
```bash
flutter pub get
```
### Running the Application
To run the application, follow these steps:

1. **Open an Emulator**: Launch any emulator of your choice. For this guide, we recommend using the `Pixel 8 API 33` emulator, which can be downloaded from **Android Studio**.

2. **Select the Device**: In Visual Studio Code, press `Ctrl + Shift + P` to open the command palette. From the list, select `Flutter: Select Device` and choose your desired device.

3. **Run the Application**: Once the device is selected, you can run the application without debugging.
   
4. **Run the Backend**: Run the `API.py` file to enable access to all features of the application..

### Prerequisites

- Flutter SDK
- Visual Studio Code
- Android Studio

### Installation Steps

1. Clone the repository:
```bash
   git clone https://github.com/yourusername/your-repo-name.git 
````
2. Navigate to the Project Directory:
```bash
   cd your-repo-name
````
3. Open a terminal and install the dependencies:
```bash
   flutter pub get
````

> [!Warning] 
> Any Change in the original dependencies file could cause the code not to work.

### Backend Setup
For the backend part or any Python scripts, ensure you have the required libraries installed. You can do this by running:
```bash
   pip install <library-name>
````

Now you're ready to go and run the code 🎉

## Overview of Code Functionality
### Generate Question Functionality
This feature allows users to upload a PDF document, from which the system will generate a series of question-answer pairs based on the PDF content by using Gemini. Utilizing the Gemini AI model, the application intelligently formulates questions that reflect key concepts within the document. 
> [!NOTE]
> The most important point of this feature is that with the Gemini's "function call" feature, the chatbot asks new questions only when a new question is requested by the user.

#### User Interaction:
1. **Upload PDF**: Users can easily upload a PDF file containing the material they wish to study.
2. **Question Generation**: Upon uploading, the application extracts information from the PDF and generates relevant questions by using Gemini.
3. **Interactive Quiz**: Users can then engage with the bot, answering the generated questions at their own pace.
4. **Feedback Mechanism**: If a user answers a question incorrectly, the bot provides the correct answer along with an explanation to enhance understanding. For correct responses, users receive positive reinforcement and insights to deepen their knowledge.
5. **Get New Question**: When the user has no more questions about the current topic, he/she requests a new question and the new question is called from the back-end with Gemini "function call", then the chat continues.


In summary, this functionality utilizes Gemini's new function calling feature, allowing the application to differentiate between general chat and specific requests for questions. When users ask for a question, the system recognizes the request and generates questions accordingly, while casual conversations continue as normal.

> [!NOTE] 
> Our application uniquely enables users to upload PDF files for question generation, a feature currently unavailable on the Gemini website. This provides a valuable tool for extracting knowledge from documents.


### Ask Question Functionality
When a user uploads a PDF, the document is automatically divided into smaller chunks in the background, and embeddings are created for each chunk. When the user poses a question, the model uses these embeddings to retrieve relevant information from the document. This enables the system to perform **Retrieval-Augmented Generation (RAG)**, where it intelligently finds and provides answers based on the content of the uploaded material.

This process allows for precise, context-based answers by focusing on relevant parts of the document, making interactions both efficient and informative.


### Educational Chat Functionality
This feature provides a simple chat interface where users can engage with Gemini exclusively on educational topics. Any attempt to discuss non-educational subjects will prompt the model to remind users that it can only assist with educational inquiries.

We achieved this by carefully manipulating the prompts sent to the model, ensuring that Gemini remains focused on providing valuable educational support.

### Other Functionalities
In addition to our main features, the application includes several general functionalities designed to enhance the user experience. The interface is thoughtfully crafted to cater to the age range of students using the application. It consists of three main pages:
1. Home Page
2. AI Chat Bot Page
3. Profile page

#### Home Page Features:
In the home page we have 2 main features:
1. Motivational Quotes::
   This section offers a collection of motivational quotes aimed at inspiring students to explore and learn. Currently, the quotes are limited in number, but we plan to integrate this feature with Gemini in the future to provide a diverse array of quotes that change regularly.
2. Topics:
  At the bottom of the home page, users will find a curated list of topics to explore. By selecting a topic, the application provides relevant information. While the current selection is somewhat limited, we aim to enhance this feature by connecting it to students' grades, allowing Gemini to deliver tailored content based on their academic needs and interests.

#### AI Chat Bot Page:
The AI Chat Bot Page features three navigation buttons, allowing users to easily access their preferred functionalities. This streamlined design enhances user experience by providing quick access to the features discussed earlier.

#### Profile Page:
The Profile Page displays user information with a polished user interface. While the UI is fully developed, it is not yet connected to Firebase or any database, so it currently functions as a static display.

> [!NOTE] 
> Please be aware that some features and buttons may not function as expected, as this is currently a prototype and not a fully deployed application.



## Result


## Contributors

- **[Abdelrahman Wahdan](https://github.com/Abdurrahman-Wahdan)**
- **[İsmail Furkan Atasoy](https://github.com/ifurkanatasoy)**

