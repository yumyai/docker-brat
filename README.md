brat-docker
================

BRAT annotation tool in docker container. This was modified from https://github.com/tutumcloud/tutum-docker-php


How to use
----------
Need to mount data on /data/
docker run -d -p 80:80 -v /Users/preecha/work/metrecon/VM/brat-dock/example-data:/data1 --name=brat brat

On nginx?
---------

