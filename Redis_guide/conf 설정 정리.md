# redis conf 파일 설정 정리

```
요약

#기본설정

daemonize (daemon으로 실행 여부 설정)
pidfile (daemon 실행시 pid가 저장될 파일 경로)
port (접근을 허용할 port 설정)
bind (요청을 대기할 interface[랜카드] 설정)
unixsocket, unixsocketperm (요청을 대기할 unix 소켓 설정)
timeout (client와 connection을 끓을 idle 시간 설정)
loglevel (loglevel 설정)
logfile (log 파일 경로 설정)
syslog-enabled (system logger 사용 여부 설정)
syslog-ident (syslog에서의 identity 설정)
syslog-facility (syslog facility 설정)
databases (database 수 설정)

# REPLICATION

slaveof (master server 설정)
masterauth (master server 접근 비밀번호 설정)
slave-server-stale-data (master와 connection이 끊긴 경우 행동 설정)
repl-ping-slave-perid (미리 정의된 서버로 PING을 날릴 주기 설정)
repl-timeout (reply timeout 설정)

#SECURITY

requirepass (server 접근 비밀번호 설정)
rename-command (command 이름 변경)

#LIMITS

maxclients (최대 client 허용 수 설정)
maxmemory (최대 사용가능 메모리 크기 설정)
maxmemory-policy (maxmemory 도달 시 행동 설정)
maxmemory-samples (LRU 또는 mnimal TTL 알고리즘 샘플 수 설정)

#APPEND ONLY MODE

appendonly (AOF 사용여부 설정)
appendfilename (AOF 파일명 설정)
appendsync (fsync() 호출 모드 설정)
no-appendfsync-on-rewrite (background saving 작업시 fsync() 호출 여부 설정)
auto-aof-rewrite-percentage, auto-aof-rewrite-min-size (AOF file rewrite 기준 설정)

#SLOW LOG

slowlog-log-slower-than (slow execution 기준 설정)
slowlog-max-len (최대 저장 slow log 수 설정)

#VIRTUAL MEMORY

vm-enabled (vm 모드 사용여부 설정)

#ADVANCED CONFIG

hash-max-zipmap-entries, hash-max-zipmap-value (hash encode 사용 기준 설정)
list-max-ziplist-entries, list-max-ziplist-value (list encode 사용 기준 설정)
set-max-intset-entries (set encode 사용 기준 설정)
zset-max-ziplist-entries, zset-max-ziplist-value (sorted set encode 사용 기준 설정)
activerehashing (자동 rehashing 사용 여부 설정)
```
### 기본설정

##### daemonize [boolean] (기본값: no)
- Redis는 기본적으로 daemon으로 실행하지 않는다.
- daemon으로 실행하고 싶다면, 'yes'


##### pidfile [file path] (기본값: /var/run/redis.pid)
- daemon으로 실행될 때, pid가 기록될 파일 위치를 설정

##### port [number] (기본값: 6379)
- Connection을 허용할 Port를 지정
- 만약 port 값을 0으로 지정하면, Redis는 어떤 TCP socket에 대해서도 listen하지 않을 것이다.

##### bind [ip] (기본값: 모든 인터페이스)
- Redis를 bind 할 특정 interface(랜카드)를 지정할 수 있다.
- 명시하지 않으면 모든 interface로부터 들어오는 모든 요청을 listen한다.

##### unixsocket [path], unixsocketperm [number] (기본값: 없음)
- 들어오는 요청을 listen할 unix socket의 결로를 지정
- 기본값이 없기 때문에, 값이 지정되지 않으면 unix socket에 대해서는 listen하지 않을 것이다.

##### timeout [second]
- client의 idle이 N 초 동안 지속되면 connection이 닫힌다.
- 0으로 지정하면 connection이 계속 유지된다.

##### loglevel [level]
- log level을 지정한다. Log level 에는 아래 4가지 중 하나를 지정할 수 있다.

```
debug	엄청나게 많은 정보를 기록한다. 개발과 테스테 시 유용하다.
verbose	유용하지 않은 많은 양의 정보를 기록한다. 하지만 'debug level'만큼 많지는 않다.
notice	제품을 운영하기에 적당한 양의 로그가 남는다.
warning	매우 중요하거나 심각한 내용만 남는다.
```

##### logfile [file path]
- 'stdout'로 Redis가 the standard output에 로그를 기록하도록 할 수 있다.
- 만약 'stdout'를 명시했으나 Redis가 daemon으로 동작한다면 로그는 /dev/null logfile stdout 로 보내질 것이다.

##### syslog-enabled [boolean]
- system logger를 사용해서 logging 할 수 있게 한다.
- 단지 'yes'로 설정하고 추가적 설정을 위해서 다른 syslog parameter들을 설정할 수 있다.

##### syslog-ident [identity]
- syslog identity를 지정한다.

##### syslog-facility [facility]
- syslog facility을 지정한다.
- 반드시 USER 또는 LOCAL0 - LOCAL7 사이 값이 사용되어야 한다.

