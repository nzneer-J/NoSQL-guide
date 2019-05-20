# install CouchBase 5.5 Ubuntu 16.04

- CouchBase는 버전에 따라 OS 의존성이 강하다. 따라서 설치할 때, OS 버전에 맞는 CouchBase 버전을 설치하는 것이 중요하다.


### 1. deb 파일 다운로드

```
curl -O http://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-4-amd64.deb
```

### 2. deb 파일 설치 => gpg key 설정

- deb 파일을 설치한다고 바로 couchbase가 설치되진 않는다. dpkg 명령어의 결과로 gpg key가 저장되고, apt-get을 통해 couchbase를 설치할 수 있게 된다.

```
sudo dpkg -i couchbase-release-1.0-4-amd64.deb
```

### 3. apt-get update && couchbase-server-community 설치

```
apt-get update

sudo apt-get install couchbase-server-community
```

### 4. 설치 후, 서버 자동 실행 => 웹 콘솔로 접근

```
<host>:8091:
```


### 5. CouchBase 삭제

```
sudo apt-get purge couchbase-server-community
rm -rf /opt/couchbase
```
