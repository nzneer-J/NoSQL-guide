## mongodump와 mongorestore를 이용한 백업/복구

<br>

#### mongodump로 데이터베이스 백업 만들기

```
mongodump --host <hostIp> --port <port 번호> --out <data file path> --oplog
```

<br>
- query를 이용하여 특정 document에 대해서만 백업이 가능하지만, 그 경우 collection을 특정해줘야 한다....
- 유
#### mongorestore로 데이터베이스 복구

- primary에서 실행, database가 없는 상황에서 가능

```
mongorestore --host <primary의 ip> --port <port 번호> --oplogReplay <data file path>
```

- 마지막 매개변수로 path를 지정하는 것과 --dir로 path를 지정하는 것은 같다.
- 복원 시, -d 나 -c 옵션으로 데이터베이스나 콜렉션 지정이 가능한데, 이를 사용할 때, 복원 파일 경로 사용에 주의해야 한다.


_error: Writes to config servers must have batch size of 1, found 3 에러 발생 시,_

```
--batchSize=1 옵션 사용
```

_error: multiple errors in bulk operation:  E11000 duplicate key error collection: 에러 발생 시,_

```
use <복구할 DB>
db.dropDatabase()
```

<br>

#### 일부 데이터베이스와 콜렉션 백업

```
mongodump --collection <collection 이름> --db <DB 이름>
mongodump -c 콜렉션 이름 -d db이름
```

## Sharded Cluster 백업  (mongodump)

<br>

#### 1. balancer를 Disable하게 한다.

- mongos의 mongo shell에서

```
use config
sh.stopBalancer()
```

<br>

#### 2. 각 replica set의 secondary 멤버 Lock

- config server의 경우, Lock하기 전에 다음과 같은 절차를 거친다.
  + config server의 primary에서

```
    db.BackupControl.findAndModify(
    {
        query: {_id: 'BackupControlDocument' },
        update: { $inc: { counter : 1 } },
        new: true,
        upsert: true,
        writeConcern: { w: 'majority', wtimeout: 15000 }
    });
```

  + 다음이 출력되는지 확인

```
  { "_id" : "BackupControlDocument", "counter" : 1 }
```

  + secondary로 이동하여 다음을 확인

```
rs.slaveOk();
use config;
db.BackupControl.find(
   { "_id" : "BackupControlDocument", "counter" : 1 }
).readConcern('majority');
```

  + Lock 설정

```
db.fsyncLock()
```

- 각 Shard replica set의 secondary 멤버를 Lock 한다.

```
db.fsyncLock()
```

<br>

#### 3. config server와 각 shard의 replica set 중 각각 하나씩 백업

```
mongodump --host <hostIp> --port <port 번호> --out <data file path> --oplog
```

- Unlock replica set

```
db.fsyncUnlock()
```

## Sharded Cluster 복구  (mongorestore)

<br>

#### 1. 새로운 클러스터 생성 또는 모든 클러스터 db 제거

- shard replica set 구성
- config server replica set 구성
- mongos 프로세스 시작
- 클러스터에 샤드 추가

<br>

#### 2. 모든 mongos shut down

```
use admin
db.shutdownServer()
```

<br>

#### 3. --drop 옵션과 함께, shard 데이터 복구

```
mongorestore --drop --host <primary의 ip> --port <port 번호> --oplogReplay <data file path>
```

- 복구 완료 후, shard instance shut down

```
use admin
db.shutdownServer()
```

<br>

#### 4. 마찬가지로 config server 복구
  + config server는 --drop 옵션이 사용되지 않는다???ㅔㄴ

```
mongorestore --drop --host <primary의 ip> --port <port 번호> --oplogReplay <data file path>
```

<br>

#### 5. mongos 다시 실행

<br>

#### 6. hostname 등의 수정사항이 있을 시, config 데이터 update

- config Database 관련 내용 : https://docs.mongodb.com/v3.4/reference/config-database/#config-database

<br>

#### 7. shard mongod 재시작 및 다른 mongos 재시작

<br>

#### 8. 클러스터 복구 확인

- mongos

```
db.printShardingStatus()
```

- mongod

```
show collections
```
