<div align="center">
  <img src="docs/assets/logo.png" alt="ChickenHealthAI Logo" width="180px" />
  <h1>ChickenHealthAI</h1>
  <p>Intelligent Chicken Health Detection System with Vision Transformer</p>
  <p>
    <img src="https://img.shields.io/badge/PyTorch-EE4C2C?style=for-the-badge&logo=pytorch&logoColor=white" />
    <img src="https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white" />
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
    <img src="https://img.shields.io/badge/ViT-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white" />
    <img src="https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
  </p>
  <p>
    <a href="#features">Features</a> •
    <a href="#architecture">Architecture</a> •
    <a href="#technology">Technology</a> •
    <a href="#screenshot">Screenshots</a> •
    <a href="#installation">Installation</a> •
    <a href="#api-endpoints">API</a> •
    <a href="#results">Results</a> •
    <a href="#team">Team</a>
  </p>
  <br />
  <img src="docs/assets/app-preview.png" alt="ChickenHealthAI App Preview" width="85%" />
</div>
🔍 Overview
ChickenHealthAI is a chicken health detection system based on AI vision technology that uses Vision Transformer (ViT-B/16) architecture to classify chicken health conditions through fecal image analysis. The system consists of a FastAPI-based backend and a cross-platform mobile application with Flutter, providing an integrated solution for poultry health monitoring for farmers.
With an accuracy of 97.85%, this system can identify 4 health conditions:

🟢 Healthy - Chicken in normal healthy condition
🔴 Coccidiosis - Protozoan infection of the digestive tract
🟠 Newcastle Disease - Viral infection affecting the respiratory system
🟣 Salmonella - Bacterial infection that can cause food poisoning

The deep learning model for this classification was developed based on DeepPoultryInsight, with additional modifications and optimizations to improve accuracy and performance.
✨ Features
Backend (FastAPI)

REST API for chicken feces image classification
Pre-trained Vision Transformer (ViT-B/16) architecture
Real-time image processing
API documentation with Swagger UI
Prediction results with confidence score per class
Scalable and high-performance

Frontend (Flutter)

Intuitive and minimalist user interface
Image capture through camera or gallery
Prediction result visualization with color-coding
Storage and management of examination history
Health condition descriptions and handling recommendations
Offline mode for limited connectivity conditions

🏗️ Architecture
<div align="center">
  <img src="docs/assets/architecture-diagram.png" alt="System Architecture" width="85%" />
</div>
System Flow

User takes a photo of chicken feces through Flutter app
Image is sent to FastAPI backend via /predict endpoint
Backend performs image preprocessing (resize, normalization)
Trained ViT-B/16 model performs inference
Classification results and probabilities are returned to the app
App displays results and saves to local history

🧪 Technology
AI Model

Vision Transformer (ViT-B/16): Transformer architecture for understanding global relationships in images
Transfer Learning: Fine-tuning pre-trained models for specific classification tasks
Accuracy: 97.85% on validation data
Metrics: Precision 0.98, Recall 0.98, F1-Score 0.98
Libraries: PyTorch, torchvision, timm

Backend

FastAPI: Fast and modern Python-based API framework
Uvicorn: High-performance ASGI server
CORS Middleware: Supports cross-origin requests
Swagger UI: Interactive API documentation
Scalable architecture: Designed for high throughput

Frontend

Flutter: Cross-platform UI framework
Provider: State management
http: Package for backend communication
image_picker: Camera and gallery access
shared_preferences: Local storage for examination history
Google Fonts: Modern typography (Poppins)
flutter_animate: Smooth UI animations

📱 Screenshots
<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="docs/screenshots/home-screen.png" alt="Home Screen" width="250px" /><br />
        <span><strong>Home Screen</strong></span>
      </td>
      <td align="center">
        <img src="docs/screenshots/results-screen.png" alt="Results Screen" width="250px" /><br />
        <span><strong>Detection Results</strong></span>
      </td>
      <td align="center">
        <img src="docs/screenshots/history-screen.png" alt="History Screen" width="250px" /><br />
        <span><strong>Detection History</strong></span>
      </td>
    </tr>
  </table>
</div>
📂 Struktur Proyek
chicken-health-ai/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   │   └── endpoints.py
│   │   ├── model/
│   │   │   ├── classifier.py
│   │   │   └── utils.py
│   │   ├── static/
│   │   └── main.py
│   ├── models/
│   │   └── best_vit_chicken_classifier.pth
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/
│   ├── lib/
│   │   ├── models/
│   │   │   ├── history_entry.dart
│   │   │   └── prediction.dart
│   │   ├── screens/
│   │   │   ├── history_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   └── result_screen.dart
│   │   ├── services/
│   │   │   ├── api_service.dart
│   │   │   └── history_service.dart
│   │   ├── theme.dart
│   │   └── main.dart
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
├── notebook/
│   └── chicken_classifier_vit.ipynb
├── docs/
│   ├── assets/
│   ├── screenshots/
│   └── api-docs.md
└── README.md
🚀 Installation
Prerequisites

