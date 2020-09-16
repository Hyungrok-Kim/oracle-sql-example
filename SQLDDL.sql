-- Day 4 --

-- SELECT 구문 순서
-- 5 : SELECT 컬럼명 AS "별칭"
-- 1 : FROM 테이블명 별칭
-- 2 : [WHERE 조건식]
-- 3 : [GROUP BY 컬럼명]
-- 4 : [HAVING 그룹 조건식]
-- 6 : ORDER BY 컬럼명 | 컬럼 순서 | 별칭 [ ASC | DESC ] [ NULLS LAST | FIRST ]

-- SET 연산자
-- UNION / UNION ALL
-- 합집합 : 두 개 이상의 SELECT한 결과(ResultSet)를
--             합칠 때 사용한다. (UNION : 중복을 한 번만 조회 / UNION ALL : 중복을 모두 포함)
-- INTERSECT : 교집합
--             두 개 이상의 SELECT한 결과에서 서로 중복되는 부분만 추려내는 연산자
-- MINUS : 차집합
--             첫번째 결과셋에서 나머지를 뺀 다음 그 결과를 조회하는 연산자

-- JOIN 
-- ORACLE 문법
-- JOIN 키워드를 안 씀
SELECT *
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- ANSI 표준 문법
-- JOIN 키워드를 씀
SELECT *
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);
-- ON () :
--     연결하려는 테이블의 컬럼 이름이 다를 때
-- USING() :
--     연결하려는 테이블의 컬럼 이름이 같을 때

-- INNER JOIN & OUTER JOIN
-- INNER JOIN : 서로 연결할 수 있는 정보만 꺼내올 때
-- OUTER JOIN : 서로 연결할 수 없는(누군가 한 테이블이 정보를 더 가지고 있을 때)
--                           정보까지 꺼내올 때
-- LEFT : 원본 테이블(좌측)의 결과를 추가하겠다.
-- RIGHT : 조인하려는 테이블의 결과를 추가하겠다.
-- FULL : 두 테이블 모두의 정보를 포함하겠다.
--    ORACLE 문법에서는 안됨!

-- CROSS JOIN
-- 합하고자 하는 두 개 이상의 테이블이 서로 일치하는 정보가 없을 때
-- 강제로 조인하고자 하는 방법
-- 발생하는 결과를 카테시안 곱이라고 표현한다.

-- 워밍업 --
-- 한국(KO)과 일본(JP)에 근무하는 직원들의 
-- 사번, 사원명, 부서명, 국가명을 조회 하시오.
-- 다중 조인(JOIN)
SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;
SELECT * FROM LOCATION;
-- ORACLE --
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE,  N.NATIONAL_NAME
FROM EMPLOYEE E, DEPARTMENT D, NATIONAL N, LOCATION L
WHERE E.DEPT_CODE = D.DEPT_ID AND D.LOCATION_ID = l.local_code AND L.NATIONAL_CODE = n.national_code
AND L.LOCAL_CODE IN ('L1','L2');

-- ANSI --
SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE,  N.NATIONAL_NAME
FROM EMPLOYEE E JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID) 
JOIN LOCATION L ON (D.LOCATION_ID = l.local_code) 
JOIN NATIONAL N ON (L.NATIONAL_CODE = n.national_code)
WHERE L.LOCAL_CODE IN ('L1','L2');

-- SELF JOIN --
-- 자기 자신을 조인하는 방법
-- 자신이 가지는 테이블 정보를 비교하여 
-- 원하는 내용을 연결지을 때 사용하는 방법
-- 단, 자기 자신을 붙일 때는 서로 테이블 별칭으로 
-- 구분 지어주어야 한다.
SELECT * FROM EMPLOYEE;

--EMPLOYEE 테이블에서 사원과 해당 사원의 관리자 정보도 같이 조회하기 
SELECT EMP_ID, EMP_NAME, MANAGER_ID 
FROM EMPLOYEE;

-- ORACLE 방식 --
SELECT E.EMP_ID,      -- 근무자 사번
       E.EMP_NAME ,   -- 근무자 이름
       E.MANAGER_ID , -- 관리자 사번
       M.EMP_NAME     -- 관리자 이름
