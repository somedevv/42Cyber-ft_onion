FROM debian:bullseye-slim
EXPOSE 4242
EXPOSE 80
LABEL maintainer "some@somedevv.com"

# Install main dependencies
RUN apt-get update && \
	apt-get install openssh-server nginx apt-transport-https gpg curl libevent-dev -y

# Configure Tor repositories
RUN echo "deb https://deb.torproject.org/torproject.org bullseye main\n deb-src https://deb.torproject.org/torproject.org bullseye main" >> /etc/apt/sources.list && \
	curl https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --import && \
	gpg --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | apt-key add -

# Install Tor dependencies and remove unnecessary packages
RUN apt-get update && \
	apt-get install tor deb.torproject.org-keyring -y && \
	apt-get autoremove

# Create sshuser and configiture ssh
RUN groupadd sshgroup && \
	useradd -ms /bin/bash -g sshgroup sshuser && \
	mkdir -p /home/sshuser/.ssh
COPY ./secrets/id_rsa.pub /home/sshuser/.ssh/authorized_keys
RUN chown sshuser:sshgroup /home/sshuser/.ssh/authorized_keys && \
	chmod 600 /home/sshuser/.ssh/authorized_keys
COPY ./configs/sshd_config 	/etc/ssh
RUN service ssh start

# Configure nginx logs to go to Docker log collection (via stdout/stderr)
RUN ln --symbolic --force /dev/stdout /var/log/nginx/access.log
RUN ln --symbolic --force /dev/stderr /var/log/nginx/error.log

# Configure nginx server
COPY ./configs/nginx.conf /etc/nginx/nginx.conf
COPY ./configs/server_conf /etc/nginx/sites-available/default
COPY ./web/index.html /usr/share/nginx/html/index.html
RUN echo "PrivateNetwork=yes" >> /lib/systemd/system/nginx.service

# Configure tor server
COPY ./configs/torrc /etc/tor/torrc
RUN chown root /var/lib/tor

COPY ./scripts/start-services.sh start-services.sh
RUN chmod 700 start-services.sh
CMD ./start-services.sh