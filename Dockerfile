FROM ubuntu:18.04

ADD . /u18java

RUN /u18java/install.sh && rm -rf /tmp && mkdir /tmp && chmod 1777 /tmp

ENV BASH_ENV "/etc/drydock/.env"
