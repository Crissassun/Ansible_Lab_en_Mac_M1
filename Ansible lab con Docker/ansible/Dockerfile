FROM ubuntu:latest 
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
        aptitude iputils-ping net-tools man vim openssh-server python3 ansible \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN mkdir /root/.ssh

COPY ansible /var/ansible/
WORKDIR /var/ansible

RUN ssh-keygen -t rsa -N ansible -C "master ansible key" -f ansible_key
