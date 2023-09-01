#!/bin/bash

USERNAME=${USERNAME:-user}
PASSWORD=${PASSWORD:-user}

useradd -s /bin/bash -m $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd

/usr/sbin/sshd -D -e
