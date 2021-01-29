#!/bin/sh

mkdir -p /dotsmesh-certificates/$HOST

if [ ! -e /dotsmesh-certificates/$HOST/fullchain.pem ]
then
    cp /etc/nginx/default-certificate.crt /dotsmesh-certificates/$HOST/fullchain.pem
fi

if [ ! -e /dotsmesh-certificates/$HOST/privkey.pem ]
then
    cp /etc/nginx/default-certificate.key /dotsmesh-certificates/$HOST/privkey.pem
fi

sed -i "s/DOTSMESH_HOST/$HOST/g" /etc/nginx/nginx.conf

if [ -e /dotsmesh-home/public/index.php ]
then
    echo "The Dots Mesh host software is already installed!"
else
    echo "Downloading the Dots Mesh installer ...";
    mkdir -p /dotsmesh-home
    chmod 777 /dotsmesh-home
    mkdir -p /dotsmesh-home/public
    chmod 777 /dotsmesh-home/public
    cd /dotsmesh-home/public
    curl -s -O https://downloads.dotsmesh.com/dotsmesh-installer.php
    chmod 777 dotsmesh-installer.php
    echo "{\"dir\":\"/dotsmesh-home/dotsmesh\"}" > dotsmesh-installer-environment.json
    chmod 777 dotsmesh-installer-environment.json
    echo "The Dots Mesh installer is now available at https://$HOST/dotsmesh-installer.php";
fi

echo "* * * * * /dotsmesh-check-certificate.sh" > /etc/crontabs/root

crond -b