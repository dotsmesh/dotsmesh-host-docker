#!/bin/sh

/dotsmesh-request-certificate.sh

echo "$(($RANDOM%60)) $(($RANDOM%24)) * * * /dotsmesh-request-certificate.sh" > /etc/crontabs/root

crond -f