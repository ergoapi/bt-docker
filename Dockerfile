FROM spanda/ptcore:latest

LABEL MAINTAINER="ysicing"

RUN mkdir /install /var/run/sshd

ADD . /install/

WORKDIR /install/

RUN bash +x /install/prepare.sh

RUN bash +x /install/init.sh

ENTRYPOINT ["/install/entrypoint.sh"]

CMD ["/usr/sbin/sshd", "-D"]
