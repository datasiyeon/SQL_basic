-- 코드 6-17 inet 자료형을 사용한 IP 주소 비교 쿼리
SELECT
	CAST('127.0.0.1' AS inet) < CAST('127.0.0.2' AS inet) AS lt
	, CAST('127.0.0.1' AS inet) > CAST('192.168.0.1' AS inet) AS gt
;

-- 코드 6-18 inet 자료형을 사용해 IP 주소 범위를 다루는 쿼리
SELECT CAST('127.0.0.1' AS inet) << CAST('127.0.0.0/8' AS inet) AS is_contained;

-- 코드 6-19 IP 주소에서 4개의 10진수 부분을 추출하는 쿼리
SELECT
	ip
	, CAST(split_part(ip, '.', 1) AS integer) AS ip_part_1
	, CAST(split_part(ip, '.', 2) AS integer) AS ip_part_2
	, CAST(split_part(ip, '.', 3) AS integer) AS ip_part_3
	, CAST(split_part(ip, '.', 4) AS integer) AS ip_part_4
FROM
	(SELECT CAST('192.168.0.1' AS text) AS ip) AS t
;

-- 코드 6-20 IP 주소를 정수 자료형 표기로 변환하는 쿼리
SELECT
	ip
	, CAST(split_part(ip, '.', 1) AS integer) * 2^24
	+ CAST(split_part(ip, '.', 2) AS integer) * 2^16
	+ CAST(split_part(ip, '.', 3) AS integer) * 2^8
	+ CAST(split_part(ip, '.', 4) AS integer) * 2^0
	AS ip_integer
FROM
	(SELECT CAST('192.168.0.1' AS text) AS ip) AS t
;

-- 코드 6-21 IP 주소를 0으로 메운 문자열로 변환하는 쿼리
SELECT
	ip
	, lpad(split_part(ip, '.', 1), 3, '0')
	|| lpad(split_part(ip, '.', 2), 3, '0')
	|| lpad(split_part(ip, '.', 3), 3, '0')
	|| lpad(split_part(ip, '.', 4), 3, '0')
	AS ip_padding
FROM
	(SELECT CAST('192.168.0.1' AS text) AS ip) AS t
;