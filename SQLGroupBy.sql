-- Day3 --

-- 날짜 관련 함수 이어서 ... --

-- LAST_DAY() : 해당 월의 마지막 일자 
-- 각 사원들이 입사한 월의 마지막 일자 계산하기 
SELECT HIRE_DATE 입사일,
       LAST_DAY(HIRE_DATE) "입사월의 마지막일자"
FROM EMPLOYEE;

-- EXTRACT : 추출하다
--      지정한 날짜로부터 연, 월, 일 정보를 각각 추출하는 함수 
SELECT EXTRACT(YEAR FROM HIRE_DATE) 연도,
       EXTRACT(MONTH FROM HIRE_DATE) 월,
       EXTRACT(DAY FROM HIRE_DATE) 일
FROM EMPLOYEE;

-- 실습 1 --
-- 현재 회사에서 근속 년수가 20년 이상인 사원들의
-- 목록을 출력하기 위한
-- 사번 , 사원명, 부서코드, 입사일 정보를 조회하시오 
-- HINT1: MONTHS_BETWEEN() OR ADD_MONTHS()

--내 풀이)
SELECT * FROM EMPLOYEE WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12 > 20; 

-- 1)
SELECT EMP_ID 사번,
       EMP_NAME 사원명,
       DEPT_CODE 부서코드,
       HIRE_DATE 입사일
FROM EMPLOYEE
WHERE ADD_MONTHS(HIRE_DATE, 240) <= SYSDATE AND ENT_YN = 'N';

-- 2)
SELECT MONTHS_BETWEEN(SYSDATE,HIRE_DATE) "개월 수",
       ADD_MONTHS(HIRE_DATE, 12*20)  "20년의 개월 수"
FROM EMPLOYEE
WHERE MONTHS_BETWEEN(SYSDATE, HIRE_DATE) >= 240;

-- 형변환 함수 --
-- 날짜나 숫자 데이터를 문자로 바꾸거나, 문자 데이터를 날짜나 숫자로 바꾸는 함수들
-- TO_NUMBER(), TO_CHAR(), TO_DATE(), 

-- TO_CHAR()
-- 숫자 형식 변환 
-- 9 : 숫자로 일정 칸을 채우되 남은 칸은 표시하지 않음 
-- 0 : 숫자로 일정 칸을 채우되 남은 칸은 0으로 표시함
-- L : 숫자로 표현 시 통화기호(￦ 표시)를 붙여 표현함 
-- 오!!!!!!!!!!!!

SELECT TO_CHAR(SALARY, '999,999,999'),
       TO_CHAR(SALARY, '000,000,000'),
       TO_CHAR(SALARY, '999,999,999L'),
       TO_CHAR(SALARY, 'L999,999,999'),
       TO_CHAR(SALARY,'999,999')  -- 만약에 표현하려는 숫자를 초과할 경우 , 값을 보여주지 않는다 (ERROR!!).
FROM EMPLOYEE;

-- TO_NUMBER()
-- 데이터 베이스에서는 숫자로만 이루어진 문자를 
-- 자동으로 TO_NUMBER()를 통해 숫자로 바꿔준다. 
-- 숫자는 문자 데이터 연산을 처리할 수 없다. 

SELECT '123' + '456' -- 123456(X) 자동 형변환되서 123 + 456을 처리함
FROM DUAL;

--ORA-01722: invalid number / 계산하려는데 숫자가 아니다.
SELECT '123' + '456' + 'ABC' FROM DUAL;

-- TO_DATE()
-- ALT + '     쓰면 대소문자 바뀜
SELECT TO_DATE(20200908, 'YYYYMMDD') "날짜1",
       TO_DATE('2020/09/08', 'YYYY/MM/DD') "날짜2"
FROM DUAL;

