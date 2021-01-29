#!/bin/sh

if [ ! -e /tmp/dotsmesh-previous-certificate-md5 ]
then
    echo 'null' > /tmp/dotsmesh-previous-certificate-md5
fi

CURRENT_CERTIFICATE_MD5=`md5sum /dotsmesh-certificates/$HOST/fullchain.pem | awk '{ print $1 }'`

if [[ "$CURRENT_CERTIFICATE_MD5" != "$(cat /tmp/dotsmesh-previous-certificate-md5)" ]]
then
    nginx -s reload
    echo $CURRENT_CERTIFICATE_MD5 > /tmp/dotsmesh-previous-certificate-md5
fi

exit 0