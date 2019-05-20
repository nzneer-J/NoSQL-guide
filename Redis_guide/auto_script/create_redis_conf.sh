#### etc variable
LOCAL_IP=`hostname --ip-address`


#### enter redis port

PORT=$1
if [ -z $PORT ]; then
        echo -n 'Enter Redis Client Port : '
        read PORT
fi

#echo $PORT


#### enter redis conf file path

FILEPATH=$2
if [ -z $FILEPATH ]; then
        echo 'Enter Redis work directory Path : '
        echo -n 'You must enter with out last /. ( ex: /var/run/redis )'
        read FILEPATH
fi


#echo $FILEPATH

sudo cat << EOF > $FILEPATH/redis_$PORT.conf

# port
port $PORT

# work directory
dir $FILEPATH

# cluster setting
cluster-enabled yes
cluster-config-file $FILEPATH/nodes_$PORT.conf
cluster-node-timeout 5000

# backup aof
appendonly yes
appendfilename $PORT.aof

# backup rdb
dbfilename $PORT.rdb
save 900 1
save 300 10
save 60 10000

# daemonize
daemonize yes

# bind ip
bind 127.0.0.1 $LOCAL_IP

# log setting
logfile $FILEPATH/redis_$PORT.log

# pid setting
pidfile $FILEPATH/redis_$PORT.pid

EOF
