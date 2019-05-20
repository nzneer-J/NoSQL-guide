# Overview

## CouchBase Core rumtime system

- Connectivity architecture
- Replication architecture
- Storage architecture
- Caching layer architecture
- Security architecture

## Couchbase Server also consists of the following services

- Cluster manager
- Data service
- Index service
- Query service
- Search service

## Service

- CouchBase service는 클러스터 내에서 특정, 독립적인 작업 부하를 실행하는 구성 요소이다.
- Database는 3개의 분리된 작업 부하는 다룬다.
    - core data operation
    - indexing
    - query processing
<br>
- CouchBase Server에는 Data, Index, Search, Query Service가 포함되어 클러스터 내에서 이러한 작업 부하를 독립적으로 배포할 수 있다.
    - 각 노드는 모든 서비스 또는 몇 개의 서비스만을 수행할 수 있다.
    - 따라서 관리자는 고유한 topologies를 만들어 세 가지 작업 부하를 독립적으로 확장 시킬 수 있다.

- 참고 : https://developer.couchbase.com/documentation/server/5.1/architecture/services-archi-multi-dimensional-scaling.html

#### Core data access and data service

- CouchBase는 key가 있는 항목에 대해서 CRUD 작업을 할 수 있는 key-value API를 제공한다.
- 참고 : https://developer.couchbase.com/documentation/server/5.1/architecture/data-service-core-data-access.html

#### Indexing and index service

- index는 더 빠른 데이터 접근을 제공한다.

- CouchBase 서버는 다음과 같은 indexer를 지원한다.
    - Incremental Map-Reduce View indexer
    - Global Secondary Index (GSI) indexer
    - Spatial Views indexer
    - Full Text Search indexer
<br>
- indexer를 이용하여 2가지 타입의 index를 만들 수 있다.
    - Primary indexes
        - 모든 key를 index하고, Secondary index를 사용할 수 없거나 full scan이 필요한 경우 사용
    - Secondary indexes
        - 버킷 내 항목의 subset을 index할 수 있고, 특정 subset에 대해 더 효율적인 조회가 가능
<br>    
- MapReduce view와 Spatial view는 View API를 통해 index에 직접 접근이 가능하다.
- 두 indexer는 Core Data distribution(배포)의 파티션 정렬 때, 데이터 서비스 내에 배치된다.
<br>
- full text search indexer (Developer Preview)는 FTS API를 통해 indexer에 직접 접근한다.
- FTS index는 독립적인 확장성을 위해 자체 서비스 내에 배치된다.
<br>
- GSI (Global Secondary Indexes)는 index service를 호스팅하는 node에 배포되며, N1QL query를 통해 성능과 처리량 향상을 위해 독립적으로 분할할 수 있다.
<br>
- 참고 : https://developer.couchbase.com/documentation/server/5.1/architecture/views-indexing-index-service.html

#### Querying data and query service

- N1QL를 사용하여, SQL과 유사한 구문으로 json문서를 query할 수 있다.
- ad-hoc query (with filters)를 실행할 수 있고, json 데이터를 aggregate하거나 json output을 reshape할 수 있다.
- N1SQL은 Query Service를 통해 이용할 수 있다.
<br>
- Incremental Map-Reduce View는 View에 정의된 key를 기반으로 데이터를 query할 수 있는 View API를 제공한다.
-  View는 javascript에서 MapReduce 함수를 사용하여 정의할 수 있다.
- Incremental Map-Reduce View API는 Data Service를 통해 이용할 수 있다.
<br>
- Spatial views는 bounding box(좌표가 있는 직사각형)를 기반으로 데이터를 query할 수 있는  Spatial View API를 제공한다.
- Spatial views는 javascript에서 MapReduce 함수를 사용하여 주어진 항목이 나타내는 좌표를 의미하는 attribute를 정의한다.
- Spatial view API는 Data Service에서 이용할 수 있다.
<br>
- Full text search indexer는 키워드 검색으로 CouchBase 서버 안의 데이터를 직접 검색하는 Search API를 제공한다.
- Search API는  Search Service에서 이용할 수 있다.
<br>
- 참고 : https://developer.couchbase.com/documentation/server/5.1/architecture/querying-data-and-query-data-service.html


원문 : https://developer.couchbase.com/documentation/server/5.1/architecture/architecture-intro.html