-- YY               /      RR
-- 현재 년도 기준이냐, 현재 세기 기준이냐.
SELECT TO_CHAR(TO_DATE('200908', 'YYMMDD'), 'YYYY') "결과1",
       TO_CHAR(TO_DATE('200908', 'RRMMDD'), 'RRRR') "결과2",
       TO_CHAR(TO_DATE('800908', 'YYMMDD'), 'YYYY') "결과3", -- YYYY는 무조건 앞에 20년도를 붙임
       TO_CHAR(TO_DATE('800908', 'RRMMDD'), 'RRRR') "결과4"  -- RR은 50년 전이면 20년도, 51년이지나면 19년도를 붙임.
FROM DUAL;

-- 날짜 형식을 TO_CHAR로 변경하기 
SELECT TO_CHAR(SYSDATE, 'MON DY, YYYY'), 
       TO_CHAR(SYSDATE, 'YYYY-fmMM-DD DAY'), -- fm은 월 앞에 0을 안붙이는 형식
       TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY'),
       TO_CHAR(SYSDATE, 'YEAR, Q"분기"'),
       TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일"')
FROM DUAL;

-- DECODE()
-- 자바의 삼항연산자 역할!
-- DECODE(컬럼명 | 값, 비교값1, 결과1 [, 비교값2, 결과2  ....], 기본값)
-- 자바의      (조건 식) ? "" : "" 
-- 현재 회사에 근무하는 남성, 여성 사원들을 찾아 
-- '남', '여'라고 호칭하기 

SELECT EMP_NAME "사원명", 
       EMP_NO "주민번호",
       DECODE( SUBSTR(EMP_NO, 8, 1), 1, '남', 2, '여', '기타') "성별"
FROM EMPLOYEE;

-- CASE 문 ( Switch / if-else )
-- 특정 조건을 만족할 때, 수행할 내용을 작성하는 제어문

-- [사용형식]
-- CASE
--    WHEN (조건식1) THEN 결과 1
--    WHEN (조건식2) THEN 결과 2
--  ELSE 결과값 3
-- END

-- EMPLOYEE 테이블에서 
-- ENT_YN은 퇴사여부를 확인하는 컬럼이다. 
-- 컬럼값이 'Y'이면 퇴사, 'N'이면 재직자이다.
-- 사번, 사원명, 직급코드, 근무 여부를 조회하되 
-- EMP_YN이 'Y'이면 '퇴사자', 'N'이면 '근무자'라고 표기하시오.
-- CASE문 사용
--1)
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN, 
    CASE 
        WHEN ENT_YN = 'Y' THEN '퇴사자' 
        ELSE '근무자'
    END "현재상태"
FROM EMPLOYEE;
--2)
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN,
    CASE ENT_YN WHEN 'Y' THEN '퇴사자'
    ELSE '근무자'
    END "재직 여부"
FROM EMPLOYEE;

-- NVL2(컬럼 값 | 데이터, NULL이 아닐 경우 값, NULL일 경우 값)   : NVL은 널일때만 판단했다면 , NVL2는 널이 아닐때도 판단해줌
-- 현재 보너스를 받지 않는 사원을 확인하고자 한다. 
-- 보너스를 받는다면 'O', 그렇지 않다면 'X'를 표기하시오.

SELECT EMP_NAME 사원명,  
       DECODE(NVL(BONUS,0), 0, 'X', 'O') "NVL쓰는 방법",
       LPAD(NVL2(BONUS , 'O' , 'X'), 10, ' ') "NVL2쓰는 방법" 
FROM EMPLOYEE;

-- 단일 행 함수 총 실습 --
-- 사원의 정보를 조회하되
-- 사번, 사원명, 주민번호, 성별을 조회 하시오.
-- 단, 주민번호는 생년월일 뒷자리를 -1****** 형식으로
-- 표현하시오.
--내 답안)
SELECT EMP_ID, 
        EMP_NAME, 
        CONCAT(SUBSTR(EMP_NO, 1, 8), '******') "주민번호", 
        --RPAD(SUBSTR(EMP_NO,1,8) , 14, '*') "주민번호",
        DECODE(SUBSTR(EMP_NO, 8,1) , 1 , '남' , '여') "성별"
