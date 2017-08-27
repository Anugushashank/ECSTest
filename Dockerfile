FROM python

WORKDIR /app

COPY . /app

ENTRYPOINT ["python", "/app/server.py"]