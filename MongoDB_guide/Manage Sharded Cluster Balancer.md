# Manage Sharded Cluster Balancer

- Balancer의 enabled 여부를 알기 위해 (return : ture / false)

```
sh.getBalancerState()
```

- Balancer의 active(running) 여부를 알기 위해

```
sh.isBalancerRunning()
```

<br>

### Schedule the Balancing Window

1. mongos의 mongo shell에 접속

```
mongo --host <host> --port <port>
```

<br>

2. Config 데이터베이스로 switch

```
use config
```

<br>

3. Balancer의 state를 true로 설정
- Balancer가 stopped(false)면, balancer를 사용할 수 없다.

```
sh.setBalancerState( true )
```

<br>

4.  balancer's window 설정 수정
- update 함수로 activeWindow 설정

```
db.settings.update(
   { _id: "balancer" },
   { $set: { activeWindow : { start : "<start-time>", stop : "<stop-time>" } } },
   { upsert: true }
)
```

- \<start-time>, \<end-time>는 HH:MM 형식이다


### Balancing Window Schedule 제거

- $unset 사용

```
use config
db.settings.update({ _id : "balancer" }, { $unset : { activeWindow : true } })
```

### Disable the Balancer

- balancer를 멈춤으로써, 필요한 경우 마이그레이션을 방지할 수 있다.

```
sh.stopBalancer()
```

- 마이그레이션이 일어나는지 확인하기 위해

```
use config
while( sh.isBalancerRunning() ) {
          print("waiting...");
          sleep(1000);
}
```


원본 내용 : https://docs.mongodb.com/v3.4/tutorial/manage-sharded-cluster-balancer/