FROM EMPLOYEE E , EMPLOYEE M
WHERE E.MANAGER_ID = M.EMP_ID;

-- ANSI --
SELECT E.EMP_ID,        -- 근무자 사번
       E.EMP_NAME,      -- 근무자 이름
       E.MANAGER_ID,    -- 관리자 사번
       M.EMP_NAME       -- 관리자 이름
FROM EMPLOYEE E
JOIN EMPLOYEE M ON (E.MANAGER_ID = M.EMP_ID);

-- 서브 쿼리 --
-- 주가 되는 바깥 쿼리( 메인쿼리 ) 안에서
-- 조건이나 하나의 검색값을 위한 
-- 또 하나의 쿼리를 추가하여 사용하는 기법
-- 서브쿼리 VS JOIN --
-- 테이블의 결과를 봤을 때 조인은 대등한 조건에서 여러 테이블들을 합하는 것이고,
-- 서브쿼리는 메인쿼리와 서브쿼리(부가 쿼리)라는 종속적인 관계로 만들어지는 
-- 테이블이다.

-- 최소 급여를 받는 사원을 조회하시오.
SELECT MIN(SALARY)
FROM EMPLOYEE;

-- 1380000
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
--WHERE SALARY = 1380000
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE
                );
                
-- 서브쿼리 사용 위치
-- SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY, JOIN (다 쓸 수 있음)
-- DML : INSERT, UPDATE, DELETE
-- DDL : CREATE, ALTER, DROP, CREATE VIEW
-- 다 쓸 수 있음

-- 단일 행 서브쿼리 : 
--      서브쿼리의 결과가 1개 나오는 기법
--      최소 급여를 받는 사원 
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);
                
-- 다중 행 서브쿼리 :
--   서브쿼리의 결과가 여러 줄 나오는 기법
-- 각 직급별 최소 급여를 받는 사원을 조회 
-- 1) 각 직급 별 최소 급여
SELECT JOB_CODE,  MIN(SALARY) 
FROM EMPLOYEE 
GROUP BY JOB_CODE;

-- 2) 각 직급 별 최소 급여를 활용한 사원 조회
SELECT EMP_NAME , JOB_CODE, SALARY 
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE,  MIN(SALARY) 
                            FROM EMPLOYEE 
                            GROUP BY JOB_CODE);

-- 실습 1 -- 
-- 우리 회사엔 퇴사한 여직원이 한 명있다.
-- 이 퇴사한 여직원과 같은 직급, 같은 부서에서
-- 근무하는 직원들의 사번, 사원명, 직급코드, 부서코드를 조회 하시오.
-- 단일 행으로 푼다면 ... ?
SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_CODE
FROM EMPLOYEE
WHERE JOB_CODE = (SELECT JOB_CODE
                  FROM EMPLOYEE
                  WHERE ENT_YN = 'Y')
  AND DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE ENT_YN = 'Y')
  AND ENT_YN != 'Y';

-- 다중 행으로 푼다면 ... ?
SELECT EMP_ID,EMP_NAME,JOB_CODE,DEPT_CODE 
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) IN 
(SELECT DEPT_CODE, JOB_CODE FROM EMPLOYEE WHERE ENT_YN = 'Y' AND SUBSTR(EMP_NO,8,1) = 2) 
AND ENT_YN = 'N';

