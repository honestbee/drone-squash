FROM docker:17.10.0-ce-dind

RUN apk --no-cache add python3 py3-pip bash docker
RUN pip3 install docker-squash

ADD squa.sh /usr/bin

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh", "/usr/bin/squa.sh"]
