Introduction to MongoDB
=========

MongoDB는 high performance, high availability, automatic scaling을 제공하는 Document Database 오픈 소스이다.


Document Database
------
MongoDB에서 document는 데이터베이스의 record와 같다.
document는 field와 value 쌍으로 이루어져 있으며, JSON 객체와 형식이 비슷하다.

![Alt text](https://docs.mongodb.com/manual/_images/crud-annotated-document.bakedsvg.svg)

+ document의 장점
  + document는 여러 프로그래밍 언어의 native 데이터 타입에 대응한다.
  + Embedded document와 array는 expensive join을 줄여준다.
  + Dynamic schema는 fluent polymorphism을 지원한다.


key Features
-------
+ High Performance (높은 성능)
  + MongoDB는 데이터 지속성(data persistence)의 high performance를 제공한다.
    + 특히, 데이터베이스의 I/O를 줄이기 위한 embedded data model을 지원
    + 더 빠른 쿼리와 embedded document와 array의 키를 포함할 수 있는 index
<br>
+ Rich Query Language (풍부한 쿼리 언어)
  + read and write operations (CRUD)을 지원하는 풍부한 쿼리 언어 지원
    + Data Aggregation
    + Text Search와 Geospatial Queries.
<br>
+ High Availability (높은 가용성)
  + automatic failover와 data redundancy 기능을 제공하는 replica set
    * replica set = MongoDB’s replication facility
  + replica set은 같은 data set을 유지하는 MongoDB 서버의 집합이다. 이는 redundancy와 data availability의 증가를 지원한다.
<br>
+ Horizontal Scalability (수평 확장성)
  + MongoDB는 핵심 기능 중 하나로 수평 확장성을 제공한다.
    + Sharding은 machines의 cluster 전체에 데이터를 분산시킨다.
    + MongoDB 3.4는 shard key에 기반한 데이터 zones을 생성하는 것을 지원한다.
      + In a balanced cluster에서 MongoDB는 zone 내부의 shard에만 reads and write를 지시한다. (해석 유의)
<br>

+ Support for Multiple Storage Engines (다중 스토리지 엔진 지원)
  + MongoDB는 다음과 같은 Multiple Storage Engines을 지원한다.
    + WiredTiger Storage Engine
    + MMAPv1 Storage Engine.
  + 추가적으로 MongoDB는 타사가 MongoDB용 스토리지 엔진을 개발할 수 있도록 하는 pluggable storage engine API를 제공한다.


원본 내용 : https://docs.mongodb.com/v3.4/introduction/
