DROP TABLE IF EXISTS advertising_stats;
CREATE TABLE advertising_stats (
    dt          varchar(255)
  , ad_id       varchar(255)
  , impressions integer
  , clicks      integer
);

INSERT INTO advertising_stats
VALUES
    ('2017-04-01', '001', 100000,  3000)
  , ('2017-04-01', '002', 120000,  1200)
  , ('2017-04-01', '003', 500000, 10000)
  , ('2017-04-02', '001',      0,     0)
  , ('2017-04-02', '002', 130000,  1400)
  , ('2017-04-02', '003', 620000, 15000)
;
SELECT
	dt
	, ad_id
	, CAST(clicks AS double precision) / impressions AS ctr
	-- 실수를 상수로 앞에 두고 계산하면 암묵적으로 자료형 변환이 일어남
	, 100.0*clicks / impressions AS ctr_as_percent
FROM
	advertising_stats
WHERE
	dt = '2017-04-01'
ORDER BY
	dt, ad_id
;
SELECT
	dt
	, ad_id
	-- CASE 식으로 분모가 0일 경우를 분기해서, 0으로 나누지 않게 만드는 방법
	, CASE
		WHEN impressions > 0 THEN 100.0*clicks / impressions
	END AS ctr_as_percent_by_case
	
	-- 분모가 0이라면 NULL로 변환해서, 0으로 나누지 않게 만드는 방법 -> NULLIF 함수
	, 100.0*clicks / NULLIF(impressions, 0) AS ctr_as_percent_by_null
FROM
	advertising_stats
ORDER BY
	dt, ad_id
;