-- Day 5 --
/*
    CREATE : DDL (데이터 정의어)의 하나
      데이터베이스의 객체를 생성할 때 사용하는 명령어
      
    [사용형식]
    CREATE 객체종류 객체명 옵션 . . . .
    ex) CREATE USER 사용자명 IDENTIFIED BY 비밀번호;
          CREATE TABLE 테이블명 ( 
             컬럼명 자료형(길이) 제약조건 . . . ,
             컬럼명 자료형(길이) 제약조건 . . . 
          );
    
     -- 제약조건 (CONSTRAINT)
     -- UNIQUE : 해당 컬럼의 중복을 허용하지 않겠다!
     -- NOT NULL : 해당 컬럼에는 NULL 값을 허용하지 않겠다!
     -- PRIMARY KEY ( UNIQUE + NOT NULL ) : 
           한 테이블에 반드시 하나만 존재하는 제약조건,
           해당 행에서(가로줄) 다른 모든 값을 식별하는 고유의 값
     -- CHECK : 지정한 범위의 값이 들어 있는지 확인해주는 제약조건
     -- FOREIGN KEY : 다른 테이블을 참조(레퍼런스)하여 가져오는 제약조건
                                해당 컬럼에는 다른 테이블의 지정한 컬럼 값들 외에는 들어갈 수 없다.
    
    -- 삭제 옵션
       -- ON DELETE SET NULL : 만약 부모 데이터가 삭제되면 연관된 
                                                   다른 테이블의 자식들을 NULL로 바꿔주는 옵션
       -- ON DELETE CASCADE : 부모 데이터가 삭제되면 연관된
                                                   다른 테이블의 자식들까지 삭제하는 옵션
*/


DROP TABLE USER_INFO;

CREATE TABLE USER_INFO (
   USER_NO           NUMBER          PRIMARY KEY,
   USER_NAME       VARCHAR2(15)    NOT NULL,
   USER_BIRTH       CHAR(14)      NOT NULL UNIQUE,
   USER_ADDRESS    VARCHAR2(100)   NOT NULL,
   USER_PHONE     VARCHAR2(13)   NOT NULL
);

COMMENT ON COLUMN USER_INFO.USER_NO IS '회원번호';
COMMENT ON COLUMN USER_INFO.USER_NAME IS '회원이름';
COMMENT ON COLUMN USER_INFO.USER_BIRTH IS '주민등록번호';
COMMENT ON COLUMN USER_INFO.USER_ADDRESS IS '주소';
COMMENT ON COLUMN USER_INFO.USER_PHONE IS '연락처';

DROP TABLE BOOK_INFO;

CREATE TABLE BOOK_INFO (
   BOOK_NO    NUMBER          PRIMARY KEY,
   BOOK_NAME   VARCHAR2(30)   NOT NULL,
   WRITER       VARCHAR2(15)   NOT NULL,
   BOOK_PRICE   NUMBER
);

COMMENT ON COLUMN BOOK_INFO.BOOK_NO IS '도서번호';
COMMENT ON COLUMN BOOK_INFO.BOOK_NAME IS '제목';
COMMENT ON COLUMN BOOK_INFO.WRITER IS '저자';
COMMENT ON COLUMN BOOK_INFO.BOOK_PRICE IS '가격';

DROP TABLE RENT_INFO;

CREATE TABLE RENT_INFO (
   RENT_NO    NUMBER,
   USER_NO    NUMBER   REFERENCES USER_INFO (USER_NO) ON DELETE CASCADE,
   BOOK_NO       NUMBER   REFERENCES BOOK_INFO (BOOK_NO) ON DELETE CASCADE,
   RENT_DATE   DATE   NOT NULL,
   RETURN_DATE   DATE,
    PRIMARY KEY (RENT_NO, USER_NO, BOOK_NO)
);

COMMENT ON COLUMN RENT_INFO.RENT_NO IS '대여번호';
COMMENT ON COLUMN RENT_INFO.USER_NO IS '회원번호';
COMMENT ON COLUMN RENT_INFO.BOOK_NO IS '도서번호';
COMMENT ON COLUMN RENT_INFO.RENT_DATE IS '대여일자';
COMMENT ON COLUMN RENT_INFO.RETURN_DATE IS '반납일자';


INSERT INTO USER_INFO
VALUES(1, '홍길동', '600203-1149823', '서울시 강남구', '0105444-2222');
INSERT INTO USER_INFO
VALUES(2, '홍길서', '501025-1121543', '서울시 강남구', '0102222-3333');
INSERT INTO USER_INFO
VALUES(3, '홍길남', '700513-1149823', '서울시 강남구', '0105444-2222');

INSERT INTO BOOK_INFO
VALUES(123, '홍길동전', '김아무개', 10000);
INSERT INTO BOOK_INFO
VALUES(348, '나의라임오렌지나무', '조제',24000);
INSERT INTO BOOK_INFO
VALUES(700, '마시멜로이야기', '엘런싱어',18000);

