ARG BASE_IMAGE=python:3.9-buster
FROM --platform=linux/amd64 $BASE_IMAGE


# (Optional) Add extra jars.
# ENV SPARK_EXTRA_JARS_DIR=/opt/spark/jars/
# ENV SPARK_EXTRA_CLASSPATH='/opt/spark/jars/*'
# RUN mkdir -p "${SPARK_EXTRA_JARS_DIR}"
# COPY spark-bigquery-with-dependencies_2.12-0.22.2.jar "${SPARK_EXTRA_JARS_DIR}"

# overwrite default Dataproc PYSPARK_PYTHON path
ENV PYSPARK_PYTHON=/usr/local/bin/python

ENV SPARK_EXTRA_CLASSPATH /usr/local/lib/python3.9/site-packages/pyspark/jars/*

# install project requirements
COPY requirements.txt .
RUN pip install -r requirements.txt

# (Required) Install utilities required by Spark scripts.
RUN apt update && apt install -y procps tini openjdk-11-jre-headless

# (Required) Create the 'spark' group/user.
# The GID and UID must be 1099. Home directory is required.
RUN groupadd -g 1099 spark
RUN useradd -u 1099 -g 1099 -d /home/spark -m spark
#USER spark
