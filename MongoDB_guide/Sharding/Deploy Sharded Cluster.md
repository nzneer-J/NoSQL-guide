# Deploy Sharded Cluster

config server 3개의 replica set과 shard에 지정될 replica set이 필요하다.

- config server의 경우, 3개가 아니면 mongos 프로세스를 실행할 때, 에러 메시지를 보게 된다.
- config server와 shard replica set은 mongod 프로세스로 실행된다. (dbpath를 지정할 수 있다.)

Query Router는 mongos 프로세스로 실행된다.

```
mongos --host <hostname> --port <port 번호>
```

- mongos는 conf 파일에 dbpath를 지정하지 않는다.



## 1. Config Server Replica Sets

- 각 멤버의 conf 파일 설정
  + 아래 내용 외에 기본적으로 dbpath와 systemlog의 path 지정해야 한다.

```
net:
  port: <port 번호>
  bindIp: <IP list>
sharding:
  clusterRole: configsvr
replication:
  replSetName: <setname>
```

- mongod 프로세스 실행 (모든 멤버의 프로세스 실행)

```
mongod --config <path-to-config-file>
```

- mongo shell 접속

```
mongo --host <hostname> --port <port>
```

- replica set 초기화 (primary 서버에서만 실행하면 된다.)

```
rs.initiate(
  {
    _id: "<replSetName>",
    configsvr: true,
    members: [
      { _id : 0, host : "<configHostname1>:<port 번호>" },
      { _id : 1, host : "<configHostname2>:<port 번호>" },
      { _id : 2, host : "<configHostname3>:<port 번호>" }
    ]
  }
)
```

또는 일부 멤버만 초기화한 뒤, rs.add()로 추가 가능


## 2. Create the Shard Replica Sets

- 각 멤버의 conf 파일 설정
  + 아래 내용 외에 기본적으로 dbpath와 systemlog의 path는 지정해야 한다.

```
net:
  port: <port 번호>
  bindIp: <IP list>
sharding:
  clusterRole: shardsvr
replication:
  replSetName: <replSetName>
```

- mongod 프로세스 실행 (모든 멤버의 프로세스 실행)

```
mongod --config <path-to-config-file>
```

- mongo shell 접속

```
mongo --host <hostname> --port <port>
```

- replica set 초기화 (primary 서버에서만 실행하면 된다.)

```
rs.initiate(
  {
    _id: "<replSetName>",
    members: [
      { _id : 0, host : "<shardHostname1>:<port 번호>" },
      { _id : 1, host : "<shardHostname2>:<port 번호>" },
      { _id : 2, host : "<shardHostname3>:<port 번호>" }
    ]
  }
)
```

또는 일부 멤버만 초기화한 뒤, rs.add()로 추가 가능


## 3. Connect a mongos to the Sharded Cluster

- conf 파일의 shard 부분에 config server replica set을 지정한다.
  + 아래 내용 외에 systemlog의 path는 지정해야 한다. (dbpath는 없어야 한다.)

```
net:
  port: <port 번호>
  bindIp: <IP list>
sharding:
  configDB: <configReplSetName>/<configHostname1>:<port번호>,<configHostname2>:<port번호>,...
```

- mongos를 실행

```
mongos --config \<path-to-config>
```

- mongos의 mongo shell 접속

```
mongo --host \<hostname> --port <\port>
```

- cluster에 shard 추가

```
sh.addShard( "<ShardReplSetName>/<shardHostname>:<port번호>")
```

- database를 sharding 가능하게 설정

```
sh.enableSharding("<database>")
```

- collection을 sharding 하기 위한 key 설정
  + Hashed Sharding

```
  sh.shardCollection("<database>.<collection>", { <key> : "hashed" } )
```

  + Ranged Sharding

```
  sh.shardCollection("<database>.<collection>", { <key> : <direction> } )
```

    + collection에 데이터가 없는 경우에는 자동으로 shard key가 생성되지만, 데이터가 있는 경우 index를 생성하고, shard key 설정을 해줘야 한다.

        ```
        db.collection.createIndex( { "index" : 1 } )
        ```
