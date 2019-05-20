# Data Model

- CouchBase Server의 데이터는 json 문서도 될 수 있고, binary format도 될 수 있다.


### Document Data Model

- CouchBase Server에서 document는 json 형식으로 저장된다.
- json은 간단하고, 가벼운 표기법으로 사람이 읽을 수 있다.
- json은 숫자와 문자열 같은 기본 data type과 embedded dictionary와 array 같은 복합 data type을 모두 지원한다.

- CouchBase에서 json을 데이터 포맷으로 사용하면 몇 가지 장점이 있다.
- json은 mobile application과 web에서 데이터 교환의 공통 언어이다.
- 가장 흔한 REST API의 return type이다.
- 이러한 인기 때문에, json은 어떤 프로그래밍 언어로든지 만들고 사용하기 쉽고 효율적이다.
- Serialization과 Deserialization가 매우 빠르다
- json은 javascript에서 나왔기 때문에, web 프로그래밍에 사용하기 매우 편리하다.

-


원문 : https://developer.couchbase.com/documentation/server/5.1/data-modeling/concepts-data-modeling-intro.html
