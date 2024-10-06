FROM python:3.9-alpine
COPY app.py requirements.txt /code/
WORKDIR /code
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
