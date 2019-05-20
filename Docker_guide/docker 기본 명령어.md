# 도커 기본 명령어

## docker container

- 도커 이미지를 실행시키면 도커 컨테이너가 올라간다.

#### docker run

- 도커 이미지를 이용해서 컨테이너를 올린다.
- 옵션을 잘 설정해서 올려야 한다.

#### docker ps

- 현재 올라가있는 컨테이너를 표시해준다.
- docker ps -a 를 하면 종료된 컨테이너를 포함한 모든 컨테이너를 보여준다.

#### docker rm

- 도커 컨테이너를 삭제한다.


#### docker restart

- stop 시킨 컨테이너를 다시 시작시킨다.

#### docker attach

- 실행 중인 컨테이너에 접근(접속)할 수 있다.

## docker image

#### docker pull

- 도커 이미지를 다운로드 받을 때, 사용한다.
- docker run 시, 도커 이미지가 없으면 자동으로 실행된다.

#### docker images

- 도커 이미지 리스트를 보여준다.

#### docker rmi

- 도커 이미지를 삭제한다.

#### docker diff

- 컨테이너에서 수정한 내용을 저장한다.
    - 실제 이미지가 변경되거나 만들어지는 건 아님

#### docker commit

- git에서 commit하듯이 수정된 내용을 commit하여 새 도커 이미지를 생성한다.