-- DDL : 데이터 정의어 --
/*
   DDL : 데이터베이스의 객체(테이블, 사용자 계정)를 생성하거나
         객체의 정보를 수정, 객체 삭제를 할 때 사용하는 명령어
  
  CREATE : 객체 생성하는 명령어
  [사용 형식]
  CREATE 객체형태 이름
  EX 1) 
    CREATE USER SCOTT IDENTIFIED BY TIGER;
  EX 2)
    CREATE TABLE 테이블명 (
     컬럼명 자료형 [제약조건],
    );
    
    ** 제약조건 : 데이터를 테이블에 저장할 때 지켜야하는 규칙들
    - Constraint -

     NOT NULL : 해당 컬럼에는 NULL을 넣을 수 없다! (필수정보들을 따질 때)
     UNIQUE : 중복 값을 저장하면 안돼!
     CHECK : 특정 값만 저장할 수 있도록 하는 제한을 두어라!
     PRIMARY KEY : (NOT NULL + UNIQUE)
        - 테이블 내에 존재하는 하나의 행을 인식(식별)할 수 있는
          고유의 값을 말한다. 
        - 한 테이블에 반드시 하나 존재함을 원칙으로 하며,
           없을 수는 있지만, 둘 이상은 될 수 없다.
     FOREIGN KEY : 다른 테이블의 기본키나 고유의 값을 통해
           참조하여 현재 테이블로 가져오는 값

*/

-- 테이블 작성하기! 
-- 테이블(표) : 데이터를 저장하기 위한 틀 
--  데이터를 2차원의 표 형태로 저장, 관리하는 객체 

CREATE TABLE USER_TABLE(
      USER_NO NUMBER,          --회원 번호
      USER_ID VARCHAR2(20),    --회원 아이디   -- 20 CHAR, 또는 20 BYTE로 저장가능, 근데 아무것도 안쓰면 디폴트 BYTE임
      USER_PWD VARCHAR2(20),   --회원 비밀번호
      USER_NAME VARCHAR2(15)   --회원 명
);

SELECT * FROM USER_TABLE;
INSERT INTO USER_TABLE VALUES(1,'kgudfhr96','123123','김형록');

-- 테이블의 각 컬럼에 주석(COMMENT) 달기 
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';
COMMENT ON COLUMN USER_TABLE.USER_NO IS '회원 번호';
COMMENT ON COLUMN USER_TABLE.USER_ID IS '회원 아이디';
COMMENT ON COLUMN USER_TABLE.USER_PWD IS '회원 비밀번호';
COMMENT ON COLUMN USER_TABLE.USER_NAME IS '회원 명';

-- 현재 사용자 계정이 가진 모든 테이블 조회 
SELECT * FROM USER_TABLES;
SELECT * FROM TABS; -- 둘이 똑같음

-- 현재 사용자 계정이 가진 모든 테이블 컬럼 정보 조회 
SELECT * FROM USER_TAB_COLUMNS;  -- ★★★

-- 데이터 사전(데이터 딕셔너리)
-- 데이터베이스에서 사용자 정보나 시스템 정보등을 하나의 테이블 형태로
-- 보여주는 데이터 설정 문서
-- USER_OOOO : 현재 접속한 사용자 계정과 관련된 설정을 가진 데이터 사전
-- DBA_OOOO : 시스템 설정들을 담당하는 관리자가 접근하는 데이터 사전
-- ALL_OOOO : 모든 계정이 접근 가능한 데이터 사전

-- 만든 테이블 삭제하기 
DROP TABLE USER_TABLE;

-- 제약조건 --
-- NOT NULL --
-- 해당 컬럼에 반드시 값을 넣어야 한다.
-- 컬럼을 생성할 때 옆에 추가하여 선언할 수 있다. (컬럼 레벨 제약조건) 

CREATE TABLE USER_NO_CONS(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(20),
    PHONE VARCHAR2(14)
);

SELECT * FROM USER_NO_CONS;
-- 테이블에 값 추가하기 
INSERT INTO USER_NO_CONS 
VALUES(1,'user01', 'pass01', '010-1111-2222');

INSERT INTO USER_NO_CONS
VALUES(2,NULL,NULL,NULL);

SELECT * FROM USER_NO_CONS;

DROP TABLE USER_NO_CONS; 

------------------------------------

CREATE TABLE USER_NOT_NULL(
    USER_NO NUMBER NOT NULL, -- 컬럼 레벨 제약조건
    USER_ID VARCHAR2(20)  NOT NULL,
    USER_PWD VARCHAR2(20) NOT NULL,
    PHONE VARCHAR2(14)
);

INSERT INTO USER_NOT_NULL
VALUES(1,'user01','pass01','010-1111-2222');

