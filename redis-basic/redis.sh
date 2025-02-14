### redis 는 0~15번까지의 database 로 구성
select 14

### 데이터베이스 내 모든 키 조회
keys *

### string 자료구조
# set 을 통해 key:value 세팅
set user:email:1 hong1@naver.com

# nx : 이미 존재하면 pass, 없으면 set
set user:email:2 hong2@naver.com nx

# ex : 만료시간(초 단위), ttl(time to live)
set user:email:3 hong3@naver.com ex 10
# expire : 생성 시점 이후에 만료시간 지정
expire user:email:2 3600

# redis 실무 활용 : 사용자 인증 정보 저장(ex-refresh 토큰)
set user:1:refresh_token eyjaxabaalsdkal ex 100000

# 특정 키의 값 조회
get user:email:1

# 특정 key 삭제
del user:email:1

# 현재 DB 내 모든 key 삭제
flushdb

# redis 활용 : 좋아요 기능 구현
set likes:posting:1 0
incr likes:posting:1 # 특정 key 값의 value 를 1만큼 증가시킨다.
decr likes:posting:1 # 특정 key 값의 value 를 1만큼 감소시킨다.
get likes:posting:1

# redis 활용 : 재고 관리
set stocks:product:1 100
decr stocks:product:1
get stocks:product:1

# redis 활용 : 캐싱(임시 저장) 기능 구현
set posting:1 "{\"title\":\"hello java\", \"contents\":\"hello java is...\", \"author_email\":\"hong@naver.com\"}" ex 100

### Lists 자료구조 : redis 의 Lists 는 deque 자료구조
# lrange : 리스트의 범위 조회
# lpush : 데이터를 왼쪽 끝에 삽입
# rpush : 데이터를 오른쪽 끝에 삽입
# lpop : 데이터를 왼쪽에서 꺼내기
# rpop : 데이터를 오른쪽에서 꺼내기
lpush hongildongs hong1
lpush hongildongs hong2
rpush hongildongs hong3
lrange hongildongs 0 -1
rpop hongildongs
lpop hongildongs

# Lists 조회
# -1은 리스트의 마지막 요소를 의미, -2는 끝에서 2번째를 의미
lrange hongildongs 0 0 # 첫 번째 값만 조회
lrange hongildongs -1 -1 # 마지막 값만 조회
lrange hongildongs 0 -1 # 처음부터 끝까지 조회
lrange hongildongs -2 -1 # 마지막 2번째 부터 마지막 까지 조회
lrange hongildongs 0 1 # 처음부터 2번째 까지

# 데이터 개수 조회
llen hongildongs

# TTL 적용
expire hongildongs 20

# TTL 조회
ttl hongildongs

# redis 활용 : 최근 방문한 페이지, 최근 조회한 상품목록
rpush mypages www.naver.com
rpush mypages www.google.com
rpush mypages www.daum.net
rpush mypages www.chatgpt.com
rpush mypages www.daum.com
# 최근 방문한 페이지 3개 조회
lrange mypages 0 2

### Set 자료구조 : 순서가 없고 중복을 허용하지 않는 자료구조
# set 에 값 추가
sadd memberlist member1
sadd memberlist member2
sadd memberlist member3

# set 조회
smembers memberlist

# set 데이터 개수 조회
scard memberlist

# set 데이터 삭제
srem memberlist member2

# 특정 요소가 set 안에 들어있는지 확인
# 0 -> false, 1 -> true
sismember memberlist member1

# redis 활용 : 좋아요 기능 구현
# 기존에 string 자료구조로 구현한 좋아요 기능은 누가 좋아요를 눌렀는지 구분을 할 수 없다.
# 특정 사용자가 좋아요를 누를 때 마다 무한히 좋아요 개수가 늘어나는 문제가 발생한다.
sadd likes:posting:1 member1
sadd likes:posting:1 member2
sadd likes:posting:1 member1
# 좋아요 개수
scard likes:posting:1
# 좋아요 눌렀는지 확인
sismember likes:posting:1 member1

### zset 자료구조 : sorted set
# add 하는 score 를 부여하고, score 를 기준으로 정렬
zadd memberlist 3 member1
zadd memberlist 4 member2
zadd memberlist 1 member3
zadd memberlist 2 member4

# zset 조회 : 기본적으로 score 기준 오름차순 정렬
zrange memberlist 0 -1

# 내림차순 정렬
zrevrange memberlist 0 -1

# zset 요소 삭제
zrem memberlist member4

# 특정 요소가 몇 번째 순서인지 출력 (오름차순 기준)
zrank memberlist member1

# redis zset 활용 : 최근 본 상품목록
# zset 을 활용해서 최근 시간 순(초 단위)으로 score 를 설정하여 정렬
zadd recent:products 151930 pineapple
zadd recent:products 152030 banana
zadd recent:products 152130 orange
zadd recent:products 152230 apple
# zset 도 set 이므로 같은 상품을 add 할 경우에 시간만 업데이트(덮어쓰기)되고 중복이 제거된다.
zadd recent:products 152330 apple
zrevrange recent:products 0 2
zrevrange recent:products 0 2 withscores # score 도 함께 출력

### Hash 자료구조 : map 형태의 자료구조, value 값이 key:value, key:value 형태로 저장
hset member:info:1 name hong email hong@naver.com age 30

# 특정 요소 조회
hget member:info:1 name
hget member:info:1 email

# 전체 요소 조회
hgetall member:info:1

# 특정 요소 값만 수정
hset member:info:1 name kim

# 특정 요소 값을 증가/감소
hincrby member:info:1 age 3
hincrby member:info:1 age -2

# redis 활용 : 빈번하게 변경되는 객체 값 캐싱
# json 형태를 문자열로 캐싱할 경우, 해당 문자열을 수정할 때 매번 파싱하여 통째로 변경해야 한다 <- 해시는 이러한 문제를 해결

### pub/sub 기능
# pub/sub 기능은 멀티 서버 환경에서 채팅, 알림 등의 서비스를 구현할 때 주로 사용된다.
# 터미널 2, 3 구독
subscribe test_channel
# 터미널 1 발행
publish test_channel "hello, this is a test message"
