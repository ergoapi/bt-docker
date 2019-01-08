FROM spanda/ptcore:latest

LABEL MAINTAINER="ysicing"

RUN mkidr /install

ADD . /install/

WORKDIR /install/

RUN bash +x /install/prepare.sh

VOLUME [ "/www" ]

RUN bash +x /install/init.sh

