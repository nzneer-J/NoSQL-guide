Databases and Collections
==========

MongoDB는 BSON document를 저장한다.
BSON document는 Collections 안에 있으며, data record와 같다.
Collections은 Databases 안에 있다.

![Alt text](https://docs.mongodb.com/v3.4/_images/crud-annotated-collection.bakedsvg.svg)

# Databases

MongoDB에서 Databases는 document의 collections을 가진다.
사용하고자 하는 Database를 선택하기 위해서는 mongo shell에서 use 명령어를 사용하면 된다.
```
 use myDB
```
<br>

## create a Database
- 만약 데이터베이스가 없으면 MongoDB는 해당 데이터베이스에 처음으로 데이터를 저장할 때, 데이터베이스를 만든다.
- 따라서 다음과 같이 존재하지 않는 데이터베이스로 이동한 뒤에, 데이터를 삽입하면 새로운 데이터베이스(와 collection)가 생성된다.
```
use myNewDB
db.myNewCollection1.insertOne( { x: 1 } )
```

- 데이터베이스 이름에 대한 제한은 다음 목록에서 확인할 수 있다.
https://docs.mongodb.com/v3.4/reference/limits/#restrictions-on-db-names

# Collections
MongoDB는 document를 collection에 저장한다.
collection은 관계형 데이터베이스의 table과 유사하다.

## create a Collection
- 만약 collection이 존재하지 않는다면, 데이터베이스와 마찬가지로 처음 데이터가 저장될 때, 생성된다.
```
db.myNewCollection2.insertOne( { x: 1 } )
db.myNewCollection3.createIndex( { y: 1 } )
```

- 위에서 insertOne 뿐 아니라, createIndex로도 collection을 생성할 수 있다.

- 데이터베이스 이름에 대한 제한은 다음 목록에서 확인할 수 있다.
https://docs.mongodb.com/v3.4/reference/limits/#restrictions-on-collection-names

## Explicit Creation (명시적 생성)
- MongoDB는 db.createCollection() 함수를 제공하여 명시적으로 collection을 생성할 수 있게 한다.
- 이 함수는 최대 크기나 documentation validation rules 등의 다양한 옵션을 넣을 수 있다.
- 만약 이러한 옵션을 사용하지 않는다면, 굳이 이 함수를 쓸 필요가 없다.
<br>
이러한 collection 옵션을 수정하기 위해서는 다음을 참조:
https://docs.mongodb.com/v3.4/reference/command/collMod/#dbcmd.collMod

## Document Validation
- 기본적으로 collection 내의 document들은 같은 schema를 가질 필요가 없다.
- 하지만 3.2버전 이후에는 update와 insert 명령 시, collection의 document validation rules를 강제할 수 있다.
<br>
자세한 내용은 다음을 참조:
https://docs.mongodb.com/v3.4/core/document-validation/

## Modifying Document Structure
field의 추가/삭제, field value를 새로운 타입으로 변경과 같은 **collection 내의 document 구조를 수정**을 원한다면, document를 새로운 Structure로 update해야 한다.


원본 내용 : https://docs.mongodb.com/v3.4/core/databases-and-collections/
