CREATE TABLE access_log (
    stamp    varchar(255)
  , referrer text
  , url      text
);
INSERT INTO access_log 
VALUES
    ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001')
  , ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref'          )
  , ('2016-08-26 12:02:01', 'https://www.other.com/'                               , 'http://www.example.com/book/detail?id=002' )
;
SELECT
	stamp -- referrer의 호스트 이름 부분 추출하기
, substring(referrer from 'https?://([^/]*)') AS referrer_host -- substring 함수와 정규 표현식 사용하기
FROM access_log
;
SELECT
	stamp
	, url -- URL 경로 또는 GET 매개변수의 id 추출하기
	, substring(url from '//[^/]+([^?#]+)') AS path
	, substring(url from 'id=([^&]*)') AS id
FROM access_log
;
