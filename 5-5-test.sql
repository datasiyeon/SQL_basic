DROP TABLE IF EXISTS purchase_log_with_coupon;
CREATE TABLE purchase_log_with_coupon (
    purchase_id varchar(255)
  , amount      integer
  , coupon      integer
);

INSERT INTO purchase_log_with_coupon
VALUES
    ('10001', 3280, NULL)
  , ('10002', 4650,  500)
  , ('10003', 3870, NULL)
;
SELECT
	purchase_id
	, amount
	, coupon
	, amount - coupon AS discount_amount1
	, amount - COALESCE(coupon, 0) AS discount_amount2 -- COALESCE 함수로 NULL -> 0으로 대치
FROM
	purchase_log_with_coupon
;