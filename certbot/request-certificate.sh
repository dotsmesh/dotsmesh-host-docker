#!/bin/sh

echo "Requesting a certificate for $HOST";
certbot certonly --webroot --webroot-path=/dotsmesh-home/public --email $CERTIFICATE_EMAIL --agree-tos --no-eff-email -d $HOST
echo "Certificate request complete for $HOST!";

if [ -e /etc/letsencrypt/live/$HOST/fullchain.pem ]
then
    cp -rfL /etc/letsencrypt/live/$HOST/fullchain.pem /dotsmesh-certificates/$HOST/fullchain.pem
fi

if [ -e /etc/letsencrypt/live/$HOST/privkey.pem ]
then
    cp -rfL /etc/letsencrypt/live/$HOST/privkey.pem /dotsmesh-certificates/$HOST/privkey.pem
fi