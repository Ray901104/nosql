# redis 는 0~15번까지의 database 로 구성
select 14

# 데이터베이스 내 모든 키 조회
keys *

# 일반적인 string 구조
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