INSERT INTO RENT_INFO
VALUES(1, 1, 123, SYSDATE, NULL);

INSERT INTO RENT_INFO
VALUES(2, 2, 348, SYSDATE, NULL);

INSERT INTO RENT_INFO
VALUES(3, 2, 700, SYSDATE, NULL);

-- Object -- 
/*
    데이터를 보다 효율적으로 관리, 운용하기 위한 기능 집합체 
    SEQUENCE / VIEW 
*/

-- SEQUENCE : 시퀀스 --
--   연속된 순서 
-- 1, 2, 3, 4, 5 ... 값을 자동으로 증가 / 감소 시키는 객체 

/*
    [사용형식]
    CREATE SEQUENCE 시퀀스명
    [INCREMENT BY 숫자 ] : 몇 씩 증가 할 것인지 설정, 생략하면 기본값으로 1씩 증가!
    -- INCREMENT BY 5 : 5씩 증가
    -- INCREMENT BY -5 : 5씩 감소
    [START WITH] : 시작 값, 생략하면 기본값으로 1부터 시작!
    [MAXVALUE | NOMAXVALUE] : 발생할 순서값의 최댓값
    [MINVALUE | NOMINVALUE] : 발생할 순서값의 최솟값
    [CYCLE | NOCYCLE] : 값의 순환 여부 (1 . . . 100  . . . 1 . . . )
    [CACHE 바이트 크기 | NOCACHE] : 다음 값을 미리 계산해 놓는 설정
                                                            정해진 바이트 크기만큼 미리 계산 해 놓는다.
                                                            -- 기본값은 CACHE 20byte | 최솟값 2byte
                                                            
                    -- CACHE : 컴퓨터가 다음 값을 미리 계산하기 때문에 
                               속도가 빠르다 ! 
                               단점 : 중간에 컴퓨터를 종료하면 미리 계산 해둔 값이 날아감 
                               1 ~  / ~ 10 // 11 ~> 컴퓨터가 10까지 계산하는 와중 꺼지면 11부터 기억함
                    -- NOCACHE : 컴퓨터가 그때 그때 값을 계산함 
                                 값이 중간에 끊겨도 컴퓨터가 기억함 / 속도가 상대적으로 느리다.
*/

-- 시퀀스가 가진 속성 보기
SELECT * FROM USER_SEQUENCES;

-- 시퀀스 생성
-- NO CYCLE 일 경우
CREATE SEQUENCE SEQ_NO
START WITH 4 
INCREMENT BY 1 
MAXVALUE 10 
NOCACHE
NOCYCLE;

SELECT SEQ_NO.NEXTVAL 
FROM DUAL; 

-- CYCLE 일 경우
CREATE SEQUENCE SEQ_CYCLE
START WITH 1
MINVALUE -100
MAXVALUE 100
INCREMENT BY 20
CYCLE
NOCACHE;


SELECT SEQ_CYCLE.NEXTVAL
FROM DUAL;

-- CACHE 20
CREATE SEQUENCE SEQ_CACHE
START WITH 1
MAXVALUE 35
NOCYCLE 
CACHE 20;

-- 사용자가 만든 시퀀스가 기록된 데이터 사전
SELECT * FROM USER_SEQUENCES;

SELECT SEQ_CACHE.NEXTVAL 
FROM DUAL;

SELECT SEQ_CACHE.CURRVAL
FROM DUAL;

CREATE SEQUENCE SEQ_TEST
START WITH 4 
INCREMENT BY 1
NOCYCLE
NOCACHE;

INSERT INTO USER_INFO
VALUES(SEQ_TEST.NEXTVAL, '김혁롱', '870630-1542316', '인천광연시 서구' ,'010-15648792');

SELECT 'A' || TO_CHAR(SEQ_TEST.NEXTVAL, '000')      --PK 순서가 문자열로 되어있는 경우 
FROM DUAL;

-- VIEW (보다 : 보기 전용 가상 테이블) 
-- VIEW : SELECT로 실행한 결과를 임시 저장소에 담아 놓는 객체
--    조회에 사용한 SELECT 구문 전체를 저장하여 매번 호출 시
--    해당 쿼리를 실행하여 결과를 보여준다.

-- 실제 결과를 가지고 있지 않아서 외부 사용자나
-- 일반 사용자에게 노출하고 싶지 않은 정보를
-- 숨길 수 있고, 사용자는 원하는 정보를 보다 명확하게 식별할 수 있다.

-- [사용형식]
-- CREATE [OR REPLACE] VIEW 뷰이름
-- AS 서브쿼리 (뷰로 만들 SELECT 구문)

CREATE VIEW V_TEST 
AS SELECT USER_NO, USER_NAME 
FROM USER_INFO;

SELECT * FROM V_TEST;

-- 뷰의 정보가 담긴 데이터 사전
SELECT * FROM USER_VIEWS;

