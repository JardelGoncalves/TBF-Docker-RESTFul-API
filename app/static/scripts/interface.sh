#!/bin/bash

for c in $(docker ps -q); do
    iflink=`docker exec -it ${c} cat /sys/class/net/eth0/iflink`
    iflink=`echo $iflink|tr -d '\r'`
    veth=`grep -l $iflink /sys/class/net/veth*/ifindex`
    veth=`echo $veth|sed -e 's;^.*net/\(.*\)/ifindex$;\1;'`
    ip=`docker inspect --format '{{range .NetworkSettings.Networks }}{{.IPAddress}}{{end}}' ${c}`
    echo "${c}:${ip}:${veth}"
done
