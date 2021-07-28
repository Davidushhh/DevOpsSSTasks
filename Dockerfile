FROM alpine 

RUN apk --no-cache upgrade

RUN apk add apache2

RUN echo 'Hello world from Docker!' > /var/www/localhost/htdocs/index.html

EXPOSE 80

CMD ["-D","FOREGROUND"]

ENTRYPOINT ["/usr/sbin/httpd"]