##### databases [size]
- dababase 갯수를 설정한다. 기본 dababase는 DB 0이다.
- connecton당 'SELECT <dbid>' 사용해서 다른 database를 선택할 수 있다.
- dbid는 0 과 'database 수 - 1'사이의 수이다.


### SNAPSHOTTING (RDB 지속성 설정)

##### save [seconds] [changes]
- disk에 DB를 저장한다.
- DB에서 주어진 값인 seconds와 changes를 모두 만족시키면 DB를 저장 할 것이다.
- 이 설정은 여러번 설정할 수 있다.

- 예시
```
900초(15)분 동안에 1개 이상의 key 변경이 발생했다면 DB를 저장한다.
300초(5)분 동안에 10개 이상의 key 변경이 발생했다면 DB를 저장한다.
60초(1)분 동안에 10000개 이상의 key 변경이 발생했다면 DB를 저장한다.

save 900 1
save 300 10
save 60 10000
```

##### rdbcompression [boolean] (기본값: yes)
- rbd database를 덤플 할 때 LZF를 사용해서 문자열 부분을 압축할지 설정한다.
- 만약 child set을 저장할 때 CPU 사용을 절약하고 싶다면 'no'로 설정한다.

##### dbfilename [file path]
- DB가 dump될 파일 이름을 설정한다.

##### dir [directory path]
- DB가 기록될 디렉토리를 설정한다.
- DB dump파일은 위의 dbfilename과 함께 최종적으로 파일이 기록될 곳이 지정된다.
- Append Only File 또한 이 디렉토리에 파일을 생성할 것이다.
- 반드시 여기에 디렉토리를 설정해야 한다. file name에 설정하면 안 된다.


### REPLICATION (복제 셋 구성 설정)

##### slaveof [masterip] [masterport]
- Master-Slave replication을 구성하기 위해서 slaveof를 사용한다.
- 현재 Redis instance가 다른 Redis server의 복사본이 되게 한다.
- slave에 대한 설정은 slave 인스턴스의 local에 위치한다. 따라서 slave에서는 내부적으로 따로 DB를 저장 하거나, 다른 port를 listen하는 등 slave만의 설정이 가능하다.


##### masterauth [master-password]
- 만약 master에 password가 설정되어 있다면 replication synchronization(복제 동기화) 과정이 시작되기 전에 slave의 인증이 가능하다. (이것은 "requirepass" 설정으로 가능하다).

##### slave-server-stale-data [boolean] (기본값: yes)
- 만약 slave가 master와의 connection이 끊어 졌거나, replication이 진행 중일 때는 아래의 2가지 행동을 취할 수 있다.
```
- 'yes(기본값)'로 설정한 경우, 유효하지 않은 data로 client의 요청에 계속 응답할 것이다. 만약 첫번째 동기화 중이였다면 data는 단순히 empty로 설정될 것이다.
- 'no'로 설정한 경우, INFO와 SLAVEOF commad(명령)을 제외한 모든 command들에 대해서 "SYNC with master in progress" error로 응답할 것이다.
```

##### repl-ping-slave-perid [seconds] (기본값: 10)
- Salve가 내부적으로 미리 정의된 server로 지정된 시간마다 PING을 보내도록 설정한다.


##### repl-timeout [seconds] (기본값: 60)
- 'bulk transfer I/O(대량 전송 I/O) timeout'과 'master에 대한 data또는 ping response timeout'을 설정한다.
- 이 값은 'repl-ping-slave-period' 값 보다 항상 크도록 설정되어야 한다. 그렇지 않으면 master와 slave간 작은 traffic이 발생할 때 마다 timeout이 인지될 것이다.


### SECURITY (보안 설정)

##### requirepass [password]
- client에게 다른 command들을 수행하기 전에 password를 요구하도록 설정한다. 이것은 redis-server에 접근하는 client들을 믿을 수 없는 환경일 때 유용하다.


##### rename-command [target-command] [new-command]
- command를 rename 할 수 있다.
- 공유되는 환경에서는 위험한 command들의 이름을 변경할 수 있다.
- 예를 들어서 CONFIG command를 추측하기 어려운 다른 값으로 변경할 수 있다.
- command를 공백으로 rename해서 완전히 사용 불가능하게 할 수도 있다.

### LIMITS (접속 및 메모리 설정)

##### maxclients [size] (기본값: 제한 없음)
- 한번에 연결될 수 있는 최대 client 수를 설정한다. 기본값은 제한이 없으나, Redis process의 file descriptor의 숫자만큼 연결가능하다.
- 특별히 '0' 값은 제한 없음을 의미한다.
- limit에 도달했을 때 새로운 connection들에 대해서는 'max number of clients reached' error를 전송하고, connection을 close 한다.

##### maxmemory [bytes]
- 최대 메모리 사용량을 지정한다.
- memory가 limit에 도달했을 때 Redis는 선택된 eviction policy(제거 정책)(maxmemory-policy)에 따라서 key들을 제거된다.
- 만약 Redis가 eviction policy에 의해서 key를 제거하지 못하거나 polict가 'noeviction'으로 설정되어 있다면, SET, LPUSH와 같이 메모리를 사용하는 command들에 대해서는 error를 반환하고, 오직 GET 같은 read-only command들에 대해서만 응답할 것이다.

