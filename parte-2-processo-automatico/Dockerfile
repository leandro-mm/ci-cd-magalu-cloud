FROM python:3.12-slim

WORKDIR /app

COPY parte-2-processo-automatico/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY parte-2-processo-automatico/app.py . 

EXPOSE 5000

CMD ["python", "app.py"]
