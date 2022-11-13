<?php

$host = (string)exec('echo $HOST');
if (strlen($host) === 0) {
    echo 'Error: Hostname not found (nginx-check-certificate.php)!' . "\n";
    exit;
}

$lastReloadVersionFilename = '/tmp/dotsmesh-nginx-last-reload-certificate-md5';
$lastReloadVersion = is_file($lastReloadVersionFilename) ? file_get_contents($lastReloadVersionFilename) : '';

$defaultCertificateFilename = '/nginx-default-certificate.crt';
$defaultCertificate = is_file($defaultCertificateFilename) ? file_get_contents($defaultCertificateFilename) : '';

$getHostCertificate = function () use ($host) {
    $hostCertificateFilename = '/dotsmesh-home/certificates/' . $host . '/fullchain.pem';
    return is_file($hostCertificateFilename) ? file_get_contents($hostCertificateFilename) : '';
};
$hostCertificate = $getHostCertificate();

if ($defaultCertificate === $hostCertificate) { // is default certificate
    system('php81 /nginx-generate-certificate.php'); // try generate
    $hostCertificate = $getHostCertificate();
}

$hostCertificateVersion = md5($hostCertificate);
if ($lastReloadVersion !== $hostCertificateVersion && $hostCertificate !== $defaultCertificate) {
    system('nginx -s reload');
    file_put_contents($lastReloadVersionFilename, $hostCertificateVersion);
    echo 'New certificate found and applied!' . "\n";
}