FROM EMPLOYEE;
        
-- 그룹 행 함수 (Group Function) -- 
-- 여러 행의 값을 하나로 묶어 결과가 한 개 나오는 함수를 말합니다. 
-- SUM(), AVG(), MAX(), MIN(), COUNT()

-- SUM(컬럼값) : 해당 컬럼들의 합
-- 전 직원들의 급여 합
SELECT SUM(SALARY)
FROM EMPLOYEE;

-- AVG(컬럼값) : 해당 컬럼들의 평균 
-- 전 직원의 급여 평균 
SELECT AVG(SALARY)
FROM EMPLOYEE;

-- MAX(컬럼값) : 해당 컬럼들 중 가장 큰 값 
-- MIN(컬럼값) : 해당 컬럼들 중 가장 작은 값 

SELECT MAX(SALARY), MIN(SALARY)
FROM EMPLOYEE;

-- COUNT(컬럼값) : 존재하는 컬럼들의 갯수 
SELECT COUNT(*), COUNT(DEPT_CODE) -- NULL은 갯수에 포함하지 않는다!
FROM EMPLOYEE;

SELECT EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL;

-- 가장 많은 급여를 받는 사원 조회
-- ORA-00937: not a single-group group function
SELECT EMP_NAME, MAX(SALARY)  -- 단일행 함수(일반 컬럼)와 그룹함수는 같이 사용할 수 없다.
FROM EMPLOYEE;

