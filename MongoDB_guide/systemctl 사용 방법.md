# MongoDB systemctl 설정 주의

- mongos와 mongod 명령어 구분 주의
- conf 파일에서 processManagement:fork, processManagement:pidFilePath 설정 되있으면, child 생성 관련 에러 발생
- 같은 포트 쓰는 프로세스 없는지 확인
    + 같은 포트 쓰는 서비스가 중복으로 enable 되어 있는 경우, 실행은 되나 socket 생성이 안됨
    + 포트 중복되는 서비스 중지시키고, (restart 사용하지 말고 ) stop 이후에 start 실행으로 다시 실행
- data 파일 경로 또는 log 파일 경로가 생성되어 있는지 확인
- 포트 열리는지 확인
- 권한 관련해서 계정에 알맞은 권한이 있는지 확인


- /tmp/ 폴더에서 socket 파일 권한 설정 (mongodb 계정)
chown mongodb:mongodb ./mongodb-2701*    

- mongod를 root로 실행시켰으면, 나중에 mongodb 계정으로 실행시켰을 때, 권한 문제로 에러 발생한다.
