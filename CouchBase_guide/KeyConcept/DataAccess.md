# Data Access

- CouchBase는 data에 access하는 다양한 방법을 제공한다
    - using key-value access pattern
        - 데이터 직접 접근 가능
        - application에서 데이터로 가장 빠르게 접근
        - 모든 데이터가 key로 접근 가능한 것은 아님
    - querying data using MapReduce (views) or N1QL
        - N1QL은 SQL과 비슷하고, 유연하며 선언적인 쿼리 언어를 제공
        - json의 어떤 속성에 대해서도 빠른 접근 가능

        - View(MapReduce)는 사용자가 정의한 맵으로 데이터를 인덱싱하고, reduce function 이용이 가능
        - complex reshaping과 데이터의 pre-aggregation에 용이
    - also use Full Text Search (FTS) feature to query data


- Key-Value Operations

- MapReduce Views

- Querying with N1QL
