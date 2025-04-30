FROM alpine:3.20.6

# Install Nginx, OpenSSL, and Bash
RUN apk update && \
    apk add nginx openssl bash

#generate SSL certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/nginx.key \
        -out /etc/nginx/ssl/nginx.crt \
        -subj "/CN=localhost"

#create simple HTML page
RUN mkdir -p /var/www/html && \
    echo "<h1>Hello from NGINX in Docker!</h1>" > /var/www/html/index.html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]

