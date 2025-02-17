FROM python:alpine3.21@sha256:f9d772b2b40910ee8de2ac2b15ff740b5f26b37fc811f6ada28fce71a2542b0e

WORKDIR /opt/application

ENV PYTHONPATH="/opt/application:${PYTHONPATH}"

COPY requirements.txt .
COPY src src
COPY app app

RUN pip install -r requirements.txt
ENTRYPOINT ["python3", "app/app.py"]
