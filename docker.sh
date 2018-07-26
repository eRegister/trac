#!/usr/bin/env bash
export container_name=trac
export https_port=443
export http_port=80

if sudo docker ps | grep ${container_name}; then
   sudo docker stop "${container_name}" | sudo xargs docker rm
else
  echo "Container not exists"
fi

if sudo docker ps | grep ${container_name}; then
   sudo docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs sudo docker rm
else
  echo "Exit container not present"
fi

if sudo docker images | grep ${container_name}; then
   sudo docker rmi $(sudo docker images | grep ${container_name} | tr -s ' ' | cut -d ' ' -f 3)
else
  echo "Image doesn't exists"
fi
docker build --rm -t trac --build-arg container_name=${container_name} .
docker run -e container_name=${container_name} -it -d -p ${https_port}:443 -p ${http_port}:80 --privileged --name $container_name trac /bin/bash
