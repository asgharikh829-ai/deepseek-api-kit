FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    DOCKERMODE=true

WORKDIR /app

# Chromium + runtime libraries for the optional Cloudflare cookie helper.
RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    xvfb \
    ca-certificates \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

# Render provides PORT at runtime.
CMD sh -c 'uvicorn openai_proxy.main:app --host 0.0.0.0 --port ${PORT:-8000}'
