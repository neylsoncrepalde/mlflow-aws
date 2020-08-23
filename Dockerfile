FROM python:3.7-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
        python3-dev

RUN pip3 install \
    mlflow \
    pymysql \
    boto3

ARG AWS_ACCESS
ARG AWS_SECRET
ARG DB_PWD

ENV DB_PWD=${DB_PWD}
ENV DB_ENDPOINT=''
ENV BUCKET_NAME=''
ENV AWS_ACCESS_KEY_ID=${AWS_ACCESS}
ENV AWS_SECRET_ACCESS_KEY=${AWS_SECRET}

CMD mlflow server \
    --host 0.0.0.0 \
    --backend-store-uri mysql+pymysql://mlflow:$DB_PWD@$DB_ENDPOINT/mlflow \
    --default-artifact-root s3://${BUCKET_NAME}/artifacts