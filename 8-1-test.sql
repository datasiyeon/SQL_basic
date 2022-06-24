DROP TABLE IF EXISTS app1_mst_users;
CREATE TABLE app1_mst_users (
    user_id varchar(255)
  , name    varchar(255)
  , email   varchar(255)
);

INSERT INTO app1_mst_users
VALUES
    ('U001', 'Sato'  , 'sato@example.com'  )
  , ('U002', 'Suzuki', 'suzuki@example.com')
;

DROP TABLE IF EXISTS app2_mst_users;
CREATE TABLE app2_mst_users (
    user_id varchar(255)
  , name    varchar(255)
  , phone   varchar(255)
);

INSERT INTO app2_mst_users
VALUES
    ('U001', 'Ito'   , '080-xxxx-xxxx')
  , ('U002', 'Tanaka', '070-xxxx-xxxx')
;

-- 코드 8-1 UNION ALL 구문을 사용해 테이블을 세로로 결합하는 쿼리
SELECT 'app1' AS app_name, user_id, name, email -- 결합 후의 데이터가 어떤 테이블의 데이터였는지 식별할 수 있게 app_name이라는 열 추가함.
FROM app1_mst_users
UNION ALL
SELECT 'app2' AS app_name, user_id, name, NULL AS email -- 결합할 때는 테이블의 컬럼이 완전히 일치해야 하므로, 디폴트 값을 준 모습.
FROM app2_mst_users
;