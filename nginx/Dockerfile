FROM nginx:1.19-alpine

LABEL maintainer="Dots Mesh team <team@dotsmesh.com>"

COPY ./nginx.conf /etc/nginx
COPY ./default-certificate.crt /etc/nginx
COPY ./default-certificate.key /etc/nginx

COPY ./init.sh /docker-entrypoint.d/dotsmesh-init.sh
RUN chmod +x /docker-entrypoint.d/dotsmesh-init.sh

COPY ./check-certificate.sh /dotsmesh-check-certificate.sh
RUN chmod +x /dotsmesh-check-certificate.sh

EXPOSE 80
EXPOSE 443