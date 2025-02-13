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
