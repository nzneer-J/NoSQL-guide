# 3.11 버전 설치 (<release series> = 311x)
# For older releases, the <release series> can be one of 30x, 22x, or 21x

sudo cat << EOF > /etc/yum.repos.d/cassandra.repo
[cassandra]
name=Apache Cassandra
baseurl=https://www.apache.org/dist/cassandra/redhat/311x/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://www.apache.org/dist/cassandra/KEYS
EOF

yum install cassandra


# http://cassandra.apache.org/download/
