# 42Cyber-ft_onion

Onion website accessible with Tor using Nginx as web server, and, SSH access over the 4242 port.

## Project Rules

You must run a web server that shows a webpage on the Tor network.

- The service must have a static web page: a single index.html file. The page will
be accessible through a url of the type xxxxxxxxx.onion. The content displayed
on the page is up to you.
- Nginx will be used to configure the web server. No other server or framework is
allowed.
- Access to the static page via HTTP on port 80 must be enabled.
- Access to the server via SSH on port 4242 must be enabled.
- You should not open any ports or set any firewall rules.

``` text
|-----------------|
| Files to submit |
|-----------------|
|    index.html   |
|    nginx.conf   |
|    sshd_config  |
|      torrc      |
|-----------------|
```

## Run the project with docker

Before building, creaye a `secrets` folder on the root of the project and add your public ssh key to it.

Build the project with `docker build -t somedevv/ft_onion .`

Run the container with `docker run -d -p 80:80 -p 4242:4242 --name ft_onion somedevv/ft_onion`

Connect over ssh with `ssh -i ~/.ssh/id_rsa sshuser@localhost -p 4242`

To access the onion service use a Tor compatible browser. Look for the onion address in the container execution logs.

``` text
[...]
Onion address URL: http://xxxxxxxxx.onion
```
