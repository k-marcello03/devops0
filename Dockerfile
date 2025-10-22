FROM python:3.8-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Telepítsük a szükséges csomagokat: Python build tools + Node.js és npm a frontendhez
RUN apk add --no-cache \
    bash \
    gcc \
    g++ \
    make \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev \
    nodejs \
    npm

# Backend függőségek telepítése
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# A teljes projekt fájlokat bemásoljuk
COPY . .

# Frontend buildelése: lépj be a frontend mappába, futtasd az npm parancsokat
WORKDIR /app
RUN npm install
RUN npm run build

# Vissza a backend mappába (feltételezve, hogy a manage.py itt van)
WORKDIR /app
EXPOSE 8000

# Indítsd el a production szervert Gunicornnal, a megfelelő WSGI modult használva
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "home.wsgi.prod:application"]
