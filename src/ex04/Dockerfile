FROM nginx
RUN apt-get update && apt-get install -y gcc spawn-fcgi libfcgi-dev
EXPOSE 81
COPY hello.c /
COPY nginx.conf etc/nginx
RUN gcc hello.c -o hello -lfcgi
ENTRYPOINT spawn-fcgi -p 8080 ./hello && nginx -g 'daemon off;'