Replica Set Members
========
MongoDB에서 replica set은 redundancy(중복)과 high availability(높은 가용성)을 제공하는 mongod 프로세스이다.
<br>
replica set의 member는 다음과 같다 :
- Primary
  + Primary는 모든 write 작업을 receive한다.
- Secondaries
  + Secondaries는 동일한 data set을 유지하기 위해서 Primary로부터 operation을 복제한다.
  + Secondaries는 특수한 usage profiles을 위한 추가적인 configuration을 가질 수 있다.
    + non-voting, priority 0 등
<br>
- 또한, replica set의 일부로 arbiter를 가질 수 있다.
- arbiter는 데이터를 유지하지 않는다.
- 하지만, arbiter는 현재 Primary가 unavailable할 때, 새로운 primary를 선출하는 선거에서 역할을 한다.
<br>
- replica set의 최소 권장 구성은 다음과 같다.
  + primary
  + Secondary
  + arbiter
- 그러나 대부분의 대포에서는 데이터를 저장하는 세 멤버를 가진다.
  + primary
  + 2개의 Secondary
<br>
- 이전에는 12개의 member를 가질 수 있었지만, *3.0.0 버전* 이후에는 replica set은 총 50개의 member를 가질 수 있지만, voting member는 7개만 보유할 수 있다.


## Primary
- primary는 replica set에서 유일하게 write operation을 receive하는 member이다.
- MongoDB는 primary에 write operation을 적용한 후, primary의 oplog에 operation을 기록한다.
- Secondary는 이 log를 복제하여 자신들의 데이터에 적용한다.
<br>
- 그림과 같은 3개의 멤버를 가진 replica set의 경우,
- 모든 write operations을 primary가 처리하고
- Secondary는 primary의 oplog을 복제하여, 자신들의 data set에 적용한다.
![Alt Text](https://docs.mongodb.com/v3.0/_images/replica-set-read-write-operations-primary.png)
<br>
- replica set의 모든 member는 read operations을 받을 수 있다.
- 하지만 기본적으로 응용 프로그램은 primary에게 read operations을 지시한다.
- 읽기 작업 관련 기본 설정 변경에 대한 자세한 내용은 아래 링크를 확인하라 :
https://docs.mongodb.com/v3.0/core/read-preference/
<br>
- replica set은 하나의 primary를 가질 수 있다.
- 만약 primary가 unavailable하게 되면, 새로운 primary를 위한 election(선거)를 한다.
- 관련 자세한 내용은 링크를 참조하라 :
https://docs.mongodb.com/v3.0/core/replica-set-elections/

## Secondaries
- Secondary는 primary의 data set의 복사본을 유지한다.
- Secondary는 비동기적 프로세스로 primary의 oplog를 복제하여 이를 data set에 적용한다.
- replica set은 하나 이상의 Secondary를 가질 수 있다.
- _중간 내용은 같은 내용을 반복으로 생략하겠다._
<br>
- client는 Secondary에 데이터를 write 하지는 못하지만, data를 read할 수는 있다.
- client가 replica set의 읽기 작업 관련 지시를 어떻게 하는지에 대해서는 링크를 참조 :
https://docs.mongodb.com/v3.0/core/read-preference/
<br>
- Secondary는 primary가 될 수도 있다.
- 현재 primary가 unavailable하게 되었을 때, replica set이 어떤 Secondary가 primary가 될지 선택하기 위한 선거를 열 수 있다.

- Secondary를 특수한 목적으로 설정할 수 있다.
- 다음과 같은 설정이 있다 :
  + Priority 0 Replica Set Members
    + *Secondary data center에 상주(reside)하거나 cold standby 역할을 할 수 있게 하는* 선거에서 primary가 되는 것을 방지한다.
  + Hidden Replica Set Members
    + 애플리케이션이 data를 읽을 수 없게 한다.
    + normal traffic과의 분리를 요구하는 애플리케이션을 동작시킬 수 있다.
    _내용 이해가 어려움_
  + Delayed Replica Set Members
    + 의도되지 않은 데이터베이스 삭제와 같은 특정 오류로부터의 복구에 사용하기 위해 running “historical” snapshot을 유지한다.

## Arbiter
- arbiter는 data set을 복사하지 않고, primary가 될 수도 없다.
- replica set은 primary 선거를 위해서 arbiter를 가진다.
- arbiter가 한 표의 선거권을 가짐으로써, replica set은 추가적인 데이터 복사 없이, 선거를 위한 홀수의 멤버 수를 가질 수 있다.

> important : replica set의 primary나 Secondary를 호스트하는 시스템에서 arbiter를 실행시키지 마시오.

- 짝수 개의 member를 가진 set에만 arbiter를 추가해라
- 홀수 개의 member를 가진 set에서 arbiter를 추가하면, tied election(묶인 선거)에 시달릴 수 있다.
자세한 내용은 아래 링크 참조 :
https://docs.mongodb.com/v3.0/tutorial/add-replica-set-arbiter/


원본 내용 : https://docs.mongodb.com/v3.0/core/replica-set-members/
