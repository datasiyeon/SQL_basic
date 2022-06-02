DROP TABLE IF EXISTS popular_products;
CREATE TABLE popular_products (
    product_id varchar(255)
  , category   varchar(255)
  , score      numeric
);

INSERT INTO popular_products
VALUES
    ('A001', 'action', 94)
  , ('A002', 'action', 81)
  , ('A003', 'action', 78)
  , ('A004', 'action', 64)
  , ('D001', 'drama' , 90)
  , ('D002', 'drama' , 82)
  , ('D003', 'drama' , 78)
  , ('D004', 'drama' , 58)
;

-- 코드 7-4 윈도 함수의 ORDER BY 구문을 사용해 테이블 내부의 순서를 다루는 쿼리
SELECT
	product_id
	, score
	
	-- 점수 순서로 유일한 순위를 붙임
	, ROW_NUMBER() OVER(ORDER BY score DESC) AS row -- ROW_NUMBER 함수는 순위 번호를 붙임. -- ORDER BY 구문은 데이터의 순서를 정의
	-- 같은 순위를 허용해서 순위를 붙임
	, RANK() OVER(ORDER BY score DESC) AS rank -- RANK 함수는 같은 순위가 있을 때 순위 번호를 같게 붙임.(같은 순위의 레코드 뒤의 순위 번호를 건너뜀.)
	-- 같은 순위가 있을 때 같은 순위 다음에 있는 순위를 건너 뛰고 순위를 붙임
	, DENSE_RANK() OVER(ORDER BY score DESC) AS dense_rank -- DENSE_RANK 함수는 같은 순위가 있을 때 순위 번호를 같게 붙임. (같은 순위의 레코드 뒤의 순위 번호를 건너뛰지 않음.)
	
	-- 현재 행보다 앞에 있는 행의 값 추출하기
	, LAG(product_id) OVER(ORDER BY score DESC) AS lag1 -- LAG 함수는 현재 행을 기준으로 앞의 행의 값을 추출
	, LAG(product_id, 2) OVER(ORDER BY score DESC) AS lag2
	-- 현재 행보다 뒤에 있는 행의 값 추출하기
	, LEAD(product_id) OVER(ORDER BY score DESC) AS lead1 -- LEAD 함수는 현재 행을 기준으로 뒤의 행의 값을 추출
	, LEAD(product_id, 2) OVER(ORDER BY score DESC) AS lead2
FROM popular_products
ORDER BY row
;

-- 코드 7-5 ORDER BY 구문과 집약 함수를 조합해서 계산하는 쿼리
SELECT
	product_id
	, score
	
	-- 점수 순서로 유일한 순위를 붙임
	, ROW_NUMBER() OVER(ORDER BY score DESC) AS row
	-- 순위 상위부터의 누계 점수 계산하기
	, SUM(score)
		OVER(ORDER BY score DESC
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) -- ROWS 구문은 이후에 설명할 윈도 프레임 지정 구문임. 
	AS cum_score												-- UNBOUNDED PRECEDING 함수는 집계 시작 위치를 첫번째 row부터로 지정함.
	-- 현재 행과 앞 뒤의 행이 가진 값을 기반으로 평균 점수 계산하기		-- CURRENT ROW 함수는 현재 집계하고 있는 ROW의 위치까지로 지정함.
	, AVG(score)
		OVER(ORDER BY score DESC
			ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) -- [integer] PRECEDING 함수는 집계의 시작 위치를 integer에 지정한 숫자만큼 올라가서 시작함.
	AS local_avg										-- [integer] FOLLOWING 함수는 집계의 마지막 위치를 integer에 지정한 숫자만큼까지로 지정함.
	-- 순위가 높은 상품 ID 추출하기
	, FIRST_VALUE(product_id) -- FIRST_VALUE 윈도 함수는 윈도 내부의 가장 첫 번째 레코드를 추출해줌.
		OVER(ORDER BY score DESC
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
	AS first_value
	-- 순위가 낮은 상품 ID 추출하기
	, LAST_VALUE(product_id) -- LAST_VALUE 윈도 함수는 윈도 내부의 가장 마지막 레코드를 추출해줌.
		OVER(ORDER BY score DESC
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
	AS last_value
FROM popular_products
ORDER BY row
;

-- 코드 7-6 윈도 프레임 지정별 상품 ID를 집약하는 쿼리
SELECT
	product_id
	
	-- 점수 순서로 유일한 순위를 붙임
	, ROW_NUMBER() OVER(ORDER BY score DESC) AS row
	-- 가장 앞 순위부터 가장 뒷 순위까지의 범위를 대상으로 상품 ID 집약하기
	, array_agg(product_id)
		OVER(ORDER BY score DESC
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
	AS whole_agg
	-- 가장 앞 순위부터 현재 순위까지의 범위를 대상으로 상품 ID 집약하기
	, array_agg(product_id)
		OVER(ORDER BY score DESC
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
	AS cum_agg
	-- 순위 하나 앞과 하나 뒤까지의 범위를 대상으로 상품 ID 집약하기
	, array_agg(product_id)
		OVER(ORDER BY score DESC
			ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
	AS local_agg
FROM popular_products
WHERE category = 'action'
ORDER BY row
;

-- 코드 7-7 윈도 함수를 사용해 카테고리들의 순위를 계산하는 쿼리
SELECT
	category
	, product_id
	, score
	
	-- 카테고리별로 점수 순서로 정렬하고 유일한 순위를 붙임
	, ROW_NUMBER()
		OVER(PARTITION BY category ORDER BY score DESC) -- 매개변수에 PARTITION BY (컬럼이름)을 지정하면 해당 컬럼 값을 기반으로 그룹화하고 집약함수가 적용됨.
	AS row
	-- 카테고리별로 같은 순위를 허가하고 순위를 붙임
	, RANK()
		OVER(PARTITION BY category ORDER BY score DESC)
	AS rank
	-- 카테고리별로 같은 순위가 있을 때
	-- 같은 순위 다음에 있는 순위를 건너 뛰고 순위를 붙임
	, DENSE_RANK()
		OVER(PARTITION BY category ORDER BY score DESC)
	AS dense_rank
FROM popular_products
ORDER BY category, row
;

-- 코드 7-8 카테고리들의 순위 상위 2개까지의 상품을 추출하는 쿼리
SELECT *
FROM
	-- 서브 쿼리 내부에서 순위 계산하기
	(SELECT
		category
		, product_id
		, score
		-- 카테고리별로 점수 순서로 유일한 순위를 붙임
		, ROW_NUMBER()
			OVER(PARTITION BY category ORDER BY score DESC)
		AS rank
	FROM popular_products
	) AS popular_products_with_rank
-- 외부 쿼리에서 순위 활용해 압축하기
WHERE rank <= 2
ORDER BY category, rank
;

-- 코드 7-9 카테고리별 순위 최상위 상품을 추출하는 쿼리
-- DISTINCT 구문을 사용해 중복 제거하기
SELECT DISTINCT
	category
	-- 카테고리별로 순위 최상위 상품 ID 추출하기
	, FIRST_VALUE(product_id)
		OVER(PARTITION BY category ORDER BY score DESC
			ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
	AS product_id
FROM popular_products
;
	