FROM python:3.11-alpine
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
RUN apk add --no-cache \
    build-base \
    libffi-dev \
    sqlite-dev \
    zlib-dev \
    jpeg-dev
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


FROM python:3.11-alpine
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
RUN apk add --no-cache \
    libffi \
    sqlite-libs \
    jpeg
COPY . /app
RUN DJANGO_SECRET_KEY="dummy" \
    HASHIDS_SALT="dummy" \
    python manage.py collectstatic --noinput
EXPOSE 8000
ENTRYPOINT ["scripts/entrypoint.sh"]
CMD ["daphne", "-b", "0.0.0.0", "-p", "8000", "main.asgi:application"]
