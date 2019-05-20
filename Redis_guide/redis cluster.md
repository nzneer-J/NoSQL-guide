# redis cluster

### 클러스터 설명

#### Redis Cluster 101

```
The ability to automatically split your dataset among multiple nodes.
The ability to continue operations when a subset of the nodes are experiencing failures or are unable to communicate with the rest of the cluster.
```

#### Redis Cluster TCP port

- redis 클러스터는 두 TCP connection open을 필요로 한다.
    - client에 제공되는 client port (6379)
    - Cluster bus (node-to-node communication channel) (client port + 10000 = 16379)

```
- 클러스터와 통신하는 모든 client에 대해 6379 포트(client port)는 열어둬야 한다.
- 클러스터 노드 간에는 6379 포트(client port)와 cluster bus port(client port + 10000)가 열려있어야 한다.
```

#### Redis Cluster data sharding

- redis cluster는 모든 키가 개념적으로 해시 슬롯이라는 형태의 샤딩을 사용합니다.
- redis cluster는 16384개의 hash slot을 가지며, 키의 hash slot을 계산하기 위해 키의 16384 modulo에서 CRC16을 가져옵니다.
- 각 hash slot을 cluster의 각 노드가 나눠서 가질 수 있습니다. 예를 들어, 3개의 노드를 가진 cluster의 경우, 0 ~ 5500 , 5501 ~ 11000 , 11001 ~ 16383 과 같이 hash slot을 나눠가질 수 있습니다.

- Node A, B, C가 있을 때, 노드 D를 추가하기 위해서는 A,B,C 각 노드의 일부 hash slot을 D로 이동시키면 됩니다.
- A를 제거하고 싶다면, A의 hash slot을 나머지 노드로 이동시키고, 전부 이동 시킨 후에 노드 A를 제거할 수 있습니다.
- hash slot의 이동은 cluster의 작업 중지 없이 이루어질 수 있으며, 따라서 노드 추가/제거 또한 downtime 없이 진행할 수 있습니다.

- 한 작업과 관련된 모든 키가 동일한 hash slot에 포함되어 있다면, 여리 키 작업을 할 수 있습니다. (multiple key operations)
- hash tags를 사용하여 multiple key가 같은 hash slot의 일부가 되게 할 수 있습니다.
- Hash tags는 'Redis Cluster specification'에 설명되어 있습니다.


#### Redis Cluster master-slave model

- 클러스터는 일부 노드의 장애 발생에 대비해서 각 노드의 복제본을 둘 수 있다.
- 마스터 노드에 장애가 나면, slave를 새로운 master로 승격시켜서 cluster가 정상 동작하도록 합니다.


#### Redis Cluster consistency guarantees

- Redis Cluster는 consistency을 보장할 수 없습니다.
- 이는 클러스터가 특정 조건 하에 client가 변경한 데이터에 대한 정보를 잃을 수 있음을 의미한다.
- consistency을 보장할 수 없는 첫번째 이유는 redis cluster가 비동기 복제를 사용하기 때문이다. 아래는 비동기 복제 동작 순서이다.
    1. client가 master에 데이터를 쓴다.
    2. master가 client에 OK 응답을 보낸다.
    3. master가 slave들에게 쓰기를 전달한다.
- 만약, master에 데이터를 쓰고, client가 응답을 받은 뒤에 master가 slave로 쓰기를 전달하기 전에 master에 장애가 발생하면 client가 쓴 데이터를 잃게 된다.

- 필요한 경우, wait 명령을 통해 구현된 동기 복제를 지원하지만, 동기 복제를 사용하더라도 완전히 데이터 유실을 방지할 수는 없습니다.

- node timeout : 특정 마스터 노드가 다른 노드들과 통신이 안되는 상태로 일정 시간 이상 유지되면 slave 노드 하나를 마스터 노드로 전환한다.
    - http://redisgate.kr/redis/cluster/cluster-node-timeout.php


#### Redis Cluster configuration parameters

- cluster-enabled <yes/no> : cluster로 실행할건지 설정

- cluster-config-file <filename> : 유저가 수정하는 파일은 아니고, 클러스터 노드가 변경될 때마다 클러스터 구성을 자동으로 파일에 저장하여 유지
    - 일부 메시지 수신 결과로 디스크에 re-write 되거나 flush 된다.
    - 이 파일에는 클러스터의 다른 노드, 상태, 영구 변수(persistent variables) 등이 저장된다.

- cluster-node-timeout <milliseconds> : 클러스터 노드가 장애로 판단되지 않는 최대한의 사용 불가 시간
    - 해당 시간 이상 접근이 안된 경우, slave 노드가 master로 승격된다.(장애 조치 발생)
    - 다른 중요한 사항을 제어할 수 있는 옵션이다.
    - 특정 시간 동안 과반수의 마스터 노드에 접근할 수 없는 모든 노드는 쿼리를 받을 수 없다.

- cluster-slave-validity-factor <factor> : 0으로 설정하면, slave는 master과 끊어진 시간과 상관없이 무조건 장애 복구를 시도합니다.
    - 값이 양수 인 경우, cluster-node-timeout에 cluster-slave-validity-factor를 곱한 시간 이상 만큼 master랑 연결이 끊어져있던 slave는 master로 failover되지 않습니다.
        - ex : cluster-node-timeout = 5, cluster-slave-validity-factor = 10 일 때, 50초 이상 연결되지 않았던 slave는 master가 될 수 없습니다.
    - 이 값이 0이 아닐 경우, failover 할 수 있는 slave가 없을 수 있습니다. 이 경우, master가 다시 복구되기 전까지 failover할 수 없습니다.


