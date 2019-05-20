# 먼저 go tar.gz 파일을 서버로 업로드

tar -C /usr/local -xzf go1.4.2.linux-amd64.tar.gz

# GOPATH 설정 (go 워크스페이스)
mkdir $HOME/go

#/etc/profile에 path 추가
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# git 설치 후, 외부 라이브러리 받을 수 있는 환경 구성 완료

참조 링크 : https://github.com/arahansa/golkorea/wiki/02.-Go%EA%B0%9C%EB%B0%9C%ED%99%98%EA%B2%BD-%EA%B5%AC%EC%B6%95_Linux-%ED%8E%B8