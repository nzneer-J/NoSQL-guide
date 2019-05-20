# EC2 인스턴스에서 redis 접근하기

1. redis-cli
    - redis-cli가 설치되어 있는 인스턴스에서는 redis-cli를 통한 접근이 가능하다.

```
redis -h <endpoint> -p <port>
```

2. telnet
    - redis-cli가 없더라도, elasticache에 접근이 가능한 인스턴스라면 telnet으로도 접근 가능하다.
    - telnet으로 접근하더라도 명령어 입력이 가능하기 때문에, 굳이 redis-cli를 설치할 필요는 없다.
    - telnet 접속 종료시 ctrl+] 를 누른 뒤, q를 입력하면 된다.

```
telnet <endpoint> <port>
```

    
