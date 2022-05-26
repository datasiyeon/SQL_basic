DROP TABLE IF EXISTS quarterly_sales;
CREATE TABLE quarterly_sales (
    year integer
  , q1   integer
  , q2   integer
  , q3   integer
  , q4   integer
);

INSERT INTO quarterly_sales
VALUES
    (2015, 82000, 83000, 78000, 83000)
  , (2016, 85000, 85000, 80000, 81000)
  , (2017, 92000, 81000, NULL , NULL )
;
SELECT
	year
	, q1
	, q2
	-- Q1과 Q2의 매출 변화 평가하기
	, CASE
		WHEN q1 < q2 THEN '+'
		WHEN q1 = q2 THEN ' '
		ELSE '-'
	END AS judge_q1_q2
	-- Q1과 Q2의 매출액의 차이 계산하기
	, q2 - q1 AS diff_q2_q1
	-- Q1과 Q2의 매출 변화를 1, 0, -1로 표현하기
	, SIGN(q2 - q1) AS sign_q2_q1 -- SIGN 함수는 매개변수가 양수 -> 1, 0 -> 0, 음수 -> -1 을 리턴함.
FROM
	quarterly_sales
ORDER BY
	year
;
SELECT
	year
	-- Q1~Q4의 최대 매출 구하기
	, greatest(q1, q2, q3, q4) AS greatest_sales
	-- Q1~Q4의 최소 매출 구하기
	, least(q1, q2, q3, q4) AS least_sales
FROM
	quarterly_sales
ORDER BY
	year
;
SELECT
	year
	, (q1 + q2 + q3 + q4)/ 4 AS average
FROM
	quarterly_sales
ORDER BY
	year
; -- NULL 값 발생
SELECT
	year
	, (COALESCE(q1, 0) + COALESCE(q2, 0) + COALESCE(q3, 0) + COALESCE(q4, 0))/ 4 AS average
FROM
	quarterly_sales
ORDER BY
	year
; -- NULL 값 발생하지 않음. 그런데 2017년 q1, q2 매출만으로 평균을 구하려면 NULL이 아닌 컬럼의 수를 세서 나눠야 함.
SELECT
	year
	, (COALESCE(q1, 0) + COALESCE(q2, 0) + COALESCE(q3, 0) + COALESCE(q4, 0))
	/ (SIGN(COALESCE(q1, 0)) + SIGN(COALESCE(q2, 0)) + SIGN(COALESCE(q3, 0)) + SIGN(COALESCE(q4, 0))) AS average
FROM
	quarterly_sales
ORDER BY
	year
; -- NULL 값 발생하지 않고, 평균값도 잘 나옴.