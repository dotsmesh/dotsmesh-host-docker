FROM alpine:3.13

LABEL maintainer="Dots Mesh team <team@dotsmesh.com>"

RUN apk --no-cache add certbot

COPY ./request-certificate.sh /dotsmesh-request-certificate.sh
RUN chmod +x /dotsmesh-request-certificate.sh

COPY ./init.sh /dotsmesh-init.sh
RUN chmod +x /dotsmesh-init.sh

CMD ["/dotsmesh-init.sh"]