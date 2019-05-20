# Terminology

- 이 섹션에서는 Couchbase Server 아키텍처 설명서에 사용 된 주요 용어와 개념을 정의합니다.

### Node

- physical server, virtual machine, 또는 container에서 실행되는 단일 Couchbase Server 인스턴스
- 모든 노드는 동일하다 : 동일한 구성 요소와 서비스로 구성되며 동일한 인터페이스를 제공한다.

### Cluster

- 단일 그룹으로 access, manage 되는 node들의 모임
- 각 node는 작동 정보(모니터링) 또는 클러스터 node의 membership과 health of nodes 등을 관리하는 기능을 제공하기 위해 Cluster를 조직하는 동등한 파트너이다.
- Cluster는 scalable 하기 때문에, 새 node를 추가해서 확장하거나 node를 제거하여 축소시킬 수 있다.
- Cluster Manager는 Cluster level의 작업을 조정하는 메인 구성요소 입니다.
- 참고 : https://developer.couchbase.com/documentation/server/5.1/architecture/cluster-manager.html

### Bucket

- Bucket은 key_value나 document 같은 관련 항목들의 set을 담는 논리적 컨테이너이다.
- Bucket은 RDB의 database와 유사하다.
- Bucket은 포함하는 데이터 그룹의 리소스 관리 기능을 제공한다.
- application은 하나 이상의 Bucket을 사용하여 데이터를 저장할 수 있다.
- 환경 설정에 띠리 Bucket은 다음과 같은 기능을 분리해서 제공할 수 있다.
    - Cache and IO management
    - Authentication
    - Replication and Cross Datacenter Replication (XDCR)
    - Indexing and Views

### Item

- Item은 CouchBase Server에서 데이터의 기본 단위이다.
- Item은 key-value 쌍으로 각 저장된 값은 버킷 내에서 unique key로 식별된다.
- 테이블별로 그룹화 된 데이터베이스에 데이터를 저장하는 RDB와는 다르다.
- 테이블(RDB)은 엄격한 스키마 (열 세트)를 가지며 데이터는 테이블의 행에 저장된다.
- Item의 값은 단일 비트, 십진수, json 문서 등 다양한 값이 될 수 있다.
- 데이터를 JSON 문서로 저장하면 Couchbase Server가 인덱싱 및 쿼리와 같은 확장 기능을 제공 할 수 있다.
- Item은 document, object 또는 key-value pair 라고도 한다.

### vBucket

- vBucket은 bucket data의 물리적 파티션이다.
- By default, CouchBase Server는 bucket data를 저장하기 위해 Bucket당 여러 개의 master vBucket(일반적으로 1024)을 생성한다.
- Bucket은 replicas 라는 데이터의 중본 복제를 저장할 수 있다.
- 각 replica는 active vBucket을 미러링하는 다른 vBucket의 set을 만든다.
- replica의 데이터를 유지하는 vBucket을 replica vBucket이라고 한다.
- 모든 Bucket은 active vBucket과 replica vBucket을 가지고 있으며, 이러한 vBucket은 data service 내의 모든 node로 고르게 분산된다.

### Cluster map

- Cluster map은 특정 시점에 어떤 service가 어떤 node에 속하는지의 mapping을 가지고 있다.
- 이 map은 모든 Couchbase node 뿐만 아니라 client SDK의 모든 인스턴스 내에 존재한다.
- 이 map을 통해 application은 투명하게 cluster topology를 식별하고 해당 topology가 변경 될 때 응답 할 수 있다.
- Cluster map에는 vBucket map이 포함되어 있다.

### vBucket map

- vBucket map은 특정 시점에서의 node와 vBucket의 mapping을 가진다.
- 이 map은 모든 Couchbase node 뿐만 아니라 client SDK의 모든 인스턴스 내에 존재한다.
- 이 map을 통해 application은 주어진 key에 대해 vBucket을 가지는 node를 투명하게 식별할 수 있고, 해당 topology가 변경 될 때 응답 할 수 있다.

### Replication

- Replication은 alternate node에 active data의 추가적인 복제를 만드는 process이다.
- Replication은 CouchBase Server Architecture의 핵심이며, high availability과 disaster recovery, 그리고 다른 데이터 제품과의 data exchange를 가능하게 한다.
- Replication은 다음과 같은 기능을 제공하게 하는 핵심 원동력이다.
    - Moving data between nodes to maintain replicas.
    - Geo-distribution of data with cross datacenter replication (XDCR)
    - Queries with incremental map-reduce and spatial views
    - Backups with full or incremental snapshots of data
    - Integration with Hadoop, Kafka and text search engines based on Lucene like Solr
- 참고 : https://developer.couchbase.com/documentation/server/5.1/architecture/high-availability-replication-architecture.html

### Rebalance

- capacity requirement나 node failure로 인해 node가 추가/제거되면 cluster의 topology가 변경될 수 있다
- node의 수가 변경되면, Rebalance operation이 load를 재분산하고, node의 새 topology를 적용하는 데에 사용된다.
- data service에 대한 Rebalance operation은 한 node에서 다른 node로의 vBuckets의 점진적 이동이다.
- vBucket이 node로 이동하거나 벗어남으로써 node들은 더 많거나 적은 data를 담당하고, application으로부터 더 많거나 적은 traffic을 처리하게 된다.
- Rebalance operation은 다양한 service에서 node를 가져오거나 제거한다.
- Rebalance operation동안 topology가 변경된 모든 client의 cluster map도 update된다.
- Cluster Manager는 Rebalance operation 동안 vBucket과 service의 이동 및 제거를 조정한다.
- Rebalance는 완전히 online으로 수행되며, 들어오는 workload에 최소한으로 영향을 준다.

### Failover

- Failover는 장애가 발생한 node에서 남은 healthy node로 traffic을 전환하는 process이다.
- Failover는 node의 health status를 기반으로 CouchBase cluster에 의해 자동으로 수행되거나 , 관리자나 외부 스크립트에 의해 수동으로 수행될 수 있다.
- failover된 node는 새로운 traffic을 받지 않는다.

##### Graceful failover

- Graceful failover는 순서있고 제어된 방식으로 cluster로부터 Data service node를 제거하는 사전행동적 기능이다.
- 중단 시간이 없는 온라인 operation으로 나머지 cluster node에 있는 replica vBucket을 active로 promoting하고, node의 active vBucket을 dead 상태로 failover시킴으로써 수행된다.
- 주로 cluster의 계획된 maintenance에 사용된다.

##### Hard failover

- Hard failover는 cluster를 사용할 수 없거나, 불안정해지면 cluster에서 node를 빠르게 삭제하는 기능이다.
- 나머지 cluster node의 replica vBucket을 active로 promoting함으로써 수행된다.
- 주로 cluster의 node가 예기치 않게 중단되었을 때, 사용된다.

##### Automatic failover

- Automatic failover Cluster Manager가 node를 사용할 수 없는 시기를 발견/결정하고, hard failover를 시작하는 built-in 기능이다.


### Node lifecycle

- cluster topology가 변경되면, cluster 내의 node들은 일련의 상태 전이를 겪는다.
- node 추가/제거, Rebalance, Failover 등과 같은 operation으로 상태 전이가 발생한다.
- 다음 다이어그램은 cluster 내의 node들의 상태 및 상태 전이를 나열한다.

![Node lifecycle](http://static.couchbaseinc.hosting.ca.onehippo.com/images/server/5.1/20180613-193211/cb-rebalance4.png "Node lifecycle")
