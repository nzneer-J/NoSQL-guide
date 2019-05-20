Sharding Introduction
======
- Sharding은 여러 개의 machines에 데이터를 저장하는 기능이다.
- MongoDB는  very large data set과 high throughput operations을 지원하기 위해 샤딩을 쓴다.

## Purpose of Sharding
- 큰 data set과 높은 처리량을 가진 애플리케이션이 있는 데이터베이스는 단일 서버의 capacity에 버겁다.
- high query rate는 서버의 CPU capacity를 고갈(탈진)하게 만든다.
- 더 큰 data set은 단일 machines의 storage 용량(capacity)을 초과할 수 있다.
- 마지막으로, 시스템의 RAM보다 큰 작업 셋은 디스크 드라이브의 I/O 용량을 압박한다.
<br>
- 이런 scale 문제를 해결하기 위해 데이터베이스는 두 가지 approache를 가진다 :
  + vertical scaling
  + sharding

#### Vertical scaling
- Vertical scaling은 CPU와 storage 리소스를 추가하여 capacity를 증가시킨다.
- capacity 추가를 통한 scaling의 한계 :
  + 많은 CPU와 많은 RAM을 가진 고성능 시스템은 더 작은 시스템에 비해 너무 비싸다.(비효율적)
  + 또한, cloud-based provider는 사용자에게 더 작은 instance만 제공할 수 있도록 허락할 수 있다.
- 결과적으로 Vertical scaling은 실질적으로 최대 capability가 있다.

