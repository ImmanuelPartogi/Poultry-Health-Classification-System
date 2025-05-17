from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import os
import logging
import torch
from app.model.classifier import ViTChickenClassifier, ChickenHealthClassifier

# Konfigurasi logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Path ke model
MODEL_PATH = "models/best_vit_chicken_classifier.pth"

# Inisialisasi model sekali saja saat startup
classifier = ChickenHealthClassifier(MODEL_PATH)

app = FastAPI(
    title="Chicken Health Classifier API",
    description="API untuk klasifikasi kondisi kesehatan ayam",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    logger.info("Endpoint root diakses")
    return {"message": "Selamat datang di API Klasifikasi Kesehatan Ayam", "status": "online"}

@app.post("/predict")
async def predict_image(file: UploadFile = File(...)):
    """
    Memprediksi kondisi kesehatan ayam dari gambar
    """
    try:
        logger.info(f"Menerima file untuk prediksi: {file.filename}")
        
        # Simpan file sementara
        temp_dir = "temp_uploads"
        os.makedirs(temp_dir, exist_ok=True)
        file_path = os.path.join(temp_dir, file.filename)
        
        with open(file_path, "wb") as buffer:
            content = await file.read()
            buffer.write(content)
        
        logger.info(f"File disimpan di: {file_path}")
        
        # Lakukan prediksi dengan model
        try:
            # Gunakan model untuk prediksi
            result = classifier.predict(file_path)
            logger.info(f"Hasil prediksi: {result['prediction']} dengan confidence {result['confidence']}")
            
            return result
        except Exception as e:
            logger.error(f"Error saat prediksi dengan model: {str(e)}")
            raise HTTPException(status_code=500, detail=f"Error pada model prediksi: {str(e)}")
        
    except Exception as e:
        logger.error(f"Error dalam pemrosesan file: {str(e)}")
        raise HTTPException(status_code=400, detail=f"Error dalam pemrosesan file: {str(e)}")