-- 사네 전체 부서 급여 평균 
-- D1 부서의 급여 평균
SELECT AVG(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- D6 부서의 급여 평균
SELECT AVG(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

-- D9 부서의 급여 평균
SELECT TRUNC(AVG(SALARY)) 
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- GROUP BY & HAVING -- 
-- SELECT 구문 작성 및 실행 순서
/*
    5. SELECT 컬럼명 AS "별칭", 계산식, 함수 -- 주석 
    1. FROM 조회할 테이블명
    2. WHERE 조건 구문 [AND | OR 조건 구문2 ...]
    3. GROUP BY 컬럼명, 함수식 
    4. HAVING 그룹 별 조건 
    6. ORDER BY 컬럼명 | 별칭 | 컬럼 순서 [ASC | DESC] [,다른 컬럼 ... ]
*/

-- GROUP BY 구문 
-- 특정 구문이나 계산식을 하나의 소그룹으로 각각 묶어 
-- 한 테이블 내에서 소그룹 단위 그룹함수를 사용 가능케하는 문법

-- 각 부서 별 급여 평균 조회
SELECT DEPT_CODE, TRUNC(AVG(SALARY), -3) 
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 실습 2 -- 
-- EMPLOYEE 테이블에서 
-- 각 부서별 급여 합계, 급여 평균(100의 자리 반올림) , 최대급여, 최소 급여, 사원 수를 조회하시오 

SELECT DEPT_CODE, SUM(SALARY), ROUND(AVG(SALARY), -2), MAX(SALARY), MIN(SALARY), COUNT(*) 
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 그룹 중 평균 급여가 300만원 이상인 그룹만 조회하고 싶다면?

-- WHERE 구문 : 각 사원을 조회하여 해당 사원이 300만원 이상 급여를 받는 사원들끼리만 그룹을 묶는다.
SELECT DEPT_CODE, AVG(SALARY) 
FROM EMPLOYEE
WHERE SALARY >= 3000000
GROUP BY DEPT_CODE;

--HAVING 구문
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000;

-- 실습 3 -- 
-- 부서 별 급여 합계 중 900만원을 초과하는 
-- 부서의 부서 코드와 급여 합계, 사원 수를 조회하시오 

SELECT DEPT_CODE, SUM(SALARY), COUNT(*) 
FROM EMPLOYEE 
GROUP BY DEPT_CODE
HAVING SUM(SALARY) > 9000000;

-- 집계 함수 -- 
-- ROLLUP() / CUBE()
-- ROLLUP() : 특정 그룹 별로 소계를 계산 해주는 함수
-- CUBE() : 각 그룹 별 소계 및 그룹 내의 기준을 바탕으로 
--          다른 방면에서의 기준 소계도 산출하는 함수 
-- 

-- 직급별 급여 합계 조회 
SELECT JOB_CODE, SUM(SALARY) 
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1;

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1;

-- ROLLUP과 CUBE는 사용하는 컬럼이 하나일 때,
-- 그 결과가 똑같다!

SELECT DEPT_CODE, JOB_CODE, TRUNC(AVG(SALARY), -3)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY 1;

SELECT DEPT_CODE, JOB_CODE, TRUNC(AVG(SALARY), -3)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- ROLLUP은 가장 첫번째 컬럼을 기준으로 각각의 소계를 자동으로 계산 해준다.
-- 반면, CUBE는 가장 첫번째 컬럼 뿐만 아니라 뒤에 있는 컬럼으로도 소계를 계산 해준다.

-- GROUPING()
-- ROLLUP() 이나 CUBE() 함수를 통해 자동으로 생성된 
-- 컬럼을 식별하여 1, 0 으로 구분지어주는 함수
-- GROUPING(컬럼명)
-- 0 : 원래 표현되어야 하는 값 
-- 1 : 집계로 인해 자동으로 생성된 임시 컬럼 


-- 응용편 --
SELECT 
    CASE 
      WHEN GROUPING(DEPT_CODE) = 0 
      THEN NVL(DEPT_CODE, '부서없음')
      WHEN GROUPING(DEPT_CODE) = 1 AND
           GROUPING(JOB_CODE) = 0
      THEN '직급별 합계'
      WHEN GROUPING(DEPT_CODE) = 1 AND
           GROUPING(JOB_CODE) = 1
      THEN '총 합계'
    END "부서 합계",
    CASE 
      WHEN GROUPING(DEPT_CODE) = 0 AND
           GROUPING(JOB_CODE) = 1
      THEN '부서별 합계'
      WHEN GROUPING(JOB_CODE) = 0
      THEN JOB_CODE
      WHEN GROUPING(DEPT_CODE) = 1 AND
           GROUPING(JOB_CODE) = 1
      THEN '총 합계'
      ELSE ' '
    END "직급 합계",
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;

SELECT DECODE(GROUPING(DEPT_CODE), 1, DECODE(GROUPING(JOB_CODE), 1, '총합계', '직급합계'), NVL(DEPT_CODE,'부서없음')) 부서기준,
      DECODE(GROUPING(JOB_CODE), 1,
             DECODE(GROUPING(DEPT_CODE), 1, ' - ', '부서합계'),
             JOB_CODE) 직급기준,
     SUM(SALARY) 급여합계
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1, 2;

-- SET -- 
-- 두 개 이상의 SELECT한 결과 (Result Set)를
-- 하나로 합치거나, 중복되는 내용을 빼는 연산자 

-- 합집합 (UNION) -- 
-- UNION : 두 개 이상의 결과셋을 하나로 합치는 연산자 
--         만약 두 결과에 중복되는 내용이 있다면 한번만 출력 
-- UNION ALL : 중복된 결과도 포함해서 모두 나타냄 
-- D1 부서와 D6부서의 사번, 사원명, 이메일 합치기 

SELECT EMP_ID , EMP_NAME, EMAIL 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5' 
UNION 
SELECT EMP_ID, EMP_NAME, EMAIL 
FROM EMPLOYEE 
WHERE SALARY >= 3000000;

-- INTERSECT : 교집합
-- 두 개 이상의 결과셋 중 중복된 내용만 추출하는 연산자

SELECT EMP_ID , EMP_NAME, EMAIL 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5' 
INTERSECT 
SELECT EMP_ID, EMP_NAME, EMAIL 
FROM EMPLOYEE 
WHERE SALARY >= 3000000;

-- MINUS : 차집합

SELECT EMP_ID , EMP_NAME, EMAIL 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D5' 
MINUS 
SELECT EMP_ID, EMP_NAME, EMAIL 
FROM EMPLOYEE 
WHERE SALARY >= 3000000;

-- JOIN -- ★ * 500
-- 두 개 이상의 테이블을 합하여 통합된 결과셋을 
-- 산출하는 명령어 
-- 두 테이블 간 공통된 값을 가진 컬럼을 사용하여 
-- 서로 데이터를 일치시키며, 만약 컬럼명이 다르다면 
-- 같은 값을 가지는 컬럼을 직접 매칭한다. 

-- 만약에 'J6' 직급이 어떤 직급인지 알고 싶다면...?
SELECT * FROM EMPLOYEE 
WHERE JOB_CODE = 'J6';

SELECT * FROM JOB;

-- 이걸 한 방에 처리할 수는 없을까...?
SELECT EMP_NAME, JOB_CODE, JOB_NAME 
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_CODE = 'J6';

-- 오라클 전용 문법 / ANSI 표준 문법 --
-- 오라클 전용 문법 --
-- FROM 구문에 ',' 기호를 붙여 다른 테이블을 연결한 후 
-- WHERE 조건에 두 테이블 간의 공통된 컬럼을 엮고,
-- 하나의 ResultSet으로 만드는 방법 

--ORA-00918: column ambiguously defined (애매모호한 컬럼이 있다.)
SELECT EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE AND J.JOB_CODE = 'J6';

-- 컬럼 이름이 다르다면?
SELECT EMP_NAME, E.DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E ,DEPARTMENT D 
WHERE E.DEPT_CODE = D.DEPT_ID;

-- ANSI 표준 --
-- 조인하고자 하는 두 개 이상의 테이블을
-- FROM 구문 다음에 JOIN 테이블명 USING(컬럼명) 
-- 혹은 ON(컬럼명 = 컬럼명)을 사용해서 합치는 방법

-- 만약에 두 테이블의 컬럼명이 동일하다면 : USING()
SELECT EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE);

-- 만약에 두 테이블의 컬럼명이 다르다면 : ON()
SELECT EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 실습 4 --
-- EMPLOYEE 테이블과 SAL_GRADE 테이블 정보를 확인하여 
-- 사번, 사원명, 급여 등급, 등급 기준 최소급여, 최대 급여를 조회하시오.
SELECT * FROM EMPLOYEE;
SELECT * FROM SAL_GRADE;

--1) 연결하고자 하는 테이블 정보를 확인하여 
--     공통된 컬럼 찾기

