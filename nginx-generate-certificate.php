<?php

$host = (string)exec('echo $HOST');
if (strlen($host) === 0) {
    echo 'Error: Hostname not found (nginx-generate-certificate.php)!' . "\n";
    exit;
}

$email = (string)exec('echo $CERTIFICATE_EMAIL');
if (strlen($email) === 0) {
    echo 'Error: CERTIFICATE_EMAIL env variable not found (nginx-generate-certificate.php)!' . "\n";
    exit;
}

$domainTestResult = (string)exec('curl -s http://127.0.0.1/.well-known/dotsmesh-status');
if ($domainTestResult !== 'running') {
    echo 'Error: The host is not running (internal check)!' . "\n";
    exit;
}

$domainTestResult = (string)exec('curl -s http://' . $host . '/.well-known/dotsmesh-status');
if ($domainTestResult !== 'running') {
    echo 'Error: The host is not accessible via ' . $host . '! Please check the DNS settings.' . "\n";
    exit;
}

echo 'Requesting a certificate for ' . $host . ' from Let\'s Encrypt!' . "\n";
system('certbot certonly --webroot --webroot-path=/dotsmesh-home/public --email ' . $email . ' --agree-tos --no-eff-email -d ' . $host);
echo 'Certificate request complete!' . "\n";

$sourceDir = '/etc/letsencrypt/live/' . $host;
$targetDir = '/dotsmesh-home/certificates/' . $host;

if (is_file($sourceDir . '/fullchain.pem')) {
    copy($sourceDir . '/fullchain.pem', $targetDir . '/fullchain.pem');
}
if (is_file($sourceDir . '/privkey.pem')) {
    copy($sourceDir . '/privkey.pem', $targetDir . '/privkey.pem');
}
