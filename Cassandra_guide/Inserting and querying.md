# Inserting and querying

- Cassandra의 쿼리 API는 CQL(Cassandra Query Language)이다
- CQL을 사용하기 위해서는 cqlsh를 사용하거나, client driver를 사용하여 cluster에 연결되어야 한다.

#### CQLSH

- cqlsh는 CQL을 통해 Cassandra와 상호 작용하기 위한 명령 행 쉘이다.
- 모든 Cassandra 패키지와 함께 제공되며, cassandra 실행 파일과 함께 bin/ 디렉토리에서 찾을 수 있다.
- command line에 지정된 단일 노드에 연결한다.

```
$ bin/cqlsh localhost
Connected to Test Cluster at localhost:9042.
[cqlsh 5.0.1 | Cassandra 3.8 | CQL spec 3.4.2 | Native protocol v4]
Use HELP for help.
cqlsh> SELECT cluster_name, listen_address FROM system.local;

 cluster_name | listen_address
--------------+----------------
 Test Cluster |      127.0.0.1

(1 rows)
cqlsh>
```

#### Client drivers

- 
