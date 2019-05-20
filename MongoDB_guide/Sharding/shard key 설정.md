# shard key 설정

### 1. index 생성

```
db.collection.createIndex({<key>: 1})
```

### 2. index 확인

```
db.collection.ensureIndexes(<key>: "hashed")
```

### 3. shard key 생성

```
sh.shardCollection("<database>.<collection>, { <key> : "hashed"  }")
```

```
sh.shardCollection("<database>.<collection>, { <key> : 1  }")
```


### 4. shard key 확인

```
sh.status()
```

### 5. shard key 삭제

### 6. shard key 재설정
- 한번 sharding한 collection에 shard key는 변경할 수 없다.
- 만약 변경하고 싶다면 새 collection을 만들어 shard key를 설정하고 collection 전체를 복사해서 새로운 collection을 만들어야 한다.
