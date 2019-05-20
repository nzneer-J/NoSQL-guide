# Sharded Cluster Balancer

- MongoDB balancer는 각 샤드의 chunk 수를 모니터하는 background process 이다.
- 샤드의 chunk 수가 특정 migration thresholds에 도달하면 balancer는 샤드 간 chunk를 자동으로 마이그레이션하여 샤드 당 chunk 수가 동일할 수 있도록 한다.
- 밸런싱 절차는 사용자 및 어플리케이션에 완전히 투명하지만, 절차가 수행되는 동안 성능에 영향이 있을 수 있다.

- 3.4 버전부터 balancer는 config server replica set의 primary에서 실행된다.

- balancer process가 활성화되면, 해당 primary 노드는 Config 데이터베이스의 lock 컬렉션에 있는 document를 수정함으로써 "balancer lock"을 취득한다.
- 이 "balancer lock"은 never released 된다.

#### Cluster Balancer

- balancer process는 모든 sharded 된 컬렉션에 대해 chunk가 고르게 분산시키는 역할을 한다.
- 기본적으로 balancer process는 항상 enabled 되어 있다.

- balancer는 더 많은 chunk를 가진 샤드에서 더 적은 chunk를 가진 샤드로 chunk를 migrate한다.
- chunk가 각 샤드에 균등하게 분배될 때까지 작업한다.

- 2.6버전부터 Chunk migration은 디스크 공간에 영향을 줄 수도 있다.
- 기본적으로 source shard는 migrated 되는 document를 자동으로 아카이브 한다.

- chunk 마이그레이션은 대역폭과 작업량 측면에서 약간의 오버 헤드를 발생시킵니다. 둘 다 데이터베이스 성능에 영향을 미칠 수 있다
- balancer는 다음과 같은 영향을 최소화하려고 시도한다 :
    - 샤드에서 하나의 chunk를 마이그레이션 (샤드는 동시에 다수의 chunk 이동에 참여할 수 없다.) , 여러 chunk를 마이그레이션 하기 위해 balancer는 한 번에 하나씩 chunk를 이동시킨다.
        - 3.4 버전부터는 병렬 chunk migration이 가능하다. n개의 샤드가 있을 때, 최대 n/2 만큼 동시에 chunk migration이 가능
    - 최대 chunk를 가진 샤드와 최저 chunk를 가진 샤드 간의 차이가 migration threshold에 도달해야 balancing을 수행한다.

- production traffic에 영향이 없도록 balancer가 싱행되는 동안 window를 제한할 수 있다.


##### Adding and Removing Shards from the Cluster

- cluster에 샤드를 추가하면 새로운 샤드에 chunk가 없으므로 불균형이 발생한다.
- 새로운 샤드로 즉시 데이터 마이그레이션을 시작하는 동안, cluster가 균형을 유지하기까지 약간의 시간이 걸릴 수 있습니다.

- cluster에서 샤드를 제거하면 비슷한 불균형이 발생한다. 삭제되는 샤드에 있는 chunk가 cluster 전체에 재배포되어야하기 때문이다.
- MongoDB가 제거 된 샤드를 즉시 배수(draining)하기 시작하는 동안 cluster가 균형을 유지하기까지 약간의 시간이 걸릴 수 있습니다.
- 이 과정에서 제거 된 샤드와 관련된 서버를 종료하면 안된다.

- chunk 분포가 고르지 않은 cluster에서 샤드를 제거하면 균형자는 먼저 배수 샤드에서 chunk를 제거한 다음 나머지 고르지 않은 chunk 분포의 균형을 유지합니다.

#### Chunk Migration Procedure

- 모든 chunk 마이그레이션은 다음 절차를 사용한다:
    1. balancer process는 moveChunk 명령을 source 샤드에 보냅니다.
    2. source 샤드는 내부 moveChunk 명령으로 이동을 시작합니다.
        - migration process 중에 청크에 대한 operation이 source 샤드로 route 된다.
        - source 샤드는 청크에 대해 들어오는 쓰기 작업을 담당한다.
    3. destination shard는 destination shard에 없고, source shard에 필요한 index를 만든다.
    4. destination shard는 청크에 있는 document를 요청하고 데이터 copy을 받기 시작합니다.
    5. 청크에서 최종 문서를 수신 한 후 destination shard는 동기화 프로세스를 시작하여 마이그레이션 중에 발생한 마이그레이션 된 문서에 변경 사항이 있는지 확인합니다.
    6. 완전히 동기화되면 source shard가 config 데이터베이스에 연결되고 cluster metadata가 청크의 새 위치로 업데이트됩니다.
    7. source shard가 metadata 업데이트를 완료하고 청크에 열린 커서가 없으면 source shard는 해당 document copy를 삭제합니다.
