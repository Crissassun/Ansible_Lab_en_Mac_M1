#!/bin/bash

cat /var/ansible/ansible_key.pub >> /root/.ssh/authorized_keys
/usr/sbin/sshd -D
