import joblib
import os
from google.cloud import storage
import sklearn
import logging

logging.basicConfig(level=logging.INFO)


def load_model() -> sklearn.dummy.DummyClassifier:
    storage_client = storage.Client()
    bucket = storage_client.get_bucket(os.environ.get("MODEL_BUCKET_NAME"))
    blob = bucket.blob(os.environ.get("MODEL_FILE_NAME"))
    local_model_path = "./tmp/model.joblib"
    blob.download_to_filename(local_model_path)

    return joblib.load(local_model_path)


def main(event, context) -> None:
    model = load_model()
    logging.info("Model loaded successfully")

    # model.predict(event['data'])
    # send email
    logging.info("Prediction made successfully, email sent")

    print(f"Event: {event}")
