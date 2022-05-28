DROP TABLE IF EXISTS location_1d;
CREATE TABLE location_1d (
    x1 integer
  , x2 integer
);

INSERT INTO location_1d
VALUES
    ( 5 , 10)
  , (10 ,  5)
  , (-2 ,  4)
  , ( 3 ,  3)
  , ( 0 ,  1)
;

DROP TABLE IF EXISTS location_2d;
CREATE TABLE location_2d (
    x1 integer
  , y1 integer
  , x2 integer
  , y2 integer
);

INSERT INTO location_2d
VALUES
    (0, 0, 2, 2)
  , (3, 5, 1, 2)
  , (5, 3, 2, 1)
;
SELECT
	abs(x1 - x2) AS abs -- ABS 함수는 절대값 계산할 때
	, sqrt(power(x1 - x2, 2)) AS rms -- POWER 함수는 제곱을 할 때, SQRT 함수는 제곱근을 구할 때
FROM location_1d
;
SELECT
	point(x1, y1) <-> point(x2, y2) AS dist -- POINT 자료형 데이터로 변환하고, 거리 연산자 <->를 사용하면 됨.
	-- sqrt(power(x1 - x2, 2) + power(y1 - y2, 2)) AS dist
FROM location_2d
;