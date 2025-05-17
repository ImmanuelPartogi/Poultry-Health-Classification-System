from fastapi import APIRouter, UploadFile, File, HTTPException
import os
import uuid
from app.model.classifier import ChickenHealthClassifier
import time

router = APIRouter()

# Inisialisasi model di luar handler agar tidak perlu reload setiap request
MODEL_PATH = "models/best_vit_chicken_classifier.pth"
classifier = ChickenHealthClassifier(MODEL_PATH)

@router.post("/predict")
async def predict_image(file: UploadFile = File(...)):
    """
    Memprediksi kondisi kesehatan ayam dari gambar yang diunggah
    """
    # Validasi file
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File harus berupa gambar")
    
    # Simpan file sementara
    file_extension = os.path.splitext(file.filename)[1]
    temp_file = f"app/static/{uuid.uuid4()}{file_extension}"
    
    try:
        # Tulis file
        with open(temp_file, "wb") as buffer:
            buffer.write(await file.read())
        
        # Lakukan prediksi
        result = classifier.predict(temp_file)
        
        # Tambahkan informasi tambahan
        result["timestamp"] = time.time()
        result["filename"] = file.filename
        
        return result
    
    finally:
        # Hapus file sementara
        if os.path.exists(temp_file):
            os.remove(temp_file)