-- Active: 1693196572867@@192.168.10.10@3306@mydb
SHOW DATABASES;

USE mydb;

SHOW TABLES;

CREATE TABLE my_table (
    id INT PRIMARY KEY,
    이름 VARCHAR(20) NOT NULL
);

DESC my_table;

ALTER TABLE my_table ADD 주소 VARCHAR(20) DEFAULT('a') NOT NULL;


CREATE TABLE student (
    학번 INT PRIMARY KEY,
    이름 VARCHAR(10) NOT NULL,
    나이 TINYINT,
    성별 CHAR(1) CHECK(성별 IN ('남', '여'))
);
INSERT INTO student VALUES('20230101', '홍길동', '22', '남');
INSERT INTO student(학번, 나이, 이름, 성별)
     VALUES(20230102, 23, '박주학', '남');
INSERT INTO student VALUES('20230201', '황철혁', '21', '남');
SELECT * FROM student;
DESC student;

DROP TABLE student;


USE employees;
SELECT * FROM employees;

SELECT emp_no, salary, salary / 12 as 월급
  FROM salaries
 WHERE emp_no = 10001;


SELECT CONCAT(SUBSTRING(birth_date, 1, 4), '년 ',
       SUBSTRING(birth_date, 6, 2), '월 ',
       SUBSTRING(birth_date, 9, 2), '일') AS 생년월일
  FROM employees
 WHERE emp_no <= 10005;


# TRUE = 1, FALSE = 0
# 논리 연산 AND(곱 연산)
SELECT TRUE AND TRUE
     , TRUE AND FALSE
     , FALSE AND TRUE
     , FALSE AND FALSE;
SELECT 1 * 1
     , 1 * 0
     , 0 * 1
     , 0 * 0;

# 논리 연산 OR(합 연산)
SELECT TRUE OR TRUE
     , TRUE OR FALSE
     , FALSE OR TRUE
     , FALSE OR FALSE;
SELECT 1 + 1
     , 1 + 0
     , 0 + 1
     , 0 + 0;


-- 2023년 08월 29일 PM 01시 05분 30초
SELECT DATE_FORMAT(NOW(), '%Y년 %m월 %d일 %p %h시 %i분 %s초');
-- 2023.08.29 13:05:30
SELECT DATE_FORMAT(NOW(), '%Y.%m.%d %H:%i:%s');
-- 08/29/2023
SELECT DATE_FORMAT(NOW(), '%m/%d/%Y');


SELECT EXTRACT(YEAR FROM NOW());
SELECT EXTRACT(MONTH FROM NOW());
SELECT EXTRACT(DAY FROM NOW());
SELECT EXTRACT(HOUR FROM NOW());
SELECT EXTRACT(MINUTE FROM NOW());
SELECT EXTRACT(SECOND FROM NOW());
SELECT EXTRACT(HOUR_SECOND FROM NOW());
SELECT TIME_FORMAT(EXTRACT(HOUR_SECOND FROM NOW()), '%H:%i:%s');

SELECT CAST('10' AS UNSIGNED), '10';
SELECT CAST('20230101' AS DATE), CAST(20230101 AS DATE);
SELECT CAST('2023-01-01' AS DATE), CAST('2023/01/01' AS DATE)
     , CAST('2023.01.01' AS DATE);



SELECT STR_TO_DATE('1990-01-01', '%Y-%m-%d');

# 고용일이 1990년도에 해당하는 사원 조회
SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , hire_date
  FROM employees.employees
 WHERE hire_date BETWEEN STR_TO_DATE('1990-01-01', '%Y-%m-%d')
    AND STR_TO_DATE('1990-12-31', '%Y-%m-%d');

SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , hire_date
  FROM employees.employees
 WHERE EXTRACT(YEAR FROM hire_date) = 1990;

SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , hire_date
  FROM employees.employees
 WHERE DATE_FORMAT(hire_date, '%Y') = '1990';

SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , hire_date
  FROM employees.employees
 WHERE SUBSTRING(hire_date, 1, 4) = '1990';

