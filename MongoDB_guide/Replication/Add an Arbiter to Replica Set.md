# Add an Arbiter to Replica Set

- arbiter를 위한 data폴더를 만들어 준다. (configration data를 위한)
```
mkdir \<filepath>
```

- conf파일에서 storage.journal.enabled을 false로 설정해야 한다.
```
storage:
  journal:
    enabled : false
```
- shrad Role은 지정해줄 필요 없다.
<br>

- mongod 프로세스 실행
```
mongod --config \<config-file-path>
```

- Primary의 mongo shell에서
```
rs.addArb("\<hostname>:\<port 번호>")
```

- warning:
  + 두 개 이상의 arbiter를 추가하는 것은 피하라