#### Sharding (horizontal scaling)
- 반면에, Sharding은 data set을 나누고, 여러 개의 shard 또는 서버로 데이터를 문배한다.
- 각 shard는 독립적인 database이고, 각 샤드가 모여서 single logical database를 구성한다.
![Alt Text](https://docs.mongodb.com/v3.0/_images/sharded-collection.png)
<br>
- Sharding은 높은 처리량과 대규모 데이터 세트를 지원하기위한 스케일링 문제를 해결합니다.
  + 샤딩은 각 샤드가 처리하는 operation의 수를 줄인다.
    +  각 샤드는 클러스터가 커짐에 따라 더 적은 operation을 처리힌다.
    + 결과적으로 클러스터는 용량과 처리량을 수평적으로 증가시킨다.
    + 예를 들어, 데이터를 삽입하려면 애플리케이션은 해당 레코드를 담당하는 샤드에만 액세스하면 된다.
  + 샤딩은 각 서버가 저장해야하는 데이터의 양을 줄인다.
    + 각 샤드는 클러스터가 커짐에 따라 더 적은 데이터를 저장한다.
    + 예를 들어, 데이터베이스에 1TB의 데이터 세트가 있고 4 개의 샤드가있는 경우 각 샤드는 256GB의 데이터 만 저장하면 된다.
    + 40 개의 샤드가있는 경우 각 샤드는 25GB의 데이터 만 저장하면 된다.

## Sharding in MongoDB
- MongoDB는 공유되는 cluster를 구성함으로써 샤딩을 지원한다.
![Alt Text](https://docs.mongodb.com/v3.0/_images/sharded-cluster-production-architecture.png)
- Sharded cluster는 다음과 같은 구성요소로 이루어져 있다.
  + shards
  + query routers
  + config servers.

#### shards
- 샤드는 데이터를 저장한다.
- production sharded cluster 내에서 high availability와 data consistency를 제공하기 위해, 각 샤드는 replica set이다.

#### query routers (or *mongos* instance)
- Query Routers는 client 응용 프로그램이랑 상호 작용하고, 적절한 샤드에 operation을 지시한다.
- Query Routers는 샤드에 처리할 작업을 주고, 그 결과를 클라이언트에게 반환한다.
- 클러스터에는 클라이언트의 요구를 나눠어서 처리할 쿼리 라우터를 여러 개 가질 수 있다.
- 클라이언트는 하나의 Query Routers에 요청을 보내고
- 대부분의 클러스터는 여러 쿼리 라우터를 가진다.
#### config servers
- config server는 클러스터의 메타데이터를 저장한다.
- 메타데이터는 샤드에 저장된 클러스터의 데이터 셋을 mapping 한다.
- Query Routers는 이 메타데이터를 각 샤드에 operation을 보낼 때, 사용한다.
- Production sharded clusters는 정확히 3개의 config server를 가진다.

## Data Partitioning
- MongoDB는 collection 수준에서 데이터나 샤드를 분배한다.
- 샤딩은 collection의 데이터를 shard key로 분할(partition)한다.

#### Shard Key
- collection을 분할하기 위해서는 shard key를 선택해야 한다.
- 샤드 키는 콜렉션의 모든 다큐먼트에 존재하는 indexed field 또는 indexed compound field 이다.
- MongoDB는 샤드 키 값을 청크로 나누고 청크 전체에 균등하게 분배합니다.
- 샤드 키 값을 청크로 나누기 위해 MongoDB는 범위 기반의 파티셔닝 또는 해시 기반의 파티셔닝을 사용합니다.

#### Range Based Sharding
- range-based sharding의 경우,range based partitioning을 제공하기 위해 MongoDB는 샤드 키 값에 의해 결정되는 범위에 따라 data set을 나눈다.
- 숫자 샤드 키 고려 :
  + 음의 무한대와 양의 무한대 사이의 값
  + 모든 샤드 키를 중복되지 않게 chunk(청크)로 분할한다.
  + 청크는 최소 값과 최댓 값의 범위를 말한다.
<br>
-  range based partitioning system 안에서 "close"한 샤드 키 값을 가진 문서는 동일한 청크에 있을 가능성이 높고, 그러므로 동일한 샤드에있을 가능성이 크다.

![Alt Text](https://docs.mongodb.com/v3.0/_images/sharding-range-based.png)

#### Hash Based Sharding
- hash based partitioning의 경우, field 값에 대한 hash를 계산하고,
- 그 후 이 hash를 사용하여 chunk를 만든다.
<br>
- hash based partitioning에서는 가끼운 샤드 키 값을 가져도, 같은 chunk에 있다고 볼 수 없다.
- 클러스터에서 콜랙션의 배포를 더 무작위로 할 수 있다.

![Alt Text](https://docs.mongodb.com/v3.0/_images/sharding-hash-based.png)

#### Performance Distinctions between Range and Hash Based Partitioning
- Range based partitioning은 range 쿼리에서 더 좋은 효율성을 보인다.
- 샤드 키에 대한 range 쿼리가 주어지면 Query Routers는 어떤 청크가 해당 범위에 해당하는지 쉽게 알 수 있으며 이러한 청크를 포함하는 샤드에만 쿼리를 라우팅힌다.
<br>
- 그러나 범위 기반 분할을 사용하면 데이터가 고르지 않게 분산 될 수 있으며 이로 인해 샤딩의 이점 중 일부가 무효화 될 수 있습니다.
- 샤드 키가 시간과 같이 선형적으로 증가하는 field인 경우, 주어진 범위에 대한 모든 request는 동일한 청크에 모두 mapping된다.
- 이 경우, 샤드의 작은 set이 대부분의 요청을 받아들이고, 시스템이 잘 scale되지 않을 것이다.
<br>
- 반면에, Hash based partitioning은 범위 쿼리에 대한 효율성을 떨어지지만, 데이터를 고루 분배한다.
- 해쉬된 키 값은 청크와 샤드 전체의 데이터를 무작위로 분산시킨다.
- random distribution은 샤드 키에 대한 범위 쿼리를 처리할 때, 몇 개의 샤드만 target으로 하지 않고, 모든 샤드를 target으로 하여 결과를 반환할 것이다.

#### Customized Data Distribution with Tag Aware Sharding
- tag aware sharding을 통해 MongoDB 관리자는 balancing policy를 지시할 수 있다.
- 관리자는 tag를 생성하여 샤드 키의 범위와 연관시킨 다음 해당 태그를 샤드에 할당합니다.
- 그런 다음 balancer는 태그가 지정된 데이터를 적절한 샤드로 마이그레이션하고 클러스터가 태그에서 설명하는 데이터의 배포를 항상 시행하도록합니다.
<br>
- tag는 클러스터 내부의 청크 분포와 balancer의 동작을 제어하는 기본 매커니즘이다.
- 일반적으로 tag aware sharding은 여러 데이터 센터에 걸쳐있는 공유된 클러스터의 데이터 지역성을 개선하는 역할을 한다.



## Maintaining a Balanced Data Distribution
- 새로운 데이터를 추가하거나 새 서버를 추가하면 특정 샤드가 다른 샤드보다 훨씬 많은 청크를 포함하거나 또는 청크의 크기가 다른 청크 크기보다 훨씬 커지는 등 클러스터 내의 데이터 분산 불균형이 발생할 수 있다.
<br>
- MongoDB는 두 가지 백그라운드 프로세스를 사용하여 균형 잡힌 클러스터를 보장한다 :
  + splitting
  + balancer

#### Splitting
- Splitting은 청크가 너무 커지지 않도록하는 백그라운드 프로세스입니다.
- 청크가 지정된 크기 이상으로 커지면 MongoDB는 청크를 절반으로 나눕니다.
- insert 와 update가 split을 발생시킬 수 있다.
- split은 효율적인 메타데이터 변경이다.
- _split을 수행하는 동안, MongoDB는 데이터를 마이그레이션하거나 샤드에 영향을 미치지 않습니다._
![Alt Text](https://docs.mongodb.com/v3.0/_images/sharding-splitting.png)

#### Balancing
- balancer는 청크 마이그레이션을 관리하는 백그라운드 프로세스입니다.
- 밸런서는 클러스터 내의 어떤 query routers에서든 실행할 수 있다.
<br>
- 클러스터 내의 공유된 콜렉션의 분포가 고르지 않으면, balancer process가 콜렉션의 밸런스가 맞을 때까지 가장 많은 수의 청크를 가진 샤드에서 가장 적은 수의 청크를 가진 샤드로 청크를 마이그레이션 한다.
- 예를 들어, 콜렉션 user에서 shard 1은 100 청크를 가지고 있고, shard 2는 50 청크를 가지고 있다면, shard 1에서 shard 2로 청크가 마이그레이션 된다.
<br>
- 샤드는 원래 샤드와 대상 샤드 간의 백그라운드 작업으로 청크 마이그레이션을 관리합니다.
- 청크 마이그레이션 중, destination shard는 origin shard로부터 청크 내의 모든 document를 전송 받는다.
- 그 다음, destination shard는 마이그레이션 프로세스 도중 일어난 모든 변경을 캡처하고 적용한다.
- 마지막으로 config server에 있는 청크 위치 관련 메타데이터가 update된다.
<br>
- 마이그레이션 중에 오류가 발생하면 밸런서는 프로세스를 중단하고 청크를 원래 샤드에서 변경하지 않는다.
- MongoDB는 마이그레이션이 성공적으로 완료된 후 원본 샤드에서 청크의 데이터를 제거한다.
![Alt Text](https://docs.mongodb.com/v3.0/_images/sharding-migrating.png)

#### Adding and Removing Shards from the Cluster
- 클러스터에 샤드를 추가하면 새 샤드에는 청크가 없으므로 불균형이 발생합니다.
- MongoDB가 새로운 샤드로 즉시 데이터 마이그레이션을 시작하는 동안, 클러스터가 균형을 유지하기까지 약간의 시간이 걸릴 수 있습니다.

- 샤드가 제거되면, 밸런서가 샤드의 모든 청크를 다른 샤드로 마이그레이션 한다.
- 모든 데이터를 마이그레이션하고 메타 데이터를 업데이트 한 후 안전하게 샤드를 제거 할 수 있습니다.


원본 내용 : https://docs.mongodb.com/v3.0/core/sharding-introduction/
