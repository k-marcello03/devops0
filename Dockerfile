# Frontend build lépés Node.js Alpine alapú image-ben
FROM node:16-alpine as frontend-build

WORKDIR /app

RUN apk add --no-cache \
    bash \
    g++ \
    make \
    python3

COPY package.json package-lock.json* ./
RUN npm install

COPY . .
RUN npm run build

# Backend Python Alpine alapú image
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
    make

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

# Frontend build eredmény másolása a frontend build könyvtárából
COPY --from=frontend-build /app/build ./build

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "home.wsgi.prod:application"]
