views
==================
3.4 버전에서는 collections 또는 다른 views의 read-only views의 생성을 지원한다.

## create View

view를 생성하거나 정의하기 위해서
- **create** command(and db.createCollection helper)의 *viewOn* 과 *pipeline* 옵션 사용
```
db.runCommand( { create: < view >, viewOn: < source >, pipeline: < pipeline > } )
```

또는 view의 default collation을 지정하는 경우
```
db.runCommand( { create: < view >, viewOn: < source >, pipeline: < pipeline >, collation: < collation > } )
```

새로운 mongo shell helper인 db.createView()
```
db.createView(< view >, < source >, < pipeline >, < collation > )
```
## Behavior
view는 다음과 같은 동작을 한다.

### Read Only
- view는 읽기만 허용되기 때문에, 쓰기 작업은 에러가 난다.
- view는 다음과 같은 read operations을 지원한다 :
  + db.collection.find()
  + db.collection.findOne()
  + db.collection.aggregate()
  + db.collection.count()
  + db.collection.distinct()

### Index Use and Sort Operations
- view는 자신이 참조하는(underlying) collection의 인덱스를 사용한다.
- underlying collection의 인덱스를 사용하는 경우, view에서 인덱스를 직접 생성하거나 삭제 또는 re-build를 하거나 인덱스 목록을 가져오는 것은 하지 못한다.
- view에서는 다음과 같은 natural sort를 지정할 수 없다.
```
db.view.find().sort({$natural: 1})
```

### Projection Restrictions
- view에서 find() 명령어는 다음과 같은 Projection operators를 지원하지 않는다 :
  + $
  + $elemMatch
  + $slice
  + $meta

### Immutable Name
view의 rename을 할 수 없다.

### View Creation

### Sharded View

### Views and Collation

### Public View Definition

## Drop a View

## Modify a View

## Supported Operations


원본 내용 : https://docs.mongodb.com/v3.4/core/views/



//
