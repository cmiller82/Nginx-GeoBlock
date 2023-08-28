# Nginx-GeoBlock
Alpine Docker Container with Nginx and Maxmind Geography/Country Blocking

Make the changes to the config files and download the Maxmind database.

```
docker build \
	-t loadbalancer:<TAG> -f Dockerfile .
```
```
#docker run -it --rm --entrypoint=/bin/sh \ #replace the first line for testing
docker run -d \
    --mount type=bind,src=/home/adminuser/testblock/deploy/stage2/nginx.conf,dst=/etc/nginx/nginx.conf \
    --mount type=bind,src=/home/adminuser/testblock/deploy/stage2/GeoIP.conf,dst=/etc/nginx/http.d/GeoIP.conf \
    --mount type=bind,src=/home/adminuser/testblock/deploy/stage2/GeoLite2-Country.mmdb,dst=/var/lib/nginx/http.d/GeoLite2-Country.mmdb \
    --mount type=bind,src=/home/adminuser/testblock/deploy/stage2/default-test.conf,dst=/etc/nginx/http.d/default.conf \
    -p 8095:80 \
    loadbalancer:<TAG>
```
Service create statement for Swarm:
```
docker service create --name loadbalancer-prod --network frontend --replicas 1 \
    --config source=env.loadbalancer-nginx.conf.prod.1,target=/etc/nginx/nginx.conf \
    --config source=env.loadbalancer-default.conf.prod.1,target=/etc/nginx/http.d/default.conf \
    --config source=env.loadbalancer-geoip.conf.prod.1,target=/etc/nginx/http.d/GeoIP.conf \
    --mount type=bind,source=/home/gitlab-runner/deploy/prod/loadbalancer/http.d/GeoLite2-Country.mmdb,destination=/var/lib/nginx/http.d/GeoLite2-Country.mmdb \
    --mount type=volume,source=sy-currency-icons-assetroot-prod,dst=/srv/static-assets \
    --publish 80:80 \
    loadbalancer:<TAG>
```