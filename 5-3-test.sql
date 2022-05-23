SELECT
	stamp
	, url -- 경로를 슬래시로 잘라 배열로 분할하기 -- 경로가 반드시 슬래시로 시작하므로 2번째 요소가 마지막 계층
	, split_part(substring(url from '//[^/]+([^?#]+)'), '/', 2) AS path1
	, split_part(substring(url from '//[^/]+([^?#]+)'), '/', 3) AS path2
FROM access_log
;
	