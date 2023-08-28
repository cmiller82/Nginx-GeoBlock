# Pull Alpine:3 and install nginx with geoip2 to use Maxmind Database.
# Create an account at maxmind.com and download the free Lite country database

FROM alpine:3

RUN apk update
RUN apk add --no-cache curl ca-certificates nano

RUN apk add nginx nginx-mod-http-geoip2

RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

#Required mounts.
# /etc/nginx/nginx.conf
# /etc/nginx/.htpasswd (Optional)
# /etc/nginx/http.d/default.conf
# /etc/nginx/http.d/GeoIP.conf
# /var/lib/nginx/http.d/GeoLite2-Country.mmdb

CMD ["nginx"]

