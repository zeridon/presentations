FROM alpine:3.19
MAINTAINER Vladimir Vitkov <vvitkov@linux-bg.org>

ENV CONSUL_TEMPLATE_VERSION=0.14.0

RUN apk update && \
    apk add bash haproxy ca-certificates zip nginx && \
    rm -rf /var/cache/apk/*

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /
#ADD consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /

RUN unzip /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip  && \
    mv /consul-template /usr/local/bin/consul-template && \
    rm -rf /consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip

RUN mkdir -p /haproxy /consul-template/config.d /consul-template/template.d /thttpd

ADD config/ /consul-template/config.d/
ADD template/*.tmpl /consul-template/template.d/
ADD nginx.conf /thttpd
ADD holding/ /thttpd
ADD launch.sh /launch.sh

CMD ["/launch.sh"]
