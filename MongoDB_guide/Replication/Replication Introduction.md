Replication Introduction
========
Replication은 여러 서버의 데이터를 동기화하는 process이다

# Redundancy and Data Availability
- Replication은 Redundancy(중복)과 data availability(데이터 가용성)의 증가를 제공한다.
- 여러 데이터베이스 서버에 여러 개의 데이터 copy가 있다면, Replication은 단일 데이터베이스 서버의 손실에 대해 내결함성(fault tolerance against)을 가지게 됩니다.
<br>
- 어떤 경우에는 Replication은 client가 다른 서버로 read operation을 보낼 수 있게 함으로써 read capacity를 증가시킬 수 있다.
- 여러 데이터 센터에서 데이터의 copy를 유지하면, 응용 프로그램에 대해 data locality와 availability를 늘릴 수 있다.
- 또한,  disaster recovery, reporting, backup을 위한 목적의 추가적인 copy를 maintain할 수도 있다.

# Replication in MongoDB
- replica set은 같은 data set을 가지는 mongod instance 그룹이다.
- replica set은 여러 data bearing node와 선택적으로 하나의 arbiter node를 가진다.
- _data bearing node와 arbiter node_? 데이터 보유 노드와 중계 노드?
- data bearing node 중 하나만이 primary node로 간주되고, 나머지는 secondary node로 간주된다.
<br>
- primary node는 모든 write operation을 receive한다.
- replica set 중 단 하나의 node만이  { w: "majority" }로 쓰기 권한을 확인할 수 있다.
- 어떤 환경에서는 다른 mongod instance가 자신을 primary node로 착각할 수 있다.
- primary는 data set에 대한 모든 변경을 operation log로 기록한다. (oplog)
![Alt Text](https://docs.mongodb.com/v3.0/_images/replica-set-read-write-operations-primary.png)
<br>
- secondary는 primary의 oplog을 복제하고, 이를 그들의 data set에 적용시킨다.
- 그렇게 함으로써 secondary의 data set은 primary의 data set을 복제한다.
- 만약 primary가 unavailable하면, replica set은 secondary를 primary로 선출한다.
![Alt Text](https://docs.mongodb.com/v3.0/_images/replica-set-primary-with-two-secondaries.png)
<br>
- 추가적인 mongod instance를 arbiter로서 replica set에 추가시킬 수 있다.
- arbiter는 data set을 유지하지 않는다.
- arbiter의 목적은 다른 replica set member의 heartbeat나 election 요청에 응답하여 replica set의 quorum을 유지하는 것이다.
_quorum???_
- arbiter는 데이터를 저장하지 않기 때문에, data set을 가지는 다른 member보다 저렴한 리소스 비용으로 quorum 기능을 제공할 수 있다.
- replica set의 member 수가 짝수인 경우, arbiter를 추가하여 primary 선거에 대한 다수결을 맞춘다.
- arbiter는 전용 하드웨어가 필요 없다.
![Alt Text](https://docs.mongodb.com/v3.0/_images/replica-set-primary-with-secondary-and-arbiter.png)
<br>
- arbiter는 항상 arbiter인 반면에, 선거 기간 중 secondary는 primary가, primary는 secondary가 될 수도 있다.

## Asynchronous Replication
- secondary는 primary로부터의 operation을 비동기적으로 적용한다.
- primary보다 조금 늦게(after primary) 적용받음으로써, set은 한 개 또는 여러 개의 member들의 결함에도 불구하고, 계속적으로 기능할 수 있다.
//
## Automatic Failover
- primary가 10 초 이상 다른 member와 communicate 못하면, 자격 있는 secondary가 primary를 뽑기 위한 선거를 실시한다.
- 선거를 개최하고, 가장 많은 member의 표를 받은 secondary가 primary가 된다.
_The first secondary to hold an election and receive a majority of the members’ votes becomes primary??? 의미가 맞는건가? ._
![Alt text](https://docs.mongodb.com/v3.0/_images/replica-set-trigger-election.png)

## Read Operations
- 기본적으로 client는 primary에게서 데이터를 읽는다.
- 하지만, secondary에게서 데이터를 읽기 위해 read preference를 지정할 수 있다.
- Asynchronous Replication로 인해 client가 secondary에게서 데이터를 읽을 때, primary의 상태를 반영 받지 못한 데이터를 받을 수 있음을 의미한다.
<br>
- MongoDB에서 client는 쓰기의 결과를 데이터가 durable 되기 전에 볼 수 있다.
  + _Regardless of write concern, other clients can see the result of the write operations before the write operation is acknowledged to the issuing client._
  + client는 차후 rolled back될 데이터를 읽을 수 있다.

## Additional Features
- replica set은 애플리케이션의 요구사항을 지원하는 여러 옵션을 제공한다.
- 예를 들어, 여러 데이터 센터의 멤버로 구성된 replica set을 배포하거나
- 일부 member의 우선순위를 조정하여 선거의 결과를 제어할 수 있다.
- replica set은 또한, reporting, disaster recovery, backup function을 위한 전용 member를 지원한다.



# Additional Resources
Quick Reference Cards
 https://www.mongodb.com/lp/misc/quick-reference-cards?jmp=docs&_ga=2.230543832.539281986.1516581196-1028906384.1515395649&_gac=1.41559574.1516076120.EAIaIQobChMI3qWW0M_b2AIVQiUrCh0ebQRLEAAYASAAEgJEN_D_BwE
 Webinar: Managing Your Mission Critical App - Ensuring Zero Downtime
 http://www.mongodb.com/webinar/managing-mission-critical-app-downtime?jmp=docs&_ga=2.230543832.539281986.1516581196-1028906384.1515395649&_gac=1.41559574.1516076120.EAIaIQobChMI3qWW0M_b2AIVQiUrCh0ebQRLEAAYASAAEgJEN_D_BwE
