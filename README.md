# Docker image for a Dots Mesh host

Easily launch a [Dots Mesh](https://about.dotsmesh.com/) host on your own server.

## Requirements

### 1. A server on the Internet

The server must run the [Docker](https://www.docker.com/) engine and have a public IP address.

### 2. A subdomain (dotsmesh.example.com)

Configure the subdomain to point to the server. The subdomain name must start with 'dotsmesh.'. What's after the first part will be used for the users' IDs (john.example.com).

## Setup

### 1. Create a directory where the host data will be stored

```sh
mkdir /dotsmesh-host-storage
chmod 777 /dotsmesh-host-storage
```

### 2. Start the Docker container

HTTPS is a requirement and you have two options to support secure connections:

#### Let the container handle all HTTP and HTTPS requests

This may be the easiest option, but you must make sure ports 80 and 443 are available. An SSL/TLS certificate will be requested from [Let's Encrypt](https://letsencrypt.org/).

Replace with correct values:
- the data directory (/dotsmesh-host-storage)
- the hostname (dotsmesh.example.com)
- the email address that will be sent to Let's Encrypt (example@example.com)

```sh
docker run -d --name my-dotsmesh-host --pull always --restart on-failure:3 -v /dotsmesh-host-storage:/dotsmesh-home -p 80:80 -p 443:443 -e HOST=dotsmesh.example.com -e HTTPS=on -e CERTIFICATE_EMAIL=example@example.com dotsmesh/dotsmesh-host:latest
```

#### Use a proxy server

You may have a proxy server that's responsible for SSL termination and port forwarding. In this case, start a container that only listens on port 80 (HTTP).

Replace with correct values:
- the data directory (/dotsmesh-host-storage)
- the hostname (dotsmesh.example.com)

```sh
docker run -d --name my-dotsmesh-host --pull always --restart on-failure:3 -v /dotsmesh-host-storage:/dotsmesh-home -p 80:80 -e HOST=dotsmesh.example.com dotsmesh/dotsmesh-host:latest
```

Then configure the proxy server.

### 3. Run the installer

Visit https://dotsmesh.example.com/dotsmesh-installer.php (replace dotsmesh.example.com with your domain) to run the Dots Mesh installer.

## Under the hood

The container will run Alpine, NGINX, PHP, and the Let's Encrypt bot that will check and update the SSL certificate regularly.

When started for the first time a Dots Mesh installer will be downloaded.

## Updates

It's recommended you rebuild the container regularly to get the latest Alpine, NGINX, and PHP updates. The Dots Mesh software will auto-update (if enabled from the admin panel).

## Supported architectures
linux/amd64, linux/arm64, linux/386, linux/arm/v7, linux/arm/v6

## Contributing
Feel free to open new issues and contribute to the repo.

## Maintained by
The Dots Mesh team
