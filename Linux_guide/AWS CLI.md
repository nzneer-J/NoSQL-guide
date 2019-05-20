## aws s3

- s3를 마운트해서 사용하는 것보다 AWS CLI를 사용하는 것이 낫다.
- AWS CLI가 EC2 머신에 설치되어 있어야 한다.

### 명령어

```
cp
mv
rm

sync
mb
rb
ls
```

#### 1. cp

- EC2 에서 S3 로 cp 하면 업로드, S3 에서 EC2 로 cp 하면 다운로드

```
aws s3 cp /local/object s3://bucket/to/object/path
aws s3 cp s3://bucket/from/object/path /local/to/path
```

- ex

```
aws s3 cp README.txt s3://algopie-test
aws s3 cp s3://algopie-test/README.txt ./
```

#### 2. mv

- 명령어 패턴은 cp와 동일하다.
- cp 와 마찬가지로 업로드, 다운로드 둘 다 가능하며, 명령이 실행 완료되면 오리지날 object가 지워지는 차이점이 있다.

#### 3. rm

- S3 에 있는 object를 삭제하는 명령어 옵션이다.

```
aws s3 rm s3://bucket/to/path
```

- ex

```
aws s3 rm s3://algopie-test/README.txt
```

#### 4. ls

- 해당 버킷에 들어 있는 파일 목록을 볼 수 있는 명령어 옵션입니다.

```
aws s3 ls s3://bucket/to/path
```

- ex

```
aws s3 ls s3://algopie-test
```

#### 5. mb
- make bucket 으로, S3에 버킷을 생성하는 명령어 옵션이다.

```
aws s3 mb s3://bucket
```

- ex

```
aws s3 mb s3://algopie-test
```

#### 6. rb
- remove bucket 으로, 버킷 자체를 삭제하는 명령어 옵션이다.

```
aws s3 rb s3://bucket
```

- ex

```
aws s3 rb s3://algopie-tmp
```

#### 7. sync
- 동기화하는 명령어 옵션이다.
- local to s3 / s3 to local / s3 to s3 의 3가지를 지원한다.

```
aws s3 sync /local/from/path s3://bucket/to/path
aws s3 sync s3://bucket/from/path /local/to/path
aws s3 sync s3://bucket/from/path s3://bucket/to/path
```

- ex

```
aws s3 sync /home/www/algopie-public s3://algopie-public
aws s3 sync s3://algopie-tmp /home/www/tmp
aws s3 sync s3://algopie-public s3://algopie-tmp
```

#### aws configure
aws configure
aws configure --profile <user>

```
AWS Access Key ID [None]: ***********
AWS Secret Access Key [None]: ****************
Default region name [None]: ******
Default output format [None]: ****
```
~/.aws/credentials
~/.aws/config

aws_access_key_id - AWS 액세스 키
aws_secret_access_key - AWS 보안 키
aws_session_token - AWS 세션 토큰. 세션 토큰은 임시 보안 자격 증명을 사용하는 경우에만 필요합니다.
region - AWS 리전
output - 출력 형식(json, 텍스트 또는 테이블)