-- ORA-01400: cannot insert NULL into ("EMPLOYEE"."USER_NOT_NULL"."USER_ID")
INSERT INTO USER_NOT_NULL
VALUES(2, NULL, NULL, NULL);

INSERT INTO USER_NOT_NULL 
VALUES(3,'user01','pass07','010-1234-5678');

SELECT * FROM USER_NOT_NULL;

DROP TABLE USER_NOT_NULL;

-- UNIQUE --
-- 해당 컬럼에 고유한 값(중복 X)만 저장하겠다!

CREATE TABLE USER_UNIQUE(
    USER_NO NUMBER        UNIQUE, -- 컬럼 레벨 제약조건 : 컬럼을 생성하면서 같이 제약조건을 주는 것 
    USER_ID VARCHAR2(20)  UNIQUE,
    USER_PWD VARCHAR2(20) NOT NULL,
    PHONE VARCHAR2(14)
);

INSERT INTO USER_UNIQUE 
VALUES(1, 'user01', 'pass01', '010-1111-2222');

INSERT INTO USER_UNIQUE
VALUES(1, 'user02', 'pass007', '010-0070-7000');

-- 우리가 선언한 제약조건 내용 확인하기
-- Data Dictionary : 데이터 사전
SELECT * FROM USER_CONSTRAINTS;         
SELECT * FROM USER_CONS_COLUMNS;
-- CONSTRAINT_TYPE
-- P : PRIMARY KEY / 기본키 
-- C : CHECK / 범위 지정 조건 (CHECK 제약조건, NOT NULL 제약)
-- U : UNIQUE / 중복 X
-- R : REFERENCES / 외래키 제약조건(FOREIGN KEY)

DROP TABLE USER_UNIQUE;

-- 컬럼 레벨 VS 테이블 레벨 제약 조건 선언 
CREATE TABLE USER_UNIQUE(
    USER_NO NUMBER       UNIQUE, -- 컬럼 레벨 제약조건 : 컬럼을 생성하면서 같이 제약조건을 주는 것 
    USER_ID VARCHAR2(20)  ,
    USER_PWD VARCHAR2(20) NOT NULL,
    PHONE VARCHAR2(14)
    UNIQUE(USER_ID)         --  테이블 레벨 제약조건 : 컬럼 선언이 다 끝난 후 테이블의 뒷 쪽에 다는 제약조건
                            --  컬럼 선언이 모두 끝난 후 
                            --  추가로 선언하는 제약 조건을 말한다.
);

-- 일반적으로 제약 조건 선언 시에 
-- 테이블 레벨, 컬럼 레벨 모두 선언이 가능하나 
-- 유일하게 NOT NULL 은 컬럼레벨 제약 조건으로만 
-- 선언이 가능하다.

-- UNIQUE 제약 조건은 여러 컬럼을 기준으로 묶을 수도 있다. 
-- 서울, 홍길동
-- 서울, 펭수
-- 부산, 홍길동 
-- 부산, 펭수 

CREATE TABLE USER_UNIQUE2(
    USER_NO NUMBER, 
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(20) NOT NULL,
    PHONE VARCHAR2(14),
    UNIQUE(USER_NO , USER_ID)   -- 여러 컬럼을 함께 묶을 때는 
                                -- 테이블 레벨 선언만 가능하다.
);

INSERT INTO USER_UNIQUE2
VALUES(1, 'user01', 'pass01', null);

INSERT INTO USER_UNIQUE2
VALUES(1, 'user02', 'pass02', null);    -- USER_ID, USER_NAME을 묶어서 UNIQUE 제약을 만들었기 때문에 가능하다.

INSERT INTO USER_UNIQUE2
VALUES(2, 'user01', 'pass01', null);

INSERT INTO USER_UNIQUE2
VALUES(2, 'user01', 'pass03', NULL);

DROP TABLE USER_UNIQUE2;

-- CHECK -- 
-- 컬럼에 특정 범위의 값만 넣겠다! 

