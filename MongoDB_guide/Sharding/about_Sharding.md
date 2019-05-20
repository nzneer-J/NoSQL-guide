# About Sharding

### 기본적인 sharding 구조

- 클러스터 내의 여러 replica set을 각 shard로 추가할 수 있다. ( sh.addShard() )
- replica set의 각 데이터베이스 또는 새로운 데이터베이스를 sharding할 데이터베이스로 설정할 수 있다. ( sh.enableSharding() )
- shard되는 데이터베이스 내의 collection에 shard key를 지정하여, collection의 document들을 분할 저장할 수 있다. ( sh.shardCollection() )
- shard key는 chunk들이 클러스터 내에서 균등하게 분배되게 해준다. (또는 해야 한다.)


### shard key 제약사항

- shard된 collectio들은 shard key를 지원하는 index가 있어야 한다.
- index는 shard key의 index이거나 shard key가 prefix인 복합 index여야 한다.
    - collection이 비어 있는 경우, index가 없더라도 sh.shardCollection() 함수가 index를 생성한다.
    - 그렇지 않은 경우, sh.shardCollection() 전에 index를 만들어야 한다.
- \_id index나 shard key를 포함하는 index를 제외하고, unique한 인덱스를 만들 수 없다.
    - 다른 unique index를 가진 collection을 shard할 수 없다.
    - sharded collections에서 shard key가 포함되지 않는 index를 만들 수 없다.
    - shard key는 꼭 unique하지는 않지만, sh.shardCollection()의 unique 옵션에 true를 전달하면 unique한 shard key를 정의할 수 있다.

### shard key 선택하기