--2) 공통된 컬럼을 연결하여 결과 조회하기 
--      ANSI / ORACLE

-- ANSI
SELECT EMP_ID, EMP_NAME, SAL_LEVEL, MIN_SAL, MAX_SAL 
FROM EMPLOYEE JOIN SAL_GRADE USING(SAL_LEVEL);
-- ORACLE
SELECT EMP_ID, EMP_NAME, EMPLOYEE.SAL_LEVEL, MIN_SAL, MAX_SAL
FROM EMPLOYEE , SAL_GRADE 
WHERE EMPLOYEE.SAL_LEVEL = SAL_GRADE.SAL_LEVEL;

-- INNER JOIN / OUTER JOIN --

-- INNER JOIN :
-- 두 개 이상의 테이블 정보를 합칠 때
-- 서로 일치하는 정보만 합치는 것
-- EQUI-JOIN : 
--      WHERE 나 ON() 에 '=' 기호를 사용하여 조인하는 방식
-- NON-EQUI-JOIN : 
--      WHERE 나 ON() 에 '='이 아닌 !=, >, < 등의 기호를 사용하여 조인하는 방식
-- NATURAL JOIN :
--      WHERE나 ON() 등에 둘 사이의 공통점을 명시하지 않았을 때
--      컬럼의 이름 기준으로 자동 JOIN해주는 방식 (사용을 권장하지 않는다.) 
-- 내가 과제 때 썼던 방법이 NATURAL JOIN    절대 쓰지마라!!!!!!!!!!!!!!!!! 너무 오래 걸림 DB 규모가 커지면
SELECT * 
FROM EMPLOYEE 
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID); -- INNER JOIN중 EQUI-JOIN , DEPT_CODE에 NULL값이 없음.

