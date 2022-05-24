SELECT
	CURRENT_DATE AS dt
	, CURRENT_TIMESTAMP AS stamp
;
-- 문자열을 날짜/타임스탬프로 변환하기
SELECT
	CAST('2016-01-30' AS date) AS dt  -- CAST는 TEXT로 타입 변환
	, CAST('2016-01-30 12:00:00' AS timestamp) AS stamp
;
SELECT
	stamp
	, EXTRACT(YEAR FROM stamp) AS year
	, EXTRACT(MONTH FROM stamp) AS month
	, EXTRACT(DAY FROM stamp) AS day
	, EXTRACT(HOUR FROM stamp) AS hour
FROM
	(SELECT CAST('2016-01-30 12:00:00' AS timestamp) AS stamp) AS t
;
SELECT
	stamp
	, substring(stamp, 1, 4) AS year
	, substring(stamp, 6, 2) AS month
	, substring(stamp, 9, 2) AS day
	, substring(stamp, 12, 2) AS hour
	, substring(stamp, 1, 7) AS year_month -- 연과 월을 함께 추출하기
FROM
	(SELECT CAST('2016-01-30 12:00:00' AS text) AS stamp) AS t 
;