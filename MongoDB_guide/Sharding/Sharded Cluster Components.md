Sharded Cluster Components
=======
Sharded clusters는 sharding을 구현한다.
Sharded clusters는 다음과 같은 Components를 가진다 :
- Shards
  + shard는 collection 데이터의 subset을 가지는 MongoDB Instance이다.
  + 각 shard는 단일 mongod instance이거나 replica set이다.
  + production에서 모든 shard는 replica set이다.
_질문 : replica와 shard와의 관계(큰 그림), production이란??_

- Config Servers
  + 각 Config Server는 클러스터에 대한 metadata를 가진 mongod instance이다.
  + metadate는 청크와 샤드를 map한다.

- Routing Instance
  + 각 router는 응용 프로그램의 읽기와 쓰기를 샤드로 라우팅하는 mongos instance이다.
  + 응용 프로그램은 샤드에 직접 접속할 수 없다.

![Alt Text](https://docs.mongodb.com/v3.0/_images/sharded-cluster.png)

- MongoDB에서 collection 단위로 샤딩을 가능하게 해라
- 샤드 (shard)하는 각 컬렉션에 대해 해당 컬렉션의 샤드 키를 지정해야 한다.
<br>

## Further Reading
- Shards
  + A shard is a single server or replica set that holds a part of the sharded collection.
- Config Servers
  + Config servers hold the metadata about the cluster, such as the shard location of the data.

원본 내용 : https://docs.mongodb.com/v3.0/core/sharded-cluster-components/
