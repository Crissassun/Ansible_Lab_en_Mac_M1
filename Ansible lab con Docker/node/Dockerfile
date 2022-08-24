FROM ubuntu:latest 
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        aptitude iputils-ping net-tools man vim openssh-server python3  \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh

COPY key.sh /var/ 
RUN chmod 755 /var/key.sh