WiredTiger Storage Engine
============

3.0버전부터, WiredTiger storage engine은 64비트 build에서 사용할 수 있다.

## Document Level Concurrency
- WiredTiger는 write operations을 위해 document-level concurrency control을 사용한다.
- 결과적으로 여러 client가 동시에 collection의 다른 document를 수정할 수 있다.
<br>
- 대부분의 read and write operations에서 WiredTiger는 낙관적 동시성 제어(optimistic concurrency control)를 사용한다.
- WiredTiger는 global, databases, collection 레벨에서 intent locks를 사용한다.
- storage engine이 두 operations 간의 충돌을 감지하면, write conflict을 발생시켜서 MongoDB는 해당 operation을 투명하게 다시 시작한다.
<br>
- 일부 global operations(일반적으로 여러 개의 데이터베이스와 관련된 짧은 lived operations)는 여전히 global "instance-wide" lock이 필요하다.
- collection 삭제와 같은 일부 operation은 여전히 배타적 데이터베이스 락(exclusive database lock) 이 필요하다.

## Snapshots and Checkpoints
- WiredTiger는 MultiVersion Concurrency Control (MVCC)을 사용한다.
- operation이 시작할 때, WiredTiger는 트랜잭션에 대해 특정 시점의 데이터 Snapshots을 제공한다.
- snapshot은 in-memory data의 일관적인 view를 제공한다.
<br>
- _disk에 쓰여질 때, WiredTiger는 모든 데이터 파일에 걸처 일관된 방식으로 snapshot에 있는 모든 데이터를 disk에 쓴다._
- 현재 적용되어 있는 데이터(now-durable data)는 data file 내에서 checkpoint 역할을 한다.
- checkpoint는 데이터 파일이 마지막 checkpoint까지 일관성 있게 유지되는지 확인한다.
- 즉, checkpoint는 recovery point(복구 시점) 역할을 한다.
<br>
- MongoDB는 WiredTiger가 60초 간격 또는 2기가 바이트의 journal data로 checkpoint(snapshot을 disk로 쓴다.)를 생성하게 구성한다.
_질문 : 그럼 60초 간격과 2기가 바이트 간격으로 snapshot을 disk로 저장한다고 보면 되나요?_
<br>
- 새 checkpoint가 쓰여질 동안, 이전 checkpoint는 여전히 유효하다.
- 즉, 만약 MongoDB가 새로운 checkpoint를 쓰는 동안 에러가 발생하거나 종료되더라도 다시 시작할 때, 마지막 유효 checkpoint로부터 복구할 수 있다.
<br>
- WiredTiger의 meta data가 새로운 checkpoint를 참조하도록 자동적으로 업데이트될 때, new checkpoint는 접근 가능해지고, 영구적(accessible and permanent)이게 된다.
- 새로운 checkpoint가 accessible하게 되면, old checkpoint의 페이지는 해제(free)된다.
<br>
- WiredTiger를 사용하면, journaling을 사용하지 않더라도, MongoDB는 last checkpoint로부터 복구할 수 있다.
- 하지만, last checkpoint 이후의 변경에 대해 복구하기 위해서는 journaling이 필요하다.

## Journal
- WiredTiger는 write-ahead transaction log를 checkpoint와 함께 사용하여 data durability를 제공한다.
<br>
- WiredTiger journal은 checkpoint 사이의 모든 data 수정을 유지한다
- MongoDB가 checkpoint 사이에 존재한다면, last checkpoint 이후의 모든 데이터 수정을 replay하기 위해 journal을 사용한다.
<br>
- WiredTiger journal은 snappy compression library를 이용하여 압축(Compression)된다.
- 다른 압축 알고리즘을 사용하거나 압축하고 싶지 않다면,  storage.wiredTiger.engineConfig.journalCompressor 세팅을 사용하면 된다.

> note : WiredTiger의 log record 최소 크기는 128 bytes이다. 만약 log record가 128 바이트이거나 그보다 작으면, record를 압축할 수 없다.

<br>
- storage.journal.enabled을 false로 세팅하면, journaling을 사용하지 않을 수 있다.
- 이는 journal을 유지하는 데에 발생하는 overhead를 줄여준다.

## Compression
- MongoDB에서 WiredTiger를 통해 모든 collection과 index의 압축을 지원한다.
- 압축은 추가적인 CPU를 사용해야 하지만, storage 사용을 최소화한다.

- 기본적으로 WiredTiger는
  + 모든 collection에 snappy compression library를 이용한 block compression을
  + 모든 index에 prefix compression을 사용한다.
_질문 : block compression, prefix compression, snappy compression library_
- collection에 사용하는 block compression에 zlib를 이용할 수도 있다.
- storage.wiredTiger.collectionConfig.blockCompressor 세팅을 사용하면, 다른 압축 알고리즘을 사용하거나 압축하지 않을 수 있다.

- storage.wiredTiger.indexConfig.prefixCompression 세팅을 사용하여 index에 대한 prefix compression을 하지 않을 수 있다.

- 각 collection과 index를 생성할 때, Compression setting을 각 collection이나 index에 구성할 수 있다.
- 다음 링크를 참조 :
 https://docs.mongodb.com/v3.0/reference/method/db.createCollection/#create-collection-storage-engine-options
 https://docs.mongodb.com/v3.0/reference/method/db.collection.createIndex/#createindex-options

 - 대부분의 작업부하(workload)에서 기본 압축 설정은 storage 효율성과 processing 요구사항 간의 균형을 유지한다.
 - wiredTiger의 journal 또한 기본 설정으로 압축하고 있으며, 관련 정보는 다음 링크를 참조하라 :
 https://docs.mongodb.com/v3.0/core/wiredtiger/#storage-wiredtiger-journal

 _workload 개념_
