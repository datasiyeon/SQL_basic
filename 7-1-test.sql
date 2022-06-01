DROP TABLE IF EXISTS review;
CREATE TABLE review (
    user_id    varchar(255)
  , product_id varchar(255)
  , score      numeric
);

INSERT INTO review
VALUES
    ('U001', 'A001', 4.0)
  , ('U001', 'A002', 5.0)
  , ('U001', 'A003', 5.0)
  , ('U002', 'A001', 3.0)
  , ('U002', 'A002', 3.0)
  , ('U002', 'A003', 4.0)
  , ('U003', 'A001', 5.0)
  , ('U003', 'A002', 4.0)
  , ('U003', 'A003', 4.0)
;

-- 코드 7-1 집약 함수를 사용해서 테이블 전체의 특징량을 계산하는 쿼리
SELECT
	COUNT(*) AS total_count
	, COUNT(DISTINCT user_id) AS user_count -- DISTINCT 구문은 중복을 제외하고 수를 세어줌.
	, COUNT(DISTINCT product_id) AS product_count
	, SUM(score) AS sum -- SUM 함수는 합계
	, AVG(score) AS avg -- AVG 함수는 평균
	, MAX(score) AS max -- MAX 함수는 최댓값
	, MIN(score) AS min -- MIN 함수는 최솟값
FROM
	review
;

-- 코드 7-2 사용자 기반으로 데이터를 분할하고 집약 함수를 적용하는 쿼리
SELECT
	user_id
	, COUNT(*) AS total_count
	, COUNT(DISTINCT product_id) AS product_count
	, SUM(score) AS sum
	, AVG(score) AS avg 
	, MAX(score) AS max 
	, MIN(score) AS min
FROM
	review
GROUP BY
	user_id
;

-- 코드 7-3 윈도 함수를 사용해 집약 함수의 결과와 원래 값을 동시에 다루는 쿼리
SELECT
	user_id
	, product_id
	-- 개별 리뷰 점수
	, score
	-- 전체 평균 리뷰 점수
	, AVG(score) OVER() AS avg_score -- OVER 구문은 세부 사항을 추가
	-- 사용자의 평균 리뷰 점수
	, AVG(score) OVER(PARTITION BY user_id) AS user_avg_score -- PARTITION BY <컬럼 이름>을 지정하면 해당 컬럼 값을 기반으로 그룹화하고 집약 함수를 적용
	-- 개별 립뷰 점수와 사용자 평균 리뷰 점수의 차이
	, score - AVG(score) OVER(PARTITION BY user_id) AS user_avg_score_diff
FROM
	review
;