# 고용일이 모든 년도에서 4분기에 해당하는 사원 조회
SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , hire_date
  FROM employees.employees
 WHERE EXTRACT(MONTH FROM hire_date) IN (12, 11, 10);

SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , hire_date
  FROM employees.employees
 WHERE EXTRACT(MONTH FROM hire_date) / 3 > 3;

SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , hire_date
  FROM employees.employees
 WHERE QUARTER(hire_date) = 4;

# 나이가 60대 이상인 사원 조회
SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , birth_date
     , FLOOR(DATEDIFF(NOW(), birth_date) / 365)
  FROM employees.employees
 WHERE ADDDATE(birth_date, INTERVAL 60 YEAR) <= NOW();

SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , birth_date
     , FLOOR(DATEDIFF(NOW(), birth_date) / 365)
  FROM employees.employees
 WHERE birth_date <= ADDDATE(NOW(), INTERVAL -60 YEAR);

# 근속년수가 35년 이상인 사원 조회
SELECT emp_no
     , CONCAT(first_name, ' ', last_name) AS emp_name
     , hire_date
     , FLOOR(DATEDIFF(NOW(), hire_date) / 365)
  FROM employees.employees
 WHERE hire_date <= ADDDATE(NOW(), INTERVAL -35 YEAR);


SELECT emp_no
     , COUNT(*)
     , SUM(salary)
  FROM employees.salaries
 WHERE emp_no IN (10001, 10002)
 GROUP BY emp_no;

SELECT gender
     , COUNT(*)
  FROM employees.employees
 GROUP BY gender;

SELECT emp_no
     , DATE_FORMAT(birth_date, '%Y년 %m월 %d일') AS 생년월일
     , first_name
     , last_name
     , gender
     , hire_date
  FROM employees.employees
 WHERE emp_no <= 10005
 ORDER BY gender, 2 DESC;



-- 가장 늙꼰 사원 구하기
SELECT * FROM employees.employees
 WHERE birth_date = (SELECT MIN(birth_date) FROM employees.employees);
-- 가장 젊꼰 사원 구하기
SELECT * FROM employees.employees
 WHERE birth_date = (SELECT MAX(birth_date) FROM employees.employees);
-- 회사에 뼈를 묻은 사람 구하기
-- 1986년생 사원 수 구하기
SELECT YEAR(birth_date) AS 년생
     , COUNT(*)
  FROM employees.employees
 -- WHERE YEAR(birth_date) = 1986
 GROUP BY YEAR(birth_date)
 ORDER BY 1;
-- 연봉이 가장 높은 사원 구하기
-- 연봉이 가장 낮은 사원 구하기
-- 분기별 고용인원 수 구하기 -> 이 회사는 몇 분기에 사원을 많이 고용하는지 파악
SELECT QUARTER(hire_date) AS 분기
     , COUNT(*)
  FROM employees.employees
 GROUP BY QUARTER(hire_date)
 ORDER BY 1;
-- 년도별 고용인원 수 구하기 -> 이 회사가 가장 많이 고용한 년도는 언제인지 파악
SELECT YEAR(hire_date) AS 분기
     , COUNT(*)
  FROM employees.employees
 GROUP BY YEAR(hire_date) WITH ROLLUP
 ORDER BY 분기 IS NULL, 분기;

UPDATE employees.employees
   SET birth_date = ADDDATE(birth_date, INTERVAL -25 YEAR)
     , hire_date = ADDDATE(hire_date, INTERVAL -25 YEAR);



SELECT e.emp_no
     , d.dept_no
     , CONCAT(e.first_name, ' ', e.last_name) emp_name
     , CASE WHEN e.gender = 'M' THEN '남자'
            WHEN e.gender = 'F' THEN '여자'
            ELSE '???'
       END gender
  FROM employees e
 INNER JOIN dept_emp d
 USING(emp_no)
 WHERE e.emp_no <= 10005;


