FROM nginx:1.19

LABEL org.opencontainers.image.description "nginx image for staging environment."

COPY ./etc/nginx.conf /etc/nginx/nginx.conf
COPY ./etc/vhost.conf /etc/nginx/conf.d/default.conf

WORKDIR /var/www/html
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
