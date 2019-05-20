# configuring Cassandra

- config 파일은 yaml 파일 형식으로 되어 있다.
- 기본 yaml 파일은 /etc/cassandra/conf/ 디렉토리 안에 있다.
- single node로 실행하고자 하면, default yaml로 실행하면 된다.
- cluster로 실행하려면, 수정이 필요하다.

#### main runtime properties

- 대부분의 configuration은 cassandra.yaml을 통해서 설정한다.
- 최소한의 속성들은 아래와 같다
    - cluster_name : 클러스터 이름
    - seeds : 클러스터 seed들의 ip 주소 리스트 (, 로 구분)
    - storage_port : 포트 번호 (꼭 수정할 필요 없음, 방화벽 차단에 주의해야 한다)
    - listen_address : 이 노드의 ip 주소, 다른 노드와 통신에 사용된다.
        - 어떤 인터페이스를 사용할지 또는 연속적으로 사용할 주소를 나타내기 위해 listen_interface를 설정할 수 있다.
        - listen_address , listen_interface 둘 중 하나만 설정해야 한다.
    - native_transport_port : client가 cassandra와 통신할 때, 이 포트가 방화벽에 차단되지 않았는지 주의해야 한다.

#### Changing the location of directories

- 아래 yaml properties들이 디렉토리의 위치를 control 한다.
    - data_file_directories: 데이터 파일이 있는 하나 이상의 디렉토리
    - commitlog_directory: commitlog 파일이 있는 디렉토리
    - saved_caches_directory: 저장된 cache가 있는 디렉토리
    - hints_directory: hints가 있는 디렉토리
- 성능 상의 이유로 디스크가 여러 개인 경우 commitlog 및 데이터 파일을 다른 디스크에 저장하는 것이 좋습니다.

#### Environment variables

- 힙 크기와 같은 JVM 레벨 설정은 cassandra-env.sh에서 설정할 수 있습니다.
- 추가 JVM 명령 행 인수를 JVM_OPTS 환경 변수에 추가 할 수 있습니다. Cassandra가 시작되면 이러한 인수가 JVM으로 전달됩니다.
    - JVM 명령 행 인수 : JVM command line argument

#### Logging

- 사용중인 logger는 logback입니다.
- logback.xml을 편집하여 logging 속성을 변경할 수 있습니다.
- 기본적으로 INFO 레벨은 system.log 파일로, 디버그 레벨은 debug.log 파일에 기록됩니다.