- 주의: maxmoery 설정 된 instance에 slave가 존재 할 때, slave에게 data를 제공하기위해서 사용되는 output buffer의 size는  used memory count에서 제외된다. 따라서 system의 메모리가 남을 수 있게 조금 여유 있게 max memory를 설정해야 한다.

- 큰 메모리를 표시하기 위해서 아래와 같이 표기가 가능하다.

```
1k	1,000 bytes
1kb	1024 bytes
1m	1,000,000 bytes
1mb	1024*1024 bytes
1g	1,000,000,000 bytes
1gb	1012*1024*1024 bytes
```

##### maxmemory-policy [policy] (기본값: volatile-lru)
- MAXMEMORY POLICY: maxmemory에 도달했을 때 무엇을 삭제 할 것인지 설정한다. 아래 5개 옵션 중 하나를 선택할 수 있다.

```
volatile-lru	expire가 설정된 key 들 중 LRU algorithm에 의해서 선택된 key를 제거한다.
allkeys-lru	모든 key 들 중 LRU algorithm에 의해서 선택된 key를 제거한다.
volatile-random	expire가 설정된 key 들 중 임의의 key를 제거한다.
allkeys-random	모든 key 들 중 인의의 key를 제거한다.
volatile-ttl	expire time이 가장 적게 남은 key를 제거한다. (minor TTL)
noeviction	어떤 key도 제거하지 않는다. 단지 쓰기 동작에 대해서 error를 반환한다.
```

##### maxmemory-samples [size] (기본값: 3)

- LRU와 minimal TTL algorithms(알고리즘)은 정확한(최적) 알고리즘들은 아니다. 하지만 거의 최적에 가깝다. 따라서 (메모리를 절약하기 위해서) 검사를 위한 샘플의 크기를 선택할 수 있다. 예를 들어, Redis는 기본적으로 3개의 key들은 검사하고 최근에 가장 적게 사용된 key를 선택할 것이다. 해당 설정으로 샘플의 크기를 변경할 수 있다.

### APPEND ONLY MODE (AOF 지속성 설정)

##### appendonly [boolean] (기본값: no)        ?????
- rdb를 이용한 백업은 rdb 수행 후 장애가 발생했을 때, 그 사이에 변경된 데이터를 잃게 된다.
- append only mode를 활성화 시키면 이러한 데이터 유실을 방지할 수 있다.
- 이 mode가 활성화 되면, Redis는 요청받는 모든 write operation들을 appendonly.aof 파일에 기록할 것이다. Redis가 재 시작될 때 memory에 dataset를 rebuild하기 위해서 이 파일을 읽을 것이다.

주목: 원한다면 async dumps와 asppend only file을 동시에 사용할 수 있다. 만약 append only mode가 활성화 되어 있다면, startup 때 dataset의 rebuild를 위해서 append only mode의 log file을 사용하고, dump.rdb 파일은 무시할 것이다.

중요: 순간적으로 write operation이 많을 때 background에서 어떻게 append log file을 rewirte 하는 방법을 확인하기 위해서 BGREWRITEAOF를 확인해라.


##### appendfilename [file name] (기본값: appenonly.aof)
- append only file의 이름을 설정한다.
- 파일이 저장되는 디렉토리는 SNAPSHOTTING의 dir 속성을 사용한다.

##### appendsync [option]

- fsync() 는 강제로 OS가 disk에 data를 기록하게 한다.
- fsync를 얼마나 자주 호출 할 것인지 설정한다.

```
no              fsync()를 호출하지 않는다. data의 flush를 OS에 맡긴다. 빠르다.
always	        append only log에 wrtie 할 때 마다 fsync()를 호출한다. 느리다, 안전하다.
everysec	매 초 마다 fsync()를 호출한다. 절충안
```

##### no-appendfsync-on-rewrite [boolean]

##### auto-aof-rewrite-percentage [percente], auto-aof-rewrite-min-size [bytes]

### SLOW LOG
- 첫번째 parameter는 Redis가 slow log를 기록하기 위해서 어떤 execution time이 느린 것인지 알려주기 위해서 microsencond로 설정한다.
- 두번째 parameter는 기록될 수 있는 slow log의 길이이다. 새로운 command가 log 되었을 때, 가장 오래전에 기록된 log가 제거된다.

##### slowlog-log-slower-than [microseconds]
- microsencod값으로 slow execution time를 설정한다. 1000000은 1초와 같다.
- 주의: 음수를 설정한 경우 slow log를 비활성화 시킨다. 0으로 설정한 경우 모든 command에 대해서 logging 수행된다.

##### slowlog-max-len
- 길이에는 제한이 없다. 단지 이것은 memory를 소모하는 것은 인지하고 있어야 한다.
- SLOWLOG RESET 명령으로 slow log에 의해서 사용된 memory를 반환 시킬 수 있다.

### VIRTUAL MEMORY

##### vm-enabled
- Virtual Memory는 Redis 2.4에서 제거되었다. vm-enabled no로 설정해서 사용하지 않는다.

### ADVANCED CONFIG
