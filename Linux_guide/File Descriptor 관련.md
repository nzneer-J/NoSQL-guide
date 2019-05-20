# File Descriptor

### File Descriptor 확인

cat /proc/sys/fs/file-max

cat /proc/sys/fs/file-nr

- ex

```
# cat /proc/sys/fs/file-nr
945 0 411075
```

- 945 : 현재 오픈되어 있는 파일의 수
- 411075 : 오픈할 수 있는 최대 파일 수


### 값 변경

```
echo 819200 > /proc/sys/fs/file-max
```

- 부팅 시, 자동 적용

```
# vi /etc/sysctl.conf
fs.file-max = 819200
```
