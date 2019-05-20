# 클러스터 구성 시, 트러블 슈팅

log , pid 등 파일의 경로를 설정해줘야 한다.


 /database/redis-cluster/7001/redis-server /database/redis-cluster/7001/redis.conf
 working directory 설정없이 이렇게 실행하면, 실행했을 때, 위치한 디렉토리에 log aof 파일 등이 나타나기 때문에, aof rdb는 dir 설정이 꼭 필요하고, pid log 등은 꼭 특정한 path를 지정해줘야 한다.

node.conf 가 중복되서 클러스터 인스턴스가 실행되지 않는 경우가 발생했었다.


client port 뿐 아니라, cluster bus port를 열어주는 것도 기억해야 한다.


cluster create 시, waiting cluster join 이 계속 되는 경우, bind 설정에 127.0.0.1이 제일 앞에 있는지 확인이 필요하다.
    가장 앞에 있는 경우, 버그로 인해 cluster가 생성되지 않는다고 한다.
    127.0.0.1을 삭제하거나 맨 뒤로 보내는 식으로 고쳐야 한다.
