FROM python:3.8-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apk add --no-cache \
    gcc \
    musl-dev \
    python3-dev \
    libffi-dev \
    openssl-dev \
    make \
    nodejs \
    npm

# requirements.txt a gyökérben van
COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Az összes forrásfájl és mappa bemásolása a konténerbe
COPY . .

# A frontend buildelése - ha frontend fájlok is egy szinten vannak pl. package.json, src/
WORKDIR /app
RUN npm install && npm run build

# Vissza a backend root mappához
WORKDIR /app

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "home.wsgi.prod:application"]
