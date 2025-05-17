import torch
import torch.nn as nn
import timm
from PIL import Image
import torchvision.transforms as transforms
import os

# Kelas model identik dengan yang di notebook
class ViTChickenClassifier(nn.Module):
    def __init__(self, num_classes=4):
        super(ViTChickenClassifier, self).__init__()
        self.vit = timm.create_model('vit_base_patch16_224', pretrained=False)
        in_features = self.vit.head.in_features
        self.vit.head = nn.Linear(in_features, num_classes)
        
    def forward(self, x):
        return self.vit(x)

class ChickenHealthClassifier:
    def __init__(self, model_path):
        self.device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
        
        # Inisialisasi model
        self.model = ViTChickenClassifier(num_classes=4)
        
        # Load state dict
        self.model.load_state_dict(torch.load(model_path, map_location=self.device))
        self.model.to(self.device)
        self.model.eval()
        
        # Kelas kondisi kesehatan
        self.classes = ["Chicken_Coccidiosis", "Chicken_Healthy", "Chicken_NewCastleDisease", "Chicken_Salmonella"]
        
        # Transformasi gambar sama dengan validation transform
        self.transform = transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
        ])
    
    def predict(self, image_path):
        # Buka dan preprocess gambar
        img = Image.open(image_path).convert('RGB')
        img_tensor = self.transform(img).unsqueeze(0).to(self.device)
        
        # Prediksi dengan model
        with torch.no_grad():
            outputs = self.model(img_tensor)
            _, predicted = torch.max(outputs, 1)
            probabilities = torch.nn.functional.softmax(outputs, dim=1)[0]
        
        # Dapatkan indeks kelas dan probabilitas
        class_idx = predicted.item()
        class_name = self.classes[class_idx]
        
        # Buat hasil prediksi dengan probabilitas untuk semua kelas
        results = {
            "prediction": class_name,
            "confidence": float(probabilities[class_idx]),
            "probabilities": {
                cls: float(probabilities[i]) 
                for i, cls in enumerate(self.classes)
            }
        }
        
        return results