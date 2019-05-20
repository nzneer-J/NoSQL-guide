Document
=======

MongoDB는 BSON document 형식으로 데이터 record를 저장한다.
BSON은 JSON document의 binary representaion이고, JSON보다 더 많은 데이터 타입을 포함한다.

BSON의 spec을 보고자 한다면 다음을 참조:
http://bsonspec.org/
https://docs.mongodb.com/v3.4/reference/bson-types/

![Alt Text](https://docs.mongodb.com/v3.4/_images/crud-annotated-document.bakedsvg.svg)

## Document Structure

MongoDB document는 field value 쌍으로 구성되어 있으며, 다음과 같은 구조를 가진다.

```
{
    field1: value1,
    field2: value2,
    field3: value3,
    ...
    fieldN: valueN
 }
```

  field의 value는 다음을 포함한 어떤 종류의 BSON 데이터 타입이라도 될 수 있다.
  - 다른 document
  - array
  - array of document

```
var mydoc = {
               _id: ObjectId("5099803df3f4948bd2f98391"),
               name: { first: "Alan", last: "Turing" },
               birth: new Date('Jun 23, 1912'),
               death: new Date('Jun 07, 1954'),
               contribs: [ "Turing machine", "Turing test", "Turingery" ],
               views : NumberLong(1250000)
            }
```

위의 field들은 다음과 같은 data type을 가진다.

- id = ObjectId
- name = first와 last field를 가진 embedded document
- birth, death : Date type
- contribs = array of String
- view = NumberLong type

### Field names

field name은 string이다.
document의 field name은 다음과 같은 제한을 가진다 :

- \_id는 primary key로 사용되기 위해 예약되어 있다. 이 값은 항상 unique해야 한다. 불변하고, array를 제외하고 어떤 타입이든 될 수 있다.
- ($) 으로 시작할 수 없다.
- (.) 을 포함할 수 없다.
- null 을 포함할 수 없다.

BSON document는 같은 이름의 field를 여러 개 만들 수 있다. 하지만 대부분의 MongoDB interface는 field name의 duplicate(중복, 복제)를 지원하지 않는다.

만약 같은 이름의 field를 여러 개 다루고 싶다면, 다음을 참조해라
https://docs.mongodb.com/v3.4/applications/drivers/

_internal MongoDB process에 의해 만들어지는 어떤 document들은 duplicate field를 가질 수 있다. 하지만 existing user document에 duplicate field를 추가할 수 있는 MongoDB process는 없다._
__Some documents created by internal MongoDB processes may have duplicate fields, but no MongoDB process will ever add duplicate fields to an existing user document.__




//
