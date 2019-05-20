# go 설치되어 있어야 합니다.
# govendor 가 실행 가능한 상태로 설치되어있어야 함

export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
go get -u github.com/kardianos/govendor


# mongoShake 설치 시작

git clone https://github.com/aliyun/mongo-shake.git
cd mongo-shake/src/vendor
GOPATH=`pwd`/../..; govendor sync
cd ../../ && ./build.sh

#conf/collector.conf 수정한 후, collector 실행
./bin/collector -conf=conf/collector.conf


#참고 링크 : https://github.com/aliyun/mongo-shake
#govendor : https://github.com/kardianos/govendor