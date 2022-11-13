#!/bin/sh

if [ -d /dotsmesh-home ]
then
    echo "Preparing $HOST ..."

    mkdir -p /dotsmesh-home/public

    cp /nginx-vhost-80.conf /etc/nginx/vhost-80.conf
    sed -i "s/DOTSMESH_HOST/$HOST/g" /etc/nginx/vhost-80.conf
    echo "Port 80 enabled!"

    if [[ "$HTTPS" = "on" ]]
    then
        mkdir -p /dotsmesh-home/certificates/$HOST
        if [ ! -e /dotsmesh-home/certificates/$HOST/fullchain.pem ]
        then
            cp /nginx-default-certificate.crt /dotsmesh-home/certificates/$HOST/fullchain.pem
        fi
        if [ ! -e /dotsmesh-home/certificates/$HOST/privkey.pem ]
        then
            cp /nginx-default-certificate.key /dotsmesh-home/certificates/$HOST/privkey.pem
        fi
        cp /nginx-vhost-443.conf /etc/nginx/vhost-443.conf
        sed -i "s/DOTSMESH_HOST/$HOST/g" /etc/nginx/vhost-443.conf
        echo "* * * * * php81 /nginx-check-certificate.php" > /etc/crontabs/root
        echo "$(($RANDOM%60)) $(($RANDOM%24)) * * * php81 /nginx-generate-certificate.php" >> /etc/crontabs/root
        echo "Port 443 (HTTPS) enabled! Will try to generate a certificate in a minute."
    fi

    if [ -e /dotsmesh-home/public/index.php ]
    then
        echo "The Dots Mesh host software is already installed!"
    else
        echo "Downloading the Dots Mesh installer ..."
        cd /dotsmesh-home/public
        curl -s -O https://downloads.dotsmesh.com/dotsmesh-installer.php
        chmod 777 dotsmesh-installer.php
        echo "{\"dir\":\"/dotsmesh-home/dotsmesh\"}" > dotsmesh-installer-environment.json
        chmod 777 dotsmesh-installer-environment.json
        echo "Downloaded!"
        echo "Please visit https://$HOST/dotsmesh-installer.php";
    fi

    echo "Completed!"

    crond -f & php-fpm81 -F & nginx -g 'daemon off;' & wait -n
    exit $?
else
    echo "Error: No volume mapped to /dotsmesh-home !"
fi