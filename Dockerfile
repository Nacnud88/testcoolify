FROM python:3.11-slim

# system deps
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

# app
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# runtime env
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=8000 \
    GUNICORN_WORKERS=2 \
    GUNICORN_THREADS=4 \
    GUNICORN_TIMEOUT=60

EXPOSE 8000

# Gunicorn binds to 0.0.0.0 so Traefik can reach it
CMD gunicorn -w $GUNICORN_WORKERS --threads $GUNICORN_THREADS \
    --timeout $GUNICORN_TIMEOUT \
    -b 0.0.0.0:$PORT wsgi:app
