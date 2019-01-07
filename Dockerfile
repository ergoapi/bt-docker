FROM spanda/ptcore:latest

LABEL MAINTAINER="ysicing"

ADD . /tmp/

VOLUME [ "/www" ]

RUN bash +x /tmp/install.sh