-- OUTER JOIN : 

--  두 테이블이 서로 가지지 않은 정보까지도
--  합하고자 할 때 사용하는 조인 기법
-- LEFT [OUTER] JOIN :
--     왼쪽의 FROM 원본 테이블 정보를 모두 포함하겠다 (오른쪽이 가지지 못했어도, NULL로 채우겠다)
-- RIGHT [OUTER] JOIN :
--     오른쪽의 혹은 JOIN에 쓰인 테이블 정보를 모두 포함하겠다.
-- FULL [OUTER] JOIN :
--     양측 모두의 정보를 포함하겠다!

-- LEFT OUTER JOIN 
-- ORACLE --
SELECT EMP_ID, EMP_NAME , DEPT_CODE, DEPT_ID, DEPT_TITLE 
FROM EMPLOYEE E , DEPARTMENT D 
WHERE E.DEPT_CODE = D.DEPT_ID(+);
-- ANSI --
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE LEFT JOIN DEPARTMENT ON(DEPT_CODE =DEPT_ID); -- LEFT OUTER JOIN 중 OUTER는 생략 가능

--RIGHT OUTER JOIN

--ORACLE--
SELECT EMP_ID, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE , DEPARTMENT 
WHERE DEPT_CODE(+) = DEPT_ID;
--ANSI--
SELECT EMP_ID, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE RIGHT JOIN DEPARTMENT 
ON (DEPT_CODE = DEPT_ID);     
-- 만약 테이블 명에 별칭을 줬다면 무조건 ON()을 사용해야 함

-- FULL OUTER JOIN -- 
-- ORACLE --
-- 오라클은 FULL OUTER JOIN을 제공하지 않는다.
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID(+);

-- ANSI --
SELECT EMP_ID, DEPT_CODE, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE FULL JOIN DEPARTMENT 
ON (DEPT_CODE = DEPT_ID);

-- CROSS JOIN -- 
-- 서로 겹치는 정보가 단 하나도 없을 때
-- 두 테이블 사이의 연관성을 찾기 위해 수행하는 조인 방법
-- ANSI--
SELECT EMP_NAME, NATIONAL_NAME
FROM EMPLOYEE 
CROSS JOIN NATIONAL;
-- 카테시안 곱(곱집합)이라고 함, 잘 사용하지는 않음.
-- ORACLE--
SELECT EMP_NAME, NATIONAL_NAME
FROM EMPLOYEE, NATIONAL; 

-- 실습 5 --
-- DEPARTMENT 테이블에서 위치 정보를 가져와서
-- LOCATION 테이블의 정보를 조인하여
-- 각 부서 별 근무지 위치를 조회 하시오.
-- 부서 코드, 부서명, 근무지 코드(LOCATION_ID), 근무지 위치(LOCAL_NAME)
-- ORACLE / ANSI --
-- ORACLE --
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;
SELECT DEPT_TITLE , DEPT_ID, D.LOCATION_ID , LOCAL_NAME 
FROM DEPARTMENT D, LOCATION L 
WHERE D.LOCATION_ID = L.LOCAL_CODE;

-- ANSI --
SELECT DEPT_TITLE , DEPT_ID, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE);

