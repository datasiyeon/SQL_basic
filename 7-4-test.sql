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

DROP TABLE IF EXISTS purchase_log;
CREATE TABLE purchase_log (
    purchase_id integer
  , product_ids varchar(255)
);

INSERT INTOhttp://127.0.0.1:61587/datagrid/panel/2521437?is_query_tool=true&sgid=1&sid=1&server_type=pg&did=13754# purchase_log
VALUES
    (100001, 'A001,A002,A003')
  , (100002, 'D001,D002')
  , (100003, 'A001')
;

-- 코드 7-12 일련 번호를 가진 피벗 테이블을 사용해 행으로 변환하는 쿼리
SELECT
	q.year
   -- Q1에서 Q4까지의 레이블 이름 출력하기
   , CASE
   		WHEN p.idx = 1 THEN 'q1'
		WHEN p.idx = 2 THEN 'q2'
		WHEN p.idx = 3 THEN 'q3'
		WHEN p.idx = 4 THEN 'q4'
	END AS quarter
   -- Q1에서 Q4까지의 매출 출력하기
   , CASE
   		WHEN p.idx = 1 THEN q.q1
		WHEN p.idx = 2 THEN q.q2
		WHEN p.idx = 3 THEN q.q3
		WHEN p.idx = 4 THEN q.q4
	END AS sales
FROM
	quarterly_sales AS q
  CROSS JOIN
    -- 행으로 전개하고 싶은 열의 수만큼 순번 테이블 만들기
	(			SELECT 1 AS idx
	  UNION ALL SELECT 2 AS idx
	  UNION ALL SELECT 3 AS idx
	  UNION ALL SELECT 4 AS idx
	) AS p
;

-- 코드 7-13 테이블 함수를 사용해 배열을 행으로 전개하는 쿼리
SELECT unnest(ARRAY['A001','A002','A003']) AS product_id; -- unnest 함수는 매개 변수로 배열을 받고, 배열을 레코드 분할해서 리턴해줌.

-- 코드 7-14 테이블 함수를 사용해 쉼표로 구분된 문자열 데이터를 행으로 전개하는 쿼리
SELECT
	purchase_id
	, product_id
FROM
	purchase_log AS p
  -- string_to_array 함수로 문자열을 배열로 변환하고, unnest 함수로 테이블로 변환하기
  CROSS JOIN unnest(string_to_array(product_ids, ',')) AS product_id
  
-- 코드 7-15 PostgreSQL에서 쉼표로 구분된 데이터를 행으로 전개하는 쿼리
SELECT
	purchase_id
	-- 쉼표로 구분된 문자열을 한 번에 행으로 전개하기
	, regexp_split_to_table(product_ids, ',') AS product_id -- regexp_split_to_table 함수는 문자열을 구분자로 분할해서 테이블화함.
FROM purchase_log;

-- 코드 7-16 일련 번호를 가진 피벗 테이블을 만드는 쿼리
SELECT *
FROM (
			SELECT 1 AS idx
  UNION ALL SELECT 2 AS idx
  UNION ALL SELECT 3 AS idx
) AS pivot
;

-- 코드 7-17 split_part 함수의 사용 예
SELECT
	split_part('A001,A002,A003', ',', 1) AS part_1 -- split_part 함수는 문자열을 쉼표 등의 구분자(separator)로 분할해 n 번째 요소를 추출함.
	,split_part('A001,A002,A003', ',', 2) AS part_2
	,split_part('A001,A002,A003', ',', 3) AS part_3
;

-- 코드 7-18 문자 수의 차이를 사용해 상품 수를 계산하는 쿼리
SELECT
	purchase_id
	, product_ids
	-- 상품 ID 문자열을 기반으로 쉼표를 제거하고,
	-- 문자 수의 차이를 계산해서 상품 수 구하기
	, 1 + char_length(product_ids) 
		- char_length(replace(product_ids, ',', '')) -- replace 함수는 문자열을 한 개 치환함.
	AS product_num
FROM
	purchase_log
;
	
-- 코드 7-19 피벗 테이블을 사용해 문자열을 행으로 전개하는 쿼리
SELECT
	l.purchase_id
	, l.product_ids
	-- 상품 수만큼 순번 붙이기
	, p.idx
	-- 문자열을 쉼표로 구분해서 분할하고, idx번째 요소 추출하기
	, split_part(l.product_ids, ',', p.idx) AS product_id
FROM
	purchase_log AS l
  JOIN
  	(			SELECT 1 AS idx
	  UNION ALL SELECT 2 AS idx
	  UNION ALL SELECT 3 AS idx
	) AS p
	-- 피벗 테이블의 id가 상품 수 이하의 경우 결합하기
	ON p.idx <=
		(1+ char_length(l.product_ids)
		  - char_length(replace(l.product_ids, ',', '')))

;