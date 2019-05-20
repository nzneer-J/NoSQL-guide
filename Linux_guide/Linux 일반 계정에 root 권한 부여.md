# root 권한을 특정 계정에 부여하는 방법

수정해야 하는 파일
```
/etc/sudoers (sudo 권한 부여하기)
/etc/group (root 그룹 부여하기)
/etc/passwd (root의 uid, gid로 변경)
```

<br>
### 1.  /etc/sudoers 파일을 수정하여 sudo 명령어를 사용 가능하도록 변경
```
## Next comes the main part: which users can run what software on
## which machines (the sudoers file can be shared between multiple
## systems).
## Syntax:
##
##      user    MACHINE=COMMANDS
##
## The COMMANDS section may have other options added to it.
##
## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
```
```
# root    ALL=(ALL)       ALL 아래에 추가
[계정명]    ALL=(ALL)    ALL
```
<br>
### 2. /etc/group 파일 수정
```
# 가장 위의 root:x:0: 에 계정명 추가
root:x:0:[계정명]
```
- 또는 /etc/group 파일을 건드리지 않고도 gpasswd -a [계정명] [추가할그룹명] 명령어 사용 가능

<br>

### 3. /etc/passwd 파일 수정
```
# 하단에 있는 자신의 계정명을 찾아서, UID와 GID부분을 0으로 설정
...
haldaemon:x:68:68:HAL daemon:/:/sbin/nologin
ntp:x:38:38::/etc/ntp:/sbin/nologin
saslauth:x:499:76:"Saslauthd user":/var/empty/saslauth:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
tcpdump:x:72:72::/:/sbin/nologin
oprofile:x:16:16:Special user account to be used by OProfile:/home/oprofile:/sbin/nologin
named:x:25:25:Named:/var/named:/sbin/nologin
[계정명]:x:0:0::/home/[계정명]:/bin/bash
...
```
<br>
### 4. 설정 후, 로그아웃 후 다시 로그인