- cluster-migration-barrier <count> : .... replica migration 부분 참고

- cluster-require-full-coverage <yes/no> : yes일 경우, key space의 일부 비율이 어떤 노드에서도 처리되지 않으면 클러스터는 쓰기를 허용하지 않습니다.
    - no인 경우, key의 subset(하위집합)에 대한 요청만 처리할 수 있다면 쿼리를 허용 합니다.  

#### Creating and using a Redis Cluster (run node instance)

- 빈 redis 인스턴스를 cluster mode로 실행합니다.
    - 이는 cluster 구성을 위해서 기존에 사용하던 redis 인스턴스는 사용할 수 없다는 의미 입니다.

- 아래는 가장 기본적인 redis cluster configuration file 설정입니다.

```
port 7000
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
appendonly yes
```

- 클러스터 구성을 위해서는 최소한 3개의 마스터 노드가 필요합니다.

- 처음 클러스터 노드를 실행하면, node.conf 파일에 ID(node ID)가 생성되는데, 각 노드는 이것이 노드의 고유한 식별자가 된다. (ip와 port로 판단하는 것이 아니다.)


#### Creating the cluster

- redis 5버전을 사용하고 있다면, redis-cli에 포함된 cluster 관련 명령어로 새로 클러스터를 만들거나 기존 클러스터를 check 또는 reshard 할 수 있다.
- redis 3 또는 4 버전을 사용 중이라면, redis-trib.rb 라는 도구를 사용하면 된다.
    - redis-trib.rb는 redis 소스 코드 배포판의 src 디렉토리에서 찾을 수 있고, redis-trib를 실행하기 위해서는 redis gem을 설치해야 한다.
    - 이 후 예제는 redis-cli로만 진행하지만, redis-trib.rb도 구문은 비슷하기 때문에, redis-trib.rb help를 참조하면 된다.

    ```
    gem install redis
    ```

- 클러스터를 생성하기 위해서는 다음을 입력하면 된다. (\\는 개행의 의미이다.)

```
redis-cli --cluster create 127.0.0.1:7000 127.0.0.1:7001 \
127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005 \
--cluster-replicas 1
```

- Redis 4 or 3의 경우

```
./redis-trib.rb create --replicas 1 127.0.0.1:7000 127.0.0.1:7001 \
127.0.0.1:7002 127.0.0.1:7003 127.0.0.1:7004 127.0.0.1:7005
```

- create 명령을 사용하여 redis cluster를 만들 수 있다.
- --cluster-replicas 1 옵션은 모든 master에 대해 각각 하나의 slave를 만든다는 의미이다.
- 이 후 나머지 인수는 새 클러스터를 구성하는 인스턴스(노드)들의 address 이다.
- 위와 같이 6개의 address를 입력하면, 3개의 master와 3개의 slave가 만들어 진다.
    - 명령어 실행 후, redis-cli에서 클러스터 구성은 제안하는데, 이 때 yes를 입력하면 된다.
    - 모든 과정이 완료되면 다음 결과가 나타난다.
    ```
    [OK] All 16384 slots covered
    ```

#### Creating a Redis Cluster using the create-cluster script

해당 내용은 생략 하겠다.

#### Playing with the cluster

- Redis Cluster의 문제는 client 라이브러리가 구현이 부족하다는 점이다.
- client 명단

```
redis-rb-cluster is a Ruby implementation written by me (@antirez) as a reference for other languages. It is a simple wrapper around the original redis-rb, implementing the minimal semantics to talk with the cluster efficiently.
redis-py-cluster A port of redis-rb-cluster to Python. Supports majority of redis-py functionality. Is in active development.
The popular Predis has support for Redis Cluster, the support was recently updated and is in active development.
The most used Java client, Jedis recently added support for Redis Cluster, see the Jedis Cluster section in the project README.
StackExchange.Redis offers support for C# (and should work fine with most .NET languages; VB, F#, etc)
thunk-redis offers support for Node.js and io.js, it is a thunk/promise-based redis client with pipelining and cluster.
redis-go-cluster is an implementation of Redis Cluster for the Go language using the Redigo library client as the base client. Implements MGET/MSET via result aggregation.
The redis-cli utility in the unstable branch of the Redis repository at GitHub implements a very basic cluster support when started with the -c switch.
```

- redis-cli 의 -c 옵션을 사용하면 cluster 작업을 할 수 있습니다.






### 클러스터 구성하기

- conf 파일 수정
    - replicaof 설정은 있으면 안 됨

```
cluster-enabled yes
cluster-node-timeout 5000
cluster-config-file nodes.conf
```



참조링크 :
https://y0c.github.io/2018/10/21/redis-cluster/
https://blog.leocat.kr/notes/2017/11/07/redis-simple-cluster

* 위 내용은 redis.io의 Redis cluster tutorial을 참고했으나, 몇몇 필요 없는 내용이나 이해가 안되는 내용은 정리하지 않았습니다.
