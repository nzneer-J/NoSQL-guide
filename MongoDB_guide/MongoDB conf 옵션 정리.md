# MongoDB conf 파일 옵션 정리

## 1. storage

스토리지 엔진 공통 영역의 설정
주로 dbPath 또는 journal 관련 설정만 자주 사용

- dbPath
> 데이터 파일을 저장할 경로

> RDBMS와는 달리 저널 로그나 oplog가 모두 이 디렉터리의 하위에 저장

- indexBuildRetry
> 인덱스 생성이 비정상적으로 중단된 상태로 MongoDB 서버가 재시작될 때, 인덱스 생성을 자동으로 시작할 것인지 설정

- repairPath
> MongoDB 서버를 --repair 옵션과 함께 시작할 때, 데이터베이스 복구 쓰레드가 사용하는 임시 디렉터리를 설정한다.

- directoryPerDB
> MongoDB 서버가 데이터베이스 단위로 디렉터리를 생성할지, 아니면 dbPath에 모든 데이터 파일을 저장할지 결정한다.

- syncPeriodSecs
> MongoDB의 대부분 스토리지 엔진은 DIRECT-IO를 사용하지 않기 때문에 MongoDB의 데이터 쓰기는 일반적으로 OS의 캐시 메모리에 남아있을 가능성이 크다. 그래서 주기적으로 캐시의 더티 페이지를 디스크로 플러시한다. 이 옵션은 동기화를 어느 주기로 실행할 지 결정한다.

> 일반적으로 저널 로그를 활성화한 경우에는 데이터 파일이 손실되더라도 자동 복구가 가능하므로 이 설정 자체는 중요한 역할을 하지 않는다.

- journal
    - enabled
    - commitIntervalMs
> 저널 로그를 활성화할 것인지 결정한다.

> commitIntervalMs 옵션은 저널 로그를 어느 주기로 디스크에 동기화할 지 결정.
MongoDB는 트랜젝션 단위로 저널 로그를 디스크에 동기화하지 않기 때문에, 트랜젝션과 상관없이 설정한 밀리초 단위로 저널 로그를 디스크에 동기화한다.

- engine
> 기본 스토리지 엔진으로 어느 엔진을 사용할 건지 결정.


##### mmapv1:

- preallocDataFiles:
> 빈 데이터 파일을 미리 생성해 데이터가 사용할 공간을 미리 예약해 둘 것인지 결정.

>디스크 공간이 항상 여유 있는 상태라면 굳이 미리 빈 데이터 파일을 생성해 둘 필요는 없다.

- nsSize
> 네임스페이스 파일 (.ns)의 크기를 설정

> 네임스페이스 파일의 크기가 작으면 하나의 데이터베이스에서 생성할 수 있는 컬렉션의 수가 적어지게 된다.

> 기본 값 : 16 MB    - 대략 24,000개의 컬렉션과 인덱스 생성 가능

- quota
    - enforced
    - maxFilesPerDB
> 데이터베이스 단위로 디스크의 사용 공간을 제약하는 옵션

- smallFiles
> 컬렉션 단위로 생성하는 데이터 파일의 초기 크기를 작게 만들고, 데이터 파일의 최대 크기도 512MB로 제한

> 작은 테이블이나 데이터베이스들이 많거나 config 서버 또는 arbiter에서 불필요하게 많은 디스크 공간을 사용하지 않도록 제한하는 용도로 사용


일반적인 서비스에서는 smallFiles 이외에는 설정할 만한 내용이 없다.

##### wiredTiger

성능과 연관된 설정은 2~3개 수준 밖에 되지 않는다.
일반적으로 표준 설정을 그대로 사용해도 충분한 경우가 더 많다.

- engineConfig, collectionConfig, indexConfig
> 오브젝트의 범위 별로 설정 가능

> engineConfig : 전역 설정
> collectionConfig : 컬렉션 설정
> indexConfig : 인덱스 설정

> 주로 변경하는 옵션
engineConfig.cacheSizeGB
collectionConfig.blockCompressor
indexConfig.prefixCompression

- engineConfig.cacheSizeGB
> 공유 캐시가 어느 정도의 메모리를 사용하게 할 것인지 설정.
기본적으로 서버 메모리의 50~60% 정도 수준으로 선택.

- collectionConfig.blockCompressor
> 데이터 파일을 압축할 것인지, 어떤 알고리즘을 사용할 것인지 결정.
zlib, snappy 압축 알고리즘 설정 가능.
사용하지 않는다면 none으로 설정.

- indexConfig.prefixCompression
> 인덱스는 기본적으로 데이터 블록 단위의 압축은 지원하지 않고, prefix 압축을 지원.
인덱스의 prefix압축을 사용할 것인지 결정.