SELECT e.emp_no
     , CASE WHEN m.dept_no IS NOT NULL THEN '부서장'
            ELSE '부서원'
       END 구분
     , CONCAT(e.first_name, ' ', e.last_name) emp_name
  FROM employees e
  LEFT OUTER JOIN dept_manager m
    ON e.emp_no = m.emp_no;

SELECT *
  FROM employees e
 CROSS JOIN salaries s;

USE employees;
--사원(employees) 정보를 출력할 때 사원들의 부서(dept_emp) 정보까지 출력되도록 합니다.
SELECT e.emp_no as 사번
     , d.dept_no as 부서코드
     , CONCAT(e.first_name, ' ', e.last_name) as 이름
     , DATE_FORMAT(e.birth_date, '%Y년 %m월 %d일') as 생년월일
     , DATE_FORMAT(e.hire_date, '%Y년 %m월 %d일') as 고용일
     , DATE_FORMAT(d.from_date, '%Y년 %m월 %d일') as 부서소속일
  FROM employees e
 INNER JOIN dept_emp d
    ON e.emp_no = d.emp_no
 WHERE YEAR(d.to_date) = 9999
 ORDER BY 1;

--사원(employees) 정보를 출력할 때 사원들의 직무(titles) 정보까지 출력되도록 합니다.
SELECT e.emp_no as 사번
     , d.dept_no as 부서코드
     , t.title as 직무
     , CONCAT(e.first_name, ' ', e.last_name) as 이름
     , DATE_FORMAT(e.birth_date, '%Y년 %m월 %d일') as 생년월일
     , DATE_FORMAT(e.hire_date, '%Y년 %m월 %d일') as 고용일
     , DATE_FORMAT(d.from_date, '%Y년 %m월 %d일') as 부서소속일
     , DATE_FORMAT(t.from_date, '%Y년 %m월 %d일') as 직무시작일
  FROM employees e
 INNER JOIN dept_emp d
    ON e.emp_no = d.emp_no
 INNER JOIN titles t
    ON e.emp_no = t.emp_no
 WHERE YEAR(d.to_date) = 9999
   AND YEAR(t.to_date) = 9999
 ORDER BY 1;

--사원에서 부서(dept_emp) 정보를 출력할 때 부서명(departments) 정보까지 출력되도록 합니다.
SELECT e.emp_no as 사번
     , d.dept_no as 부서코드
     , dpt.dept_name as 부서명
     , t.title as 직무
     , CONCAT(e.first_name, ' ', e.last_name) as 이름
     , DATE_FORMAT(e.birth_date, '%Y년 %m월 %d일') as 생년월일
     , DATE_FORMAT(e.hire_date, '%Y년 %m월 %d일') as 고용일
     , DATE_FORMAT(d.from_date, '%Y년 %m월 %d일') as 부서소속일
     , DATE_FORMAT(t.from_date, '%Y년 %m월 %d일') as 직무시작일
  FROM employees e
 INNER JOIN dept_emp d
    ON e.emp_no = d.emp_no
 INNER JOIN departments dpt
    ON d.dept_no = dpt.dept_no
 INNER JOIN titles t
    ON e.emp_no = t.emp_no
 WHERE YEAR(d.to_date) = 9999
   AND YEAR(t.to_date) = 9999
 ORDER BY 1;

--사원(employees) 정보를 출력할 때 현재연봉(salaries) 정보까지 출력되도록 합니다.
SELECT e.emp_no as 사번
     , d.dept_no as 부서코드
     , dpt.dept_name as 부서명
     , t.title as 직무
     , CONCAT('$ ', FORMAT(s.salary, 0)) as "연봉(달러)"
     , CONCAT(FORMAT(s.salary * 1300, 0), ' 원') as "연봉(원화)"
     , CONCAT(e.first_name, ' ', e.last_name) as 이름
     , DATE_FORMAT(e.birth_date, '%Y년 %m월 %d일') as 생년월일
     , DATE_FORMAT(e.hire_date, '%Y년 %m월 %d일') as 고용일
     , DATE_FORMAT(d.from_date, '%Y년 %m월 %d일') as 부서소속일
     , DATE_FORMAT(t.from_date, '%Y년 %m월 %d일') as 직무시작일
  FROM employees e
 INNER JOIN dept_emp d
    ON e.emp_no = d.emp_no
 INNER JOIN departments dpt
    ON d.dept_no = dpt.dept_no
 INNER JOIN titles t
    ON e.emp_no = t.emp_no
 INNER JOIN salaries s
    ON e.emp_no = s.emp_no
 WHERE YEAR(d.to_date) = 9999
   AND YEAR(t.to_date) = 9999
   AND YEAR(s.to_date) = 9999
 ORDER BY 1;

