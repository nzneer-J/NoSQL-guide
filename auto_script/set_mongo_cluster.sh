#! /bin/bash

MONGODB_PATH="/database/mongodb"

echo "All mongo replica set member started?"
echo "If not, cancel this script"
echo ""
echo "Do you want to set sharded cluster? ( if you enter 'n', set just replica set)"
echo -n "(y / n)"
read checkCase

if [ -n "$1" ]; then
PRI_IP=$1

SECON_IP1=$2

SECON_IP2=$3

else
echo -n "Enter primary IP : (this Server's IP)"
read PRI_IP

echo -n "Enter secondary 1's IP : "
read SECON_IP1

echo -n "Enter secondary 2's IP : "
read SECON_IP2

fi

echo -n "Enter admin user name:"
read username
echo -n "Enter admin user password:"
read userpwd



if [ $checkCase = "y" ]
then

MONGOS_PATH="$MONGODB_PATH/conf/mongos.conf"

sudo sed -i 's/#sharding:/sharding:/g' $MONGOS_PATH
sudo sed -i "s/#  configDB:/  configDB: replconfigsvr\/$PRI_IP:27019,$SECON_IP1:27019,$SECON_IP2:27019/g" $MONGOS_PATH

echo "modify $MONGODB_PATH/conf/mongos.conf"

mongo --port 27019 --eval "rs.initiate({_id : \"replconfigsvr\",configsvr: true, members: [{_id : 0 , host : \"$PRI_IP:27019\"}] })"
sleep 5
mongo --port 27019 --eval "rs.add(\"$SECON_IP1:27019\")"
sleep 5
mongo --port 27019 --eval "rs.add(\"$SECON_IP2:27019\")"
sleep 5

echo "initiate replica set of configsvr (27019) "

mongo --port 27018 --eval "rs.initiate({_id : \"replshard1\", members: [{_id : 0 , host : \"$PRI_IP:27018\"}] })"
sleep 5
mongo --port 27018 --eval "rs.add(\"$SECON_IP1:27018\")"
sleep 5
mongo --port 27018 --eval "rs.add(\"$SECON_IP2:27018\")"
sleep 5
mongo --port 27018 --eval "db.getSiblingDB('admin').createUser({user: '$username', pwd: '$userpwd', roles: [{role: 'root', db: 'admin'}]})"

echo "initiate replica set of shardsvr (27018) "

systemctl start mongos.service
sleep 5

echo "start mongos service"

mongo --port 27017 --eval "sh.addShard(\"replshard1/$PRI_IP:27018\")"

mongo --port 27017 --eval "db.getSiblingDB('admin').createUser({user: '$username', pwd: '$userpwd', roles: [{role: 'root', db: 'admin'}]})"

echo "Add shardsvr & create admin user"

elif [ $checkCase = "n" ]
then

mongo --port 27018 --eval "rs.initiate({_id : \"replshard1\", members: [{_id : 0 , host : \"$PRI_IP:27018\"}] })"
sleep 5
mongo --port 27018 --eval "rs.add(\"$SECON_IP1:27018\")"
sleep 5
mongo --port 27018 --eval "rs.add(\"$SECON_IP2:27018\")"
sleep 5

echo "initiate replica set of shardsvr (27018) "

mongo --port 27018 --eval "db.getSiblingDB('admin').createUser({user: '$username', pwd: '$userpwd', roles: [{role: 'root', db: 'admin'}]})"

echo "create admin user"

else
echo "invaild value input. please restart script"
fi

