-- 파일 하나 전체 실행(F5 : 스크립트 전체 실행)
-- * 스크립트 : 한 줄 한 줄 실행하는 명령어 모음 


SELECT * FROM TABS;

-- 특정 테이블(표)의 정보 확인하기 

SELECT * FROM EMPLOYEE;

-- SELECT 문 

-- 특정 TABLE(표)의 정보를 조회하는 명령어 --> 정보를 조회한다. 
-- [사용 문법] 
-- SELECT 컬럼명 (, 컬럼명, 혹은 계산식, *: 모든컬럼) 
-- FROM 테이블명

-- EMPLOYEE 테이블의 모든 정보 조회하기 
-- 이렇게 SELECT로 나온 결과를 결과 집합(Result set)이라고 한다.
SELECT * FROM EMPLOYEE;

--EMPLOYEE 테이블에서 사원번호, 사원명, 이메일, 연락처를 조회하는 SELECT 구문을 만드시오.
--테이블 정보 확인
DESC EMPLOYEE;
SELECT EMP_ID, EMP_NAME, EMAIL, PHONE FROM EMPLOYEE;

-- 실습 1 --
-- 사장님은 자신의 회사에 어떤 사원들이 
-- 월급을 받고 있는지 알고 싶어한다. 
-- 이러한 사장님이 쉽게 자신의 직원 정보를 알 수 있도록 
--EMPLOYEE TABLE에서 모든 사원의 사원명, 이메일, 연락처, 직급코드, 부서코드, 
--를 조회하는 SELECT 구문을 작성하시오 

SELECT EMP_NAME, EMAIL, PHONE, JOB_CODE, dept_code FROM EMPLOYEE;

-- WHERE 절(구문) --
-- 테이블에서 조건을 만족하는 값을 가진 행(ROW)을 
-- 따로 선택하여 조회하는 명령어 
-- 만약 조건이 여러 개라면 
-- AND | OR 연산자 사용

-- [사용형식]
-- SELECT 컬럼명[, 컬럼명2 , ...]
-- FROM 테이블명
-- WHERE 조건 구문 [AND | OR 조건 구문]

-- ** 조건 구문의 예시 
-- 컬럼명 = '값' | 컬럼명 > '값' | 컬럼명 != '값'...

-- 부서 코드가 'D9' 인 부서의 직원 정보 조회하기 
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- 실습 2 -- 
-- EMPLOYEE 회사에서는 직급이 'J1'인 사원이 가장 힘이 세다.
-- 신입 사원이 입사했을 때, 이 분은 조심해라! 라고 알려줘야 할 
-- 사람은 누구인지, 직급 코드 조건을 달아 
-- 사원 번호, 사원명, 직급코드, 부서코드를 조회하시오 
SELECT EMP_ID,EMP_NAME, JOB_CODE, DEPT_CODE FROM EMPLOYEE WHERE JOB_CODE = 'J1';

-- 실습 3 --  (AND | OR 그것이 문제로다 !) --
-- 사원 중 당신의 물건을 자주 가져가는 사원이 있다. 
-- 이 사원의 이름은 '김해술'사원...당신은 부서코드가 
-- 'D5'라는 정보와 이 사원의 이름밖에 알지 못한다. 
-- 오늘도 당신의 도시락을 가져갔다 
-- 이 사원의 사원 번호와 사원명, 부서코드,
-- 전화번호, 이메일 주소를 조회하시오

SELECT EMP_ID, EMP_NAME, DEPT_CODE, PHONE, EMAIL FROM EMPLOYEE WHERE DEPT_CODE = 'D5' AND EMP_NAME = '김해술';

-- 실습 4 -- 
-- 회사 사정이 급격하게 안좋아졌다.
-- 대표 이사는 급여가 300만원 이상인 
-- 사원들 중 한 명을 쓱싹하려 한다. 
-- 이에 해당하는 사원 목록을 조회하기 위해 
-- 급여가 300만원 이상인 사원의 사번, 사원명, 이메일을 조회하시오 

SELECT EMP_ID AS 사원번호, EMP_NAME AS 사원명 , EMAIL AS 이메일  FROM EMPLOYEE WHERE SALARY >= 3000000;

-- AS(:Alias , 별칭)
-- 컬럼의 이름이 너무 길거나, 원하는 문자열로 머릿글을 표현하고 싶을 경우 
-- ResultSet(결과 집합)에 머릿글을 수정하고 싶을 경우 
-- 별칭을 사용한다. 

-- [사용 형식]
-- SELECT EMP_ID AS "사번", 
--         EMP_NAME "사원명",

-- * 만약에 별칭에 ()나 띄워쓰기 , 숫자로 시작하는 문자열이 아닐 경우 
-- AS "" 조차도 생략할 수 있다. 
-- EX) EMP_ID AS "사번" --> EMP_ID 사번 (O)

SELECT EMP_ID 사번, EMP_NAME 사원명, EMAIL 이메일 FROM EMPLOYEE;