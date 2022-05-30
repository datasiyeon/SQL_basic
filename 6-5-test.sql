DROP TABLE IF EXISTS mst_users_with_dates;
CREATE TABLE mst_users_with_dates (
    user_id        varchar(255)
  , register_stamp varchar(255)
  , birth_date     varchar(255)
);

INSERT INTO mst_users_with_dates
VALUES
    ('U001', '2016-02-28 10:00:00', '2000-02-29')
  , ('U002', '2016-02-29 10:00:00', '2000-02-29')
  , ('U003', '2016-03-01 10:00:00', '2000-02-29')
;

-- 코드 6-11 미래 또는 과거의 날짜/시간을 계산하는 쿼리
SELECT
	user_id
	, register_stamp::timestamp AS register_stamp
	, register_stamp::timestamp + '1 hour'::interval AS after_1_hour
	, register_stamp::timestamp - '30 minutes'::interval AS before_30_minutes
	
	, register_stamp::date AS register_date
	, (register_stamp::date + '1 day'::interval)::date AS after_1_day
	, (register_stamp::date - '1 month'::interval)::date AS before_1_month
FROM mst_users_with_dates
;

-- 코드 6-12 두 날짜의 차이를 계산하는 쿼리
SELECT
	user_id
	, CURRENT_DATE AS today
	, register_stamp::date AS register_date
	, CURRENT_DATE - register_stamp::date AS diff_days
FROM mst_users_with_dates
;

-- 코드 6-13 age 함수를 사용해 나이를 계산하는 쿼리
SELECT
	user_id
	, CURRENT_DATE AS today
	, register_stamp::date AS register_date
	, birth_date::date AS birth_date
	, EXTRACT(YEAR FROM age(birth_date::date)) AS current_age -- EXTRACT 함수는 연도(YEAR) 부분만 추출
	, EXTRACT(YEAR FROM age(register_stamp::date, birth_date::date)) AS register_age
FROM mst_users_with_dates
;

-- 코드 6-15 날짜를 정수로 표현해서 나이를 계산하는 함수
	-- 생일이 2000년 2월 29일인 사람의 2016년 2월 28일 시점의 나이 계산하기
SELECT floor((20160228 - 20000229) / 10000) AS age;

-- 코드 6-16 등록 시점과 현재 시점의 나이를 문자열로 계산하는 쿼리
SELECT
	user_id
	, substring(register_stamp, 1, 10) AS register_date -- substring 함수는 주어진 문자열에서 원하는 부분 문자열 추출
	, birth_date
	-- 등록 시점의 나이 계산하기
	, floor( -- floor 함수는 소수점 첫째 자리에서 버림함.
		( CAST(replace(substring(register_stamp, 1, 10), '-', '')AS integer) -- CAST 함수는 타입 변환
		 - CAST(replace(birth_date, '-', '') AS integer) -- replace 함수는 문자열 한 개 치환
		) / 10000
	) AS register_age
	-- 현재 시점의 나이 계산하기
	, floor(
		( CAST(replace(CAST(CURRENT_DATE AS text), '-', '')AS integer) -- CURRENT_DATE 함수는 오늘 날짜 추출.
		 - CAST(replace(birth_date, '-', '') AS integer)
		) / 10000
	) AS current_age
FROM mst_users_with_dates
;