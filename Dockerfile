FROM ubuntu:20.04

RUN apt-get update && apt-get install -y python3 python3-pip

RUN pip3 install flask

WORKDIR /opt
COPY app.py .

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=8080

EXPOSE 8080

CMD ["flask", "run"]
