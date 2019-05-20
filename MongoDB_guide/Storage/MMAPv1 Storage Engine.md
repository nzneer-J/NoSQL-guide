MMAPv1 Storage Engine
===========
MMAPv1은 memory mapped files을 기반으로 한 MongoDB의 original storage engine이다.
_높은 볼륨의 inserts, reads, in-place update에서 작업 부하에 뛰어나다._
_Memory Mapped file?_ 파일의 메모리 주소 값으로 데이터를 참조?

## Journal
- MongoDB data set이 디스크에 쓰일 때, 모든 수정에 대해 확실히 하기 위해 기본적으로 MongoDB는 모든 수정사항을 on-disk journal에 기록한다.
- MongoDB는 data files에 쓰는 것보다 더 자주 저널을 기록한다.
- 저널은 모든 변경사항을 flush 하기 전에 mongod instance가 종료되었을 때, 성공적으로 데이터를 복구할 수 있게 도와준다.

MongoDB의 Journaling에 대해 더 자세히 알고 싶다면 다음을 참조하라 :
https://docs.mongodb.com/v3.0/core/journaling/

## Record Storage Characteristics
- 디스크의 모든 record는 연속적으로 위치하고 있으며, document가 할당된 record보다 커지면 MongoDB는 새로운 record를 할당한다.
- 새로운 할당(allocations)은 document를 이동시키고, document를 참조하는 모든 Index를 update할 것을 요구한다. 이는 모든 데이터를 갱신하는 것보다 오래 걸리고, storage fragmentation(스토리지 단편화)을 야기한다.
<br>
_changed in version 3.0.0_
- 기본적으로 MongoDB는 모든 document가 document 자신과 여분 공간(extra space) 또는 padding이 포함되는 record에 저장되게 하기 위해 Power of 2 Sized Allocations을 사용한다.
- Padding은 document가 update의 결과로 커지더라도 재할당(reallocation)의 가능성을 최소한으로 줄여준다.

## Record Allocation Strategies
- MongoDB는 mongod가 record를 만들 때, document에 어떻게 padding을 추가하는지 결정하는 multiple record allocation strategies를 지원한다.
- MongoDB 내의 document는 삽입 후에 크기가 커질 수 있고, 모든 record가 디스크에 연속적으로 있기 때문에, padding이 (업데이트 이 후,) 디스크에 있는 document의 relocate 필요성을 줄여준다.
- relocation은 in-place update보다 효율성이 낮고, storage fragmentation을 야기한다.
- 결과적으로, 모든 padding Strategies은 효율성을 높이고, 단편화를 줄이기 위해 추가적인 공간을 사용한다.( 추가적인 공간과 효율성을 trade 한다.)

- 여러 allocation strategies는 다른 종류의 작업 부하를 지원한다.
  + power of 2 allocations는 insert/update/delete의 작업부하에 대해 더 효율적이다.
  + exact fit allocations는 update와 delete의 작업 부하를 가지지 않은 collection에 이상적이다.

### Power of 2 Sized Allocations
_changed in version 3.0.0_
- MongoDB 3.0은 MMAPv1을 위한 기본 record allocation strategy로 the power of 2 sizes allocation을 사용한다.
- the power of 2 sizes allocation에서 모든 record는 2의 제곱수 만큼의 bytes 사이즈를 가진다.
- document가 2MB보다 커지면, 2MB의 가장 가까운 배수로 반올림되어 할당된다.
<br>
- the power of 2 sizes allocation은 다음과 같은 key properties(주요 속성)를 가진다.
  + freed record를 효율적으로 재사용하여 fragmentation을 줄인다.
    + record 할당 크기를 고정된 사이즈로 Quantizing하면, 삽입할 때, document의 제거나 relocate로 생긴 free space에 딱 맞게 데이터가 들어갈 가능성을 증가시킨다.
  + 데이터 이동을 줄인다.
    + 추가된 padding space는 이동을 하지 않고도 크기가 커질 수 있는 document room을 제공한다.
    + 데이터 이동의 비용을 아끼면서, 결과적으로 index의 update를 줄일 수 있다.
    + he power of 2 sizes allocation이 비록 이동을 최소화할 수는 있지만, 완전히 제거하지는 못한다.

### No Padding Allocation Strategy
- 크기를 증가시키지 않는 update나 insert만을 수행하는 operations으로 구성된 작업 부하를 가지는 collection의 경우, document size가 증가될 작업 부하가 없기 때문에 power of 2 allocation을 수행할 필요가 없다.
- collMod command를 noPadding flag와 실행시키거나 db.createCollection() 함수를 noPadding 옵션으로 호출해라

3.0.0 이전의 버전에는 MongoDB가 동적으로 계산된 padding을 document size의 요소로 포함하는 allocation strategy를 사용했다.



원본 내용 : https://docs.mongodb.com/v3.0/core/mmapv1/