CREATE TABLE USER_CHECK(
    USER_NO NUMBER,
    USER_ID VARCHAR2(20),
    USER_PWD VARCHAR2(20),
    GENDER CHAR(3BYTE) CONSTRAINT CK_GENDER CHECK(GENDER IN('남','여'))
);

SELECT * FROM USER_CONSTRAINTS;

INSERT INTO USER_CHECK
VALUES(1, 'user01', 'pass01' , '남');

INSERT INTO USER_CHECK
VALUES(2, 'user02', 'pass02' , '여');

-- ORA-02290: check constraint (EMPLOYEE.CK_GENDER) violated
INSERT INTO USER_CHECK
VALUES(3, 'user03', 'pass03' , '양');

DROP TABLE USER_CHECK;

-- PRIMARY KEY : 기본키 --
-- 테이블 안의 한 행, 한 행을 식별하는 고유 값
-- EX) 회원 정보 : 
--        이름 : 김철수
--        나이 : 10세
--        사는 곳 : 은하철도 
--        주민번호 : 200909-3012345
-- 1. 한 테이블 당 하나 존재함을 원칙
-- 2. NOT NULL
-- 3. UNIQUE .. (NOT NULL + UNIQUE)

CREATE TABLE USER_PK_TABLE(
    USER_NO NUMBER CONSTRAINT PK_USER_NO PRIMARY KEY, -- 기본키는 하나만! >_<!!
    USER_ID VARCHAR2(20) UNIQUE NOT NULL,  -- 여러 개 지정할 수 있다!
    USER_PWD VARCHAR2(20) NOT NULL,
    USER_NAME VARCHAR2(15) NOT NULL,
    GENDER CHAR(1) CHECK (GENDER IN ('M', 'F')),
    PHONE VARCHAR2(13),
    EMAIL  VARCHAR2(20)
    -- PRIMARY KEY(USER_NO, USER_ID) 복합키 (사용을 지양한다)
);

INSERT INTO USER_PK_TABLE 
VALUES(1,'user01','pass01','홍길동','M',null,null);

INSERT INTO USER_PK_TABLE 
VALUES(2,'user02','pass02','홍길서','F',null,null);

INSERT INTO USER_PK_TABLE 
VALUES(3,'user03','pass03','홍길남','M',null,null);

INSERT INTO USER_PK_TABLE 
VALUES(4,'user04','pass04','홍길북','F',null,null);

SELECT * FROM USER_PK_TABLE;

INSERT INTO USER_PK_TABLE
VALUES(NULL, 'user05','pass05','홍길동','M',NULL,NULL);

DROP TABLE USER_PK_TABLE;

-- FOREIGN KEY --
-- 외래키, 외부키, 참조키 
-- 다른 테이블의 컬럼값을 참조(REFERENCE)하여 
-- 참조하는 값들 중에서 현재 컬럼의 값을 채우는 조건 
-- 이 제약조건을 통해서 다른 테이블과의 관계를 만들어 낼 수 있다. 
-- (관계 : RelationShip) : RDBMS 

-- ** 단, 참조하는 대상 컬럼은 반드시 기본키이거나 UNIQUE여야 한다.
--      NULL을 참조한다는 건 이상하고 
--      중복이 있으면 당연히 안됨, 외래키에서 뭐가뭔지 구분할 수 없으니까.

CREATE TABLE USER_GRADE(
    GRADE_NO NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL 
);

INSERT INTO USER_GRADE (GRADE_NAME, GRADE_NO)
VALUES('벽돌',1);

INSERT INTO USER_GRADE (GRADE_NAME, GRADE_NO)
VALUES('짱돌',2);

INSERT INTO USER_GRADE (GRADE_NAME, GRADE_NO)
VALUES('맷돌',3);

INSERT INTO USER_GRADE (GRADE_NAME, GRADE_NO)
VALUES('부싯돌',4);

INSERT INTO USER_GRADE (GRADE_NAME, GRADE_NO)
VALUES('디딤돌',5);

SELECT * FROM USER_GRADE;

