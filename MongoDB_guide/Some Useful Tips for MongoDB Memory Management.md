# Some Useful Tips for MongoDB Memory Management

#### intro

- MySQL에서 MongoDB로 port하기로 결정
- 주요 원인은 느슨한 구조화되고, 비정규화된 객체를 json 문서 형식으로 표현할 수 있기 때문

#### How Key Expansion Cause Memory Bloat

- 다수의 중첩된 속성을 가질 수 있기 때문에, MongoDB의 "schemaless" 스타일은 RDB보다 더 선호된다.
- 단점은 이 구조가 극단적인 데이터 복제(duplication)를 만들어낸 다는 점이다.
- 주어진 테이블에 대해 MySQL컬럼은 한 번만 저장되는 데에 반해, MongoDB는 각 문서에 대해 동일한 json 속성이 반복된다.


#### Why Memory Management in Mongo is Crucial

- data set이 작으면, 이러한 중복은 acceptable 할 수 있다.
- 그러나 일단 scale up을 시작하면, 이것은 덜 매력적이게 된다.
- Yipit에서는 문서 당 평균 100MB의 key 크기가 약 6,500만 건의 문서에 분산되어 있으며, 가치를 제공하지 않는 7GB ~ 10GB의 데이터를 인덱스에 추가한다.
- MongoDB는 데이터 파일을 memory에 mapping 하기 때문에, 읽기/쓰기가 매우 빠르다.
- 하지만, working data set이 underlying box의 memory 용량을 초과할 경우, page fault와 locking 이슈가 발생할 수 있다.
- 특히, index가 너무 커져서 메모리에 남아 있을 수 없다면, 문제가 발생한다.


#### Quick Tips on Memory Management

- 메모리 문제를 해결할 여러 방법이 있다. 다음은 전체 옵션의 목록이다.

1. 더 큰 메모리를 추가하거나 shard를 늘린다. (비용이 상관 없다면)
    - shard를 추가하면, write locks 문제를 줄일 수 있다.
2. 기본 ObjectID를 저장하는 대신 "\_id" key를 적극 활용한다.
3. 컬렉션에 namespacing tricks을 사용한다. 즉, 각 컬렉션 document에 도시 key를 저장하는 대신 다른 도시의 recommendations을 위한 별도의 collections을 만든다.
4. 코드에서 document를 암시적으로 linking 하는 대신, embed 한다.
5. 값에 맞는 데이터 type을 저장한다. (i.e integar를 string보다 공간 효율적이다.)
6. 복합 키를 중복 없이 indexing 하는 방법을 고안한다.


#### The Key Compression Approach

-

원문 : https://dzone.com/articles/some-useful-tips-mongodb
