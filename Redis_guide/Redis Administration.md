# Redis Administration


### Redis setup hints

- Linux OS를 권장
    - MacOS 등에서도 테스트했지만, 주로 Linux 환경에서 테스트된 코드이다.

- overcommit memory는 1 로 설정하길 권장

```
#/etc/sysctl.conf (재부팅 시마다 적용)
vm.overcommit_memory = 1
```

```
sysctl vm.overcommit_memory=1   (바로 적용)
```

- transparent huge pages 설정 disable

```
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```    

- swap을 일부 설정한다. (우리 팀에서는 swap을 사용하지 않는다.)
    - swap 설정으로 인해 redis 성능이 저하될 수 있지만,
    - 갑작스러운 memory 문제로 redis가 죽는 걸 막을 수 있다.

<br>

- 명시적으로 maxmemory 제한 옵션을 설정한다. (redis.conf 설정)
    - 시스템 메모리가 한계에 가까워졌을 때, 인스턴스가 fail하는 대신 오류를 repot 한다.
    - redis 이외의 overhead를 고려해서 설정 ( ex. 총 10GB 메모리를 가졌을 때, 8GB 정도 )

- 쓰기가 많은 application에서 사용하고 있을 때, 백업(RDB or AOF) 진행 시, 메모리의 2배를 사용할 수 있다.

- daemontools 에서 사용할 때는 "daemonize no"로 설정 (redis.conf 설정)

- backlog 설정 시, redis가 사용하는 메모리에 비례하게 설정해야 한다.
    - backlog는 복제본이 마스터 인스턴스와 쉽게 동기화할 수 있게 한다.

- replication을 사용하는 경우, diskless replication을 사용하는 것이 아니라면, RDB를 수행해야 한다.

- replication을 사용하는 경우, master가 죽었을 때 재시작하거나 persistence를 사용하는지 확인해야 한다.
    - persistence 없이 master가 재시작되면, 비어있는 master가 올라와서 replica의 모든 redis가 빈 데이터를 가지게 된다.

- redis는 기본적으로 인증을 요구하지 않고, 모든 네트워크 인터페이스를 수신한다.
    - 외부자가 redis의 네트워크에 접근하지 못하게 해야 한다.

- LATENCY DOCTOR 와 MEMORY DOCTOR 를 참고하세요


### Running Redis on EC2

- PV 기반 인스턴스가 아닌 HVM 기반 인스턴스를 사용하십시오.
- 이전 인스턴스 제품군을 사용하지 마십시오. 예를 들어 PV가있는 m1.medium 대신 m3.medium을 HVM과 함께 사용하십시오.
- persistence를 EC2 EBS에서 사용할 때, 가끔 있을 수 있는 EBS 볼륨의 high latency에 주의해야 한다.
- replica가 master와 동기화 할 때 문제가 발생하면 새로운 디스크없는 복제를 시도 할 수 있습니다.


### Upgrading or restarting a Redis instance without downtime



참조 링크 : https://redis.io/topics/admin
