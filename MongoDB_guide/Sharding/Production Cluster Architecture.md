Production Cluster Architecture
==================
Production cluster에서는 데이터가 redundant(중복)되고, 시스템이 highly available해야 한다.
production cluster는 다음과 같은 구성요소를 가진다 :
  + Three Config Servers
    + 각 config server는 반드시 분리된 machine이어야 한다.
    + 단일 sharded cluster는 config server를 독점적으로 사용해야 한다.
    + 여러 개의 sharded cluster를 가진 경우, 각 cluster마다 config server 그룹이 있어야 한다.
  + Two or More Replica Sets As Shards
    + 이러한 replica set들은 shrad이다.
  + One or More Query Routers (mongos)
    + mongos instance들은 cluster의 router이다.
    + 일반적으로 배포(deployment)에는 각 응용 프로그램마다 하나의 mongos instance를 가진다.
    <br>
    + mongos instance 그룹을 배포하고, 응용 프로그램과 mongos 사이에 proxy/load balancer를 사용할 수 있다.
    + 이러한 배포에는 단일 클라이언트로부터의 모든 연결이 같은 mongos와 이루어지기 위해 client affinity(클라이언트 선호도)를 위한 load balancer를 설정해야 한다.
    <br>
    + cousor와 다른 리소스들이 단일 mongos instance에 특정되어 있기 때문에, 각 클라이언트는 단 하나의 mongos instance와 상호작용해야 한다.

![Alt Text](https://docs.mongodb.com/v3.0/_images/sharded-cluster-production-architecture.png)

원본 내용 : https://docs.mongodb.com/v3.0/core/sharded-cluster-architectures-production/
