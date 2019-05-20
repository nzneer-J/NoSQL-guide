#!/bin/bash

sudo yum install make
sudo yum install gcc
sudo yum install tcl
sudo yum install build-essential

wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
make test

sudo cp src/redis-server /usr/local/bin/
sudo cp src/redis-cli /usr/local/bin/
sudo cp src/redis-server /usr/bin/
sudo cp src/redis-cli /usr/bin/


sudo mkdir /etc/redis
sudo mkdir /var/redis

sudo cp utils/redis_init_script /etc/init.d/redis_6379

sudo cp redis.conf /etc/redis/6379.conf

sudo mkdir /var/redis/6379

## add OS config

# vm.overcommit = 1 (always overcommit)
sysctl vm.overcommit_memory=1

sudo cat << EOF >> /etc/sysctl.conf
vm.overcommit_memory = 1
EOF

# THP disable
echo never > /sys/kernel/mm/transparent_hugepage/enabled

sudo cat << EOF >> /etc/rc.local
echo never > /sys/kernel/mm/transparent_hugepage/enabled
EOF

# somaxconn , tcp_max_syn_backlog
sysctl -w net.core.somaxconn=1024
sysctl -w net.ipv4.tcp_max_syn_backlog=1024

sudo cat << EOF >> /etc/sysctl.conf
net.core.somaxconn = 1024
net.ipv4.tcp_max_syn_backlog = 1024
EOF
