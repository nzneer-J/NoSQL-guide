# Deploy a Replica set (MongoDB 3.4)


#### 1. replica set의 대상이 되는 모든 서버의 conf 파일에 replica set의 이름을 지정한다.

  + 같은 replica set 안의 member들은 같은 replica set 이름을 가진다.

```
replication:
    replSetName: "<replica-set-name>"
```

#### 2. 수정한 conf 파일로 mongod를 실행한다. (replica set의 각 멤버 모두)

```
mongod --config <config-file-path> &
```

#### 3. replica set 중 하나의 mongo shell 에 접속한다.

```
mongo --host <hostname or ip> --port <port 번호>
```

#### 4. rs.initiate() 함수로 replica set을 초기화 한다.

```
rs.initiate( {
   _id : "rs0",
   members: [
      {_id: 0, host: "hostname1:27017" },
      {_id: 1, host: "hostname2:27017" },
      {_id: 2, host: "hostname3:27017" }
   ]
})
```

* 초기화할 때, 하나의 member만 초기화시키고, 다른 member를 추가할 수 있다.

```
rs.initiate( {
   _id : "rs0",
   members: [
      {_id: 0, host: "hostname1:27017" }
   ]
})
```

```
rs.add("<hostname or ip>:<port번호>")
```

- member가 추가되지 않는다면, 해당 member의 mongod 프로세스가 실행 중인지 확인해보라.
  + mongod 프로세스가 실행 중일 때, mongod conf 파일에 지정된 포트가 열린다.
  <br>

- 성공적으로 초기화되면, primary의 shell에는

```
replName:PRIMARY>
```

- secondary의 shell에는 아래와 같은 표시가 나타난다.

```
replName:SECONDARY>
```

#### 5. replica set의 configuration을 확인할 수 있다.

```
rs.conf()
```

- rs.status로 replica set의 primary를 확인할 수 있다.

#### 6. secondary 서버의 mongo shell 에서 rs.slaveOk()를 실행시켜서 primary의 데이터를 읽어오게 해야 한다.

```
rs.slaveOk()
```