CREATE TABLE USER_FK_TABLE(
    USER_NO NUMBER PRIMARY KEY,
    USER_NAME VARCHAR2(15),
    GRADE_NO NUMBER , --REFERENCE USER_GRADE, -- 컬럼 레벨 
    CONSTRAINT FK_USER_GRADE FOREIGN KEY(GRADE_NO) 
    REFERENCES USER_GRADE(GRADE_NO) -- 테이블 레벨 
);

INSERT INTO USER_FK_TABLE 
VALUES(1, '김다운', 1);

INSERT INTO USER_FK_TABLE 
VALUES(2, '김익주', 2);

INSERT INTO USER_FK_TABLE 
VALUES(3, '김진호', 3);

INSERT INTO USER_FK_TABLE 
VALUES(4, '김명진', 4);

INSERT INTO USER_FK_TABLE 
VALUES(5, '김형록', 5);

-- ORA-02449: unique/primary keys in table referenced by foreign keys
INSERT INTO USER_FK_TABLE 
VALUES(6, '재현박', 6);
-- 참조하는 원본 테이블 컬럼값이 삭제될 때
-- 참조받는 대상(자식) 테이블의 값은 존재가 애매해지므로 
-- 함부로 삭제할 수 없다.
DROP TABLE USER_GRADE;

-- 삭제 옵션 -- 
-- 해당 테이블의 정보와 함께 제약조건도 날려버리는 방법 
DROP TABLE USER_GRADE CASCADE CONSTRAINTS;
SELECT * FROM USER_FK_TABLE;

DROP TABLE USER_FK_TABLE;

-- 데이터 삭제시 삭제 옵션 --
SELECT * FROM USER_GRADE;
SELECT * FROM USER_FK_TABLE;

-- ORA-02292: integrity constraint (EMPLOYEE.FK_USER_GRADE) violated - child record found
DELETE FROM USER_GRADE
WHERE GRADE_NAME = '벽돌';

-- ON DELETE SET NULL 
-- 원본이 데이터를 삭제하면 
-- 참조하는 테이블의 컬럼은 NULL로 바꾸는 옵션

-- ON DELETE CASCADE
-- 부모가 가진 데이터가 삭제될 때, 이와 맞물린 자식 테이블의 데이터도 한 행 통째로 삭제하는 방법 

-- EML -- 
-- INSERT / UPDATE / DELETE -- 
-- CRUD : [ INSERT / SELECT / UPDATE / DELETE ] 

