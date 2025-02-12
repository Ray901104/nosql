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
