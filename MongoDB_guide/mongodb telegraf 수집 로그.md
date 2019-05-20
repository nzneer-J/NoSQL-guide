# MongoDB 수집 로그 (telegraf)

active_reads		현재 reading 중인 thread 수
active_writes		현재 writing 중인 thread 수

commands_per_sec	Number of general commands
deletes_per_sec		Number of documents deleted
flushes_per_sec 	Number of calls to fsync
getmores_per_sec	Number of getmore commands against cursors
inserts_per_sec		Number of documents inserted


net_in_bytes		네트워크 input
net_out_bytes		네트워크 output
open_connections	평균 open connections 수

percent_cache_dirty	캐시 중 dirty 퍼센트, Percentage of wiredTiger cache waiting to be written
percent_cache_used	사용 중인 캐시 퍼센트, Percentage of wiredTiger cache currently in use

queries_per_sec		Number of find commands
queued_reads		처리를 기다리는 read
queued_writes		처리를 기다리는 writes

resident_megabytes	resident memory 양 (mb)
updates_per_sec		매초 당 업데이트

vsize_megabytes		Virtual size of mapped database - approximately total database size

total_in_use
total_available
total_created
total_refreshing

ttl_deletes_per_sec	ttl-index 삭제 개수
ttl_passes_per_sec	ttl-index 삭제를 위한 스캔 횟수

repl_lag 		            레플리카 지연
repl_commands_per_second	Commands per second from replset primary
repl_deletes_per_sec	    Deletes per second from replset primary
repl_getmores_per_second	Getmores per second from replset primary
repl_inserts_per_second	    Inserts per second from replset primary
repl_queries_per_second	    Queries per second from replset primary
repl_updates_per_second	    Updates per second from replset primary


jumbo_chunks (only if mongos or mongo config) 점보 청크 수 (점보 : 청크의 최대 크기를 초과하는 청크를 분할할 수 없는 경우, 해당 청크에 점보 라벨을 붙인다.) Number of open chunks detected




collections
objects
avg_obj_size
data_size
storage_size
num_extents
indexes
index_size
ok
