FROM python:3.11-alpine

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
RUN apk add --no-cache --virtual .build-deps gcc musl-dev python3-dev libffi-dev openssl-dev make
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN apk del .build-deps
ENV DJANGO_SETTINGS_MODULE=devops0.settings
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "devops0.wsgi:application"]
