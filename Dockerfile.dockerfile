FROM python:latest

RUN pip install --upgrade pip && \
    pip install pandas