Python 3.8+
Flutter 3.0+

Backend Setup
bash# Clone repo
git clone https://github.com/yourusername/chicken-health-ai.git
cd chicken-health-ai/backend

# Setup virtual environment
python -m venv venv
source venv/bin/activate  # Linux/Mac
# or
venv\Scripts\activate  # Windows

# Install dependencies
pip install -r requirements.txt

# Download pre-trained model
mkdir -p models
wget -O models/best_vit_chicken_classifier.pth https://github.com/yourusername/chicken-health-ai/releases/download/v1.0/best_vit_chicken_classifier.pth

# Run the server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
Frontend Setup
bashcd chicken-health-ai/frontend

# Install dependencies
flutter pub get

# Update API endpoint (if needed)
# Edit lib/services/api_service.dart to point to your backend URL

# Run the app
flutter run

# Build APK
flutter build apk --release
📡 API Endpoints
EndpointMethodDescription/GETAPI status and general information/predictPOSTSend image for prediction (multipart/form-data)
Request and Response Examples
Request:
POST /predict
Content-Type: multipart/form-data

file: [image binary data]
Response:
json{
  "prediction": "Chicken_Healthy",
  "confidence": 0.97865,
  "probabilities": {
    "Chicken_Coccidiosis": 0.00532,
    "Chicken_Healthy": 0.97865,
    "Chicken_NewCastleDisease": 0.00119, 
    "Chicken_Salmonella": 0.01484
  },
  "timestamp": 1683274521.45,
  "filename": "image1.jpg"
}
📊 Results
Model Performance

Accuracy: 97.85%
Precision: 0.98
Recall: 0.98
F1-Score: 0.98

Performance by Class
ClassPrecisionRecallF1-ScoreSupportChicken_Coccidiosis0.990.990.99489Chicken_Healthy0.970.970.97461Chicken_NewCastleDisease0.970.970.97105Chicken_Salmonella0.980.980.98431
<div align="center">
  <img src="docs/assets/confusion-matrix.png" alt="Confusion Matrix" width="600px" />
</div>
Training Graphs
<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="docs/assets/accuracy-graph.png" alt="Accuracy Graph" width="450px" /><br />
        <span>Accuracy Graph</span>
      </td>
      <td align="center">
        <img src="docs/assets/loss-graph.png" alt="Loss Graph" width="450px" /><br />
        <span>Loss Graph</span>
      </td>
    </tr>
  </table>
</div>
🧠 Training Method
The Vision Transformer (ViT-B/16) model was trained using a two-phase fine-tuning strategy:

Phase 1: Fine-tuning head classifier (5 epochs)

Freeze backbone
Train head classifier
Learning rate: 1e-4
Optimizer: Adam


Phase 2: Fine-tuning last layers (15 epochs)

Unfreeze last 2 transformer blocks
Learning rate: 1e-5
Scheduler: CosineAnnealingLR



The dataset consists of 7,427 chicken feces images divided into:

Training: 5,941 images (80%)
Validation: 1,486 images (20%)

Dataset Distribution
ClassNumber of ImagesChicken_Coccidiosis2,402Chicken_Healthy2,331Chicken_NewCastleDisease525Chicken_Salmonella2,169Total7,427
🔧 Data Preprocessing

Resize: 224x224 pixels
Normalization: mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]
Augmentation (training only):

RandomHorizontalFlip (p=0.5)
RandomVerticalFlip (p=0.2)
RandomRotation (degrees=15)
ColorJitter (brightness=0.1, contrast=0.1, saturation=0.1, hue=0.05)



🌟 System Advantages

High Accuracy: Model achieves 97.85% accuracy with balanced performance across all classes
Responsive: Inference time less than 2 seconds on modern devices
User-Friendly: Minimalist and intuitive interface with clear visual indicators
Local Storage: Detection history stored on device for offline access
Data Security: Images processed locally on backend without storing sensitive data
Cross-Platform: Available for Android and iOS from the same codebase
Scalability: Modular architecture allows for development of new features

📈 Development Potential

Additional disease detection features
Integration with farm management systems
More comprehensive handling recommendations
Offline mode for direct inference on device
Analytics dashboard to view poultry health trends
Support for other livestock

👥 Team

[Developer Name 1] - Backend Developer & AI Engineer
[Developer Name 2] - Flutter Developer & UI/UX Designer
[Developer Name 3] - DevOps & Machine Learning Engineer
[Developer Name 4] - Product Manager & UX Researcher

📄 License
This project is licensed under the MIT License
🙏 Acknowledgements

Model inspired by DeepPoultryInsight
Dataset: Chicken Feces Dataset
PyTorch
timm
FastAPI
Flutter


<div align="center">
  <p>
    <sub>© 2025 ChickenHealthAI Team. All rights reserved.</sub>
  </p>
</div>