-- INSERT : 테이블에 데이터를 추가하는 명령어 
-- [사용 형식]
-- 1. 특정 컬럼에 값을 추가하는 방법 
-- INSERT INTO 테이블 명[(컬럼명1, 컬럼명2, ..] VALUES(값1, 값2, ...);

-- 2. 모든 컬럼에 값을 추가하는 방법 
-- INSERT INTO 테이블명 
-- VALUES(컬럼 순서대로 값을 모두 기재);

-- 신입사원 추가하기 ( 1번 ) 
INSERT INTO EMPLOYEE (EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, 
                    JOB_CODE, SAL_LEVEL, SALARY, BONUS, MANAGER_ID, HIRE_DATE, 
                    ENT_DATE, ENT_YN)
VALUES(500,'무연석', '510101-1234567', 'MOO@example.com', '01712345678', 'D1', 
            'J7', 's4', 1000,  16, '200', sysdate, null, DEFAULT );

-- 신입사원 추가하기 (2번) 
INSERT INTO EMPLOYEE
VALUES (501, '홍서천', '520101-2123456', 'westseo@example.com', '019123356788', 'D1',
       'J7', 'S4', 500, 0.3, '200', SYSDATE, NULL, DEFAULT);

SELECT * FROM EMPLOYEE;

-- 가장 최근에 커밋했던 시점으로 돌아가기
-- ROLLBACK;

-- 현재까지 데이터 추가/ 수정/ 삭제한 사항을 DB에 반영하기
-- COMMIT;

-- UPDATE --
-- 해당 테이블의 특정 컬럼을 수정하는 명령어
-- [사용 형식]
-- UPDATE 테이블명 SET 컬럼명 = 바꿀 값[, 컬럼명2 = 바꿀값2 ...]
-- [WHERE 컬럼명 = 조건식]

CREATE TABLE DEPT_COPY 
AS SELECT * FROM DEPARTMENT; -- 테이블을 본뜰 때 사용하는 AS 

-- CREATE / ALTER / DROP : DDL 은 실행 후 자동으로 커밋이 실행된다. 

SELECT * FROM DEPT_COPY;

UPDATE DEPT_COPY SET DEPT_TITLE = '인사관리부' WHERE DEPT_ID = 'D1';

-- 'D9'부서의 DEPT_TITLE
-- 총무부 --> 전략기획부
UPDATE DEPT_COPY SET DEPT_TITLE = '전략기획부' WHERE DEPT_ID = 'D9';
SELECT * FROM DEPT_COPY;

-- DELETE -- 
-- 기존에 들어있던 데이터를 삭제하는 명령어 

-- [사용형식] 
-- DELETE FROM 테이블명 
-- [WHERE 조건식]
-- ** 만약 조건식을 달지 않으면 
--    해당 테이블의 데이터 전부 삭제함.

DELETE FROM EMPLOYEE;

SELECT * FROM EMPLOYEE;

DELETE FROM EMPLOYEE
WHERE EMP_ID = 501;

SELECT * FROM EMPLOYEE;

COMMIT;

DELETE FROM DEPT_COPY;

-- TRUNCATE(DDL) -- 
-- 테이블의 모든 데이터를 절삭하는 명령어
-- ** ROLLBACK;
-- 속도는 DELETE로 전부 삭제하는 것보다 월등히 빠름 

TRUNCATE TABLE DEPT_COPY;

ROLLBACK;

SELECT * FROM DEPT_COPY;   -- TRUNCATE는 ROLLBACK으로 되돌릴 수 없음.

-- 시퀀스
-- 데이터베이스에서 값을 
-- 순차적으로 기록할 때 사용하는 객체 
-- 1,2,3,4,5...
-- [사용형식]
-- CREATE SEQUENCE 시퀀스명
-- [
-- START WITH 100 : 시퀀스 실행 시 처음 시작하는 숫자(기본값 : 1 )
-- INCREMENT BY 5 : 5씩 증가한다.
--              -5: 5씩 감소한다. 
--  MAXVALUE999 : 시퀀스가 실행될 최댓값 (exceed MAX VALUE) 
--  MINVALUE 10 : 시퀀스가 감소할 최솟값 
--  CYCLE|NO CYCLE : 값의 반복 여부 
--  CHCHE|NOCACHE: 값을 미리 구해놓을 것인지 
--]
-- CACHE : 다음에 올 값을 미리 계산해 놓는 것 
-- 1...20
--  장점 : 다음에 올 숫자를 빠르게 구할 수 있다. 
--  단점 : 시스템이 예상치 못할 상황에서 종료되었을 때 
--          이전의 값을 기억할 수 없다.

-- NOCACHE: 다음에 올 숫자를 즉석으로 구하는 것 
--  장점 : 시스템이 예상치 못한 종료를 하더라도 
--          다음에 올 숫자를 올바르게 식별할 수 있다.
--  단점 : 매 번 실행 시 CACHE 방식에 비해 속도가 느리다. 
DROP SEQUENCE SEQ_TEST;
CREATE SEQUENCE SEQ_TEST
START WITH 100
MAXVALUE 110 
MINVALUE 10
INCREMENT BY 2 
NOCYCLE;

-- ORA-08002: sequence SEQ_TEST.CURRVAL is not yet defined in this session
-- 처음 실행 시에 새로운 값을 만들어야 하기 때문에 반드시 NEXTVAL을 먼저 실행해야 한다. 
SELECT SEQ_TEST.CURRVAL FROM DUAL;

SELECT SEQ_TEST.NEXTVAL FROM DUAL;

SELECT SEQ_TEST.CURRVAL FROM DUAL;

SELECT SEQ_TEST.NEXTVAL FROM DUAL;
SELECT SEQ_TEST.NEXTVAL FROM DUAL;