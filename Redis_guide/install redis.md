# install redis

## 설치

```bash
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
make test
```

<br>

- gcc 등의 문제로 오류 발생 시. ( 예 : make[3]: *** [net.o] Error 127 )

```bash
sudo apt-get install make
sudo apt-get install gcc
sudo apt-get install tcl
sudo apt-get install build-essential
sudo apt-get update
```

- 실행 파일을 절대 경로 없이 사용하고 싶다면, 다음 명령어로 파일을 bin으로 복사

```bash
sudo cp src/redis-server /usr/local/bin/
sudo cp src/redis-cli /usr/local/bin/
```

## 실행

```bash
redis-server
```

- redis-server의 첫번째 인수로 conf 파일을 추가하면 conf 파일의 옵션 사용 가능

```bash
redis-server /etc/redis.conf
```

- server 실행 체크

```
 redis-cli ping
```
결과로 PONG이 나온다.

- redis-cli 다음에 명령 이름을 입력하면 redis의 인스턴스로 전송
- 그냥 redis-cli를 그냥 입력하면 대화형으로 입력 가능하다.


## config, 서비스 파일 생성

- conf 파일 경로 및 데이터 파일 경로 생성

```bash
sudo mkdir /etc/redis
sudo mkdir /var/redis
```

- 서비스 파일 복사

```bash
sudo cp utils/redis_init_script /etc/init.d/redis_6379
```

- conf 파일 복사

```bash
sudo cp redis.conf /etc/redis/6379.conf
```

- 포트별 데이터 폴더 생성

```bash
sudo mkdir /var/redis/6379
```

- 서비스 등록

```bash
sudo update-rc.d redis_6379 defaults
```

- 서비스 실행

```bash
sudo /etc/init.d/redis_6379 start
```
