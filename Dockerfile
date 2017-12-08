FROM alpine:3.6

RUN apk --no-cache add python3 py3-pip bash
RUN pip3 install docker-squash

ADD squa.sh /usr/bin

ENTRYPOINT ["/usr/bin/squa.sh"]