--부서별 사원수를 파악하기 위한 정보를 출력합니다.
SELECT d.dept_no as 부서코드
     , dpt.dept_name as 부서명
     , COUNT(e.emp_no) as 사원수
  FROM employees e
 INNER JOIN dept_emp d
    ON e.emp_no = d.emp_no
 INNER JOIN departments dpt
    ON d.dept_no = dpt.dept_no
 WHERE YEAR(d.to_date) = 9999
 GROUP BY d.dept_no, dpt.dept_name
UNION
SELECT NULL, NULL
     , COUNT(e.emp_no) as 사원수
  FROM employees e
 INNER JOIN dept_emp d
    ON e.emp_no = d.emp_no
 INNER JOIN departments dpt
    ON d.dept_no = dpt.dept_no
 WHERE YEAR(d.to_date) = 9999;

--직무별 사원수를 파악하기 위한 정보를 출력합니다.
SELECT t.title as 직무명
     , COUNT(e.emp_no) as 사원수
  FROM employees e
 INNER JOIN titles t
    ON e.emp_no = t.emp_no
 WHERE YEAR(t.to_date) = 9999
 GROUP BY t.title
UNION
SELECT '총 계'
     , COUNT(e.emp_no) as 사원수
  FROM employees e
 INNER JOIN titles t
    ON e.emp_no = t.emp_no
 WHERE YEAR(t.to_date) = 9999;

--부서별 직책정보 및 각 직책에 대한 인원수를 파악하기 위한 정보를 출력합니다.
SELECT *
  FROM (SELECT d.dept_no as 부서코드
             , dpt.dept_name as 부서명
             , t.title as 직무명
             , COUNT(e.emp_no) as 사원수
          FROM employees e
         INNER JOIN dept_emp d
            ON e.emp_no = d.emp_no
         INNER JOIN departments dpt
            ON d.dept_no = dpt.dept_no
         INNER JOIN titles t
            ON e.emp_no = t.emp_no
         WHERE YEAR(d.to_date) = 9999
           AND YEAR(t.to_date) = 9999
         GROUP BY d.dept_no, dpt.dept_name, t.title
        UNION
        SELECT d.dept_no as 부서코드
             , dpt.dept_name as 부서명
             , NULL
             , COUNT(e.emp_no) as 사원수
          FROM employees e
         INNER JOIN dept_emp d
            ON e.emp_no = d.emp_no
         INNER JOIN departments dpt
            ON d.dept_no = dpt.dept_no
         INNER JOIN titles t
            ON e.emp_no = t.emp_no
         WHERE YEAR(d.to_date) = 9999
           AND YEAR(t.to_date) = 9999
         GROUP BY d.dept_no, dpt.dept_name
        UNION
        SELECT NULL, NULL, NULL
             , COUNT(e.emp_no) as 사원수
          FROM employees e
         INNER JOIN dept_emp d
            ON e.emp_no = d.emp_no
         INNER JOIN departments dpt
            ON d.dept_no = dpt.dept_no
         INNER JOIN titles t
            ON e.emp_no = t.emp_no
         WHERE YEAR(d.to_date) = 9999
           AND YEAR(t.to_date) = 9999) as 부서직무별T
 ORDER BY 부서코드 IS NULL, 부서코드, 직무명 IS NULL, 직무명;
