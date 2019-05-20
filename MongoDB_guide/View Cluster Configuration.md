# View Cluster Configuration

mongos 의 mongo shell로 접속하여 명령어를 실행한다.

- 아래 명령어로 sharding enabled한 database list를 가져올 수 있다.

```
use config
db.databases.find({ "partitioned": true })
```

  + 다음은 cluster의 모든 database list를 가져온다.

```
    db.databases.find()
```

- 모든 shard list를 가져온다.

```
db.adminCommand( { listShards : 1 } )
```

- db.printShardingStatus() 또는 sh.status()를 사용하여 cluster의 detail을 확인할 수 있다.

```
db.printShardingStatus()
```

```
sh.status()
```


- 기본 명령어 목록
```
use config
db.shards.find()
db.databases.find()
db.chunks.find()
db.printShardingStatus()
```
