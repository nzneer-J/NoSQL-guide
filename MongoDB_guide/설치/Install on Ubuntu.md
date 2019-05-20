# Install MongoDB 3.4 Community Edition on Ubuntu 16.04

#### MongoDB package 종류
1. mongodb-org : 모든 mongodb package를 자동적으로 설치
2. mongodb-org-server : mongod 데몬 및 관련 configuration, 초기 script
3. mongodb-org-mongos : mongos 데몬
4. mongodb-org-shell : mongo shell
5. mongodb-org-tool : 다음과 같은 MongoDB tools
    + mongoimport bsondump, mongodump, mongoexport, mongofiles, mongooplog, mongoperf, mongorestore, mongostat, mongotop

<br><br>

## MongoDB 설치
### 1. Import the public key used by the package management system.
```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
```

<br>

### 2. Create a list file for MongoDB.
```bash
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
```

<br>

### 3. Reload local package database.
```bash
sudo apt-get update
```

<br>

### 4. Install the MongoDB packages
```bash
sudo apt-get install -y mongodb-org
```

<br><br>

## MongoDB 실행
1. 기본 환경설정인 /etc/mongod.conf 설정으로 백그라운드에서 실행하는 경우

```bash
sudo service mongod start
```

2. 다른 경로인 conf 파일로 백그라운드에서 실행하는 경우 (권장하지 않음)

```bash
mongod --config <path-config-file> &
```

- 프로세스 동작 확인

```bash
ps -ef
```

- mongod 실행 시, dbpath에 해당하는 폴더가 없으면 mongod가 실행되지 않는다.

<br><br>

## mongos 서비스 구성하기
#### 1. systemd 서비스 파일 생성
```bash
cd /lib/systemd/system/
cp ./mongod.service ./mongos.service
```

<br>

####2. 서비스 파일 수정
```bash
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target
Documentation=https://docs.mongodb.org/manual

[Service]
User=mongodb
Group=mongodb
ExecStart=/usr/bin/mongos --config /etc/mongos.conf
PIDFile=/var/run/mongodb/mongos.pid
# file size
LimitFSIZE=infinity
# cpu time
LimitCPU=infinity
# virtual memory size
LimitAS=infinity
# open files
LimitNOFILE=64000
# processes/threads
LimitNPROC=64000
# locked memory
LimitMEMLOCK=infinity
# total threads (user+kernel)
TasksMax=infinity
TasksAccounting=false

# Recommended limits for for mongod as specified in
# http://docs.mongodb.org/manual/reference/ulimit/#recommended-settings

[Install]
WantedBy=multi-user.target
```

<br>

#### 3. config 파일 생성
```bash
cp /etc/mongod.conf /etc/mongos.conf
```

<br>

#### 4. config 파일 수정

- 데이터 폴더가 필요 없어서 dbpath는 주석 처리 및 삭제
- sharding.configDB 항목 추가

<br>

#### 5. systemd 데몬 등록 및 로드
```bash
sudo systemctl daemon-reload
```
또는
```bash
systemctl --system daemon-reload
```

<br>

#### 6. mongos 서비스 등록
```bash
systemctl unmask mongos.service
```
또는
```bash
systemctl enable mongos.service
```

<br>

#### 7. mongos 시작 및 확인
```bash
systemctl start mongos.service
systemctl status mongos.service
```

<br>

#### mongos 서비스 중지, 제거
```bash
systemctl stop mongos.service
systemctl disable mongos.service
```

<br>

- 정상적으로 서비스가 시작되지 않을 경우 파일 권한 체크

```bash
cd /tmp/
chown mongodb:mongodb ./mongodb-2701*
```

<br><br>

## mongo shell 실행

1. 기본설정인 localhost의 27017 port의 프로세스의 shell 실행 시

```bash
mongo
```

<br>

2. 특정 host의 특정 port의 프로세스의 shell 실행 시

```bash
mongo --host <ip 또는 hostname> --port <port 번호>
```

<br><br>

## MongoDB 프로세스 중지

1. 서비스 명령어 사용

```bash
sudo service mongod stop
```

<br>

2. 또는 PID를 아는 경우

```bash
sudo kill -9 <PID>
```

<br><br>

## MongoDB 삭제

MongoDB의 프로세스가 다 중지/삭제된 상태에서
라이브러리(MongoDB 패키지)와 데이터 폴더를 전부 삭제한다.

- MongoDB 패키지 삭제

```bash
sudo apt-get purge mongodb-org*
```

또는

```bash
sudo apt-get remove mongodb-org*
```
> remove는 패키지만 삭제하고, purge는 패키지와 설정 파일까지 삭제한다.

<br>

- MongoDB 데이터 폴더 삭제

```bash
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongodb
```
<br><br>

## MongoDB 다시 설치하기

- mongoDB 삭제
```bash
sudo apt-get purge mongodb-org*
```

- 데이터 폴더 삭제
```bash
rm -rf /var/log/mongodb
rm -rf /var/lib/mongodb
```

- 다시 설치
```bash
sudo apt-get install mongodb-org
```

- 만약 MongoDB 실행 시, Failed to start mongod.service: Unit mongod.service not found 에러 나오면
```bash
sudo systemctl enable mongod
sudo service mongod restart
```
