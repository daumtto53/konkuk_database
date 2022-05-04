CREATE TABLE Book (
bookid INT PRIMARY KEY,
bookname VARCHAR(40),
publisher VARCHAR(40),
price INT
);

CREATE TABLE Customer (
custid INT PRIMARY KEY,
name VARCHAR(40),
address VARCHAR(50),
phone VARCHAR(20)
);

CREATE TABLE Orders (
orderid INT PRIMARY KEY,
custid INT REFERENCES Customer(custid),
bookid INT REFERENCES Book(bookid),
saleprice INT,
orderdate DATE
);

/* Book, Customer, Orders 데이터 생성 */
INSERT INTO Book VALUES(1, '축구의 역사', '굿스포츠', 7000);
INSERT INTO Book VALUES(2, '축구아는 여자', '나무수', 13000);
INSERT INTO Book VALUES(3, '축구의 이해', '대한미디어', 22000);
INSERT INTO Book VALUES(4, '골프 바이블', '대한미디어', 35000);
INSERT INTO Book VALUES(5, '피겨 교본', '굿스포츠', 8000);
INSERT INTO Book VALUES(6, '역도 단계별기술', '굿스포츠', 6000);
INSERT INTO Book VALUES(7, '야구의 추억', '이상미디어', 20000);
INSERT INTO Book VALUES(8, '야구를 부탁해', '이상미디어', 13000);
INSERT INTO Book VALUES(9, '올림픽 이야기', '삼성당', 7500);
INSERT INTO Book VALUES(10, 'Olympic Champions', 'Pearson', 13000);

INSERT INTO Customer VALUES (1, '박지성', '영국 맨체스타', '000-5000-0001');
INSERT INTO Customer VALUES (2, '김연아', '대한민국 서울', '000-6000-0001');
INSERT INTO Customer VALUES (3, '장미란', '대한민국 강원도', '000-7000-0001');
INSERT INTO Customer VALUES (4, '추신수', '미국 클리블랜드', '000-8000-0001');
INSERT INTO Customer VALUES (5, '박세리', '대한민국 대전', NULL);

INSERT INTO Orders VALUES (1, 1, 1, 6000,NULL );
INSERT INTO Orders VALUES (2, 1, 3, 21000, NULL);
INSERT INTO Orders VALUES (3, 2, 5, 8000, NULL);
INSERT INTO Orders VALUES (4, 3, 6, 6000,NULL );
INSERT INTO Orders VALUES (5, 4, 7, 20000, NULL);
INSERT INTO Orders VALUES (6, 1, 2, 12000,NULL);
INSERT INTO Orders VALUES (7, 4, 8, 13000, NULL);
INSERT INTO Orders VALUES (8, 3, 10, 12000,NULL);
INSERT INTO Orders VALUES (9, 2, 10, 7000, NULL);
INSERT INTO Orders VALUES (10, 3, 8, 13000, NULL);


# 3-1
SELECT bookname, price
FROM Book;

# 3-2
SELECT price, bookname
FROM Book;

# 3-3
SELECT bookid, bookname, publisher, price
FROM Book;

SELECT *
FROM Book;

# 3-3
SELECT publisher
FROM Book;

# 3-4
SELECT *
FROM Book
WHERE price < 20000;

# 3-6
SELECT *
FROM Book
WHERE publisher LIKE '굿스포츠' or publisher LIKE '대한미디어';

SELECT *
FROM Book
WHERE publisher IN ('굿스포츠', '대한미디어');

# 3-7
SELECT *
FROM Book
WHERE bookname LIKE '%역사';

SELECT *
FROM Book
WHERE bookname LIKE '_구%';

# 3-12
SELECT *
FROM Book
ORDER BY price ASC, bookname ASC;

SELECT *
FROM Book
ORDER BY price DESC, publisher;

SELECT SUM(saleprice) sum
FROM Orders;

SELECT SUM(saleprice) yeon_sum
FROM Orders
Where custid=2;

SELECT COUNT(*)
FROM Orders
WHERE custid=2;

SELECT name, COUNT(*) as cust_count, SUM(saleprice)
FROM Orders o, Customer c
WHERE o.custid = c.custid
GROUP BY name;

SELECT c.custid, COUNT(*) as cust_count, SUM(saleprice) as cust_saleprice
FROM Orders o, Customer c
WHERE o.custid = c.custid
GROUP BY c.custid;

SELECT c.custid, COUNT(*) as cust_count, SUM(saleprice) as cust_saleprice
FROM Orders o, Customer c
WHERE o.custid = c.custid
GROUP BY c.custid
HAVING count(*) > 2;



SELECT *
from Customer
ORDER BY custid;

SELECT *
from Customer c, Orders o
ORDER BY c.custid, o.orderid;

SELECT *
FROM Customer c, Orders o
WHERE c.custid = o.custid;

# 3-23
SELECT name, saleprice
FROM Customer c, Orders o
WHERE c.custid = o.custid;

SELECT name, SUM(saleprice)
FROM Customer c, Orders o
WHERE c.custid = o.custid
GROUP BY name
ORDER BY name;

SELECT name, bookname
FROM Customer c, Book b, Orders o
WHERE c.custid=o.custid AND b.bookid=o.bookid
ORDER BY name;

SELECT name, bookname
FROM Customer c, Book b, Orders o
WHERE c.custid=o.custid AND b.bookid=o.bookid AND b.price=20000;

SELECT c.name, o.saleprice
FROM Customer c LEFT OUTER JOIN Orders o ON c.custid=o.custid
ORDER BY name, saleprice;

SELECT bookname
FROM Book
WHERE price = (SELECT MAX(price)
				FROM Book
                );
                
SELECT name
FROM Customer c
WHERE c.custid in ( SELECT custid
					FROM Orders
                    );

SELECT name
FROM Customer
WHERE custid IN
	(SELECT custid
	FROM Orders
	WHERE bookid IN (SELECT bookid
				FROM Book
				WHERE publisher='대한미디어'))
					;
                    

SELECT b1.bookname
FROM Book b1
WHERE b1.price > (SELECT avg(b2.price)
				FROM Book b2
                WHERE b2.publisher = b1.publisher);
                
SELECT name
FROM Customer c
WHERE name NOT IN ( SELECT name
					FROM Orders o
                    WHERE o.custid=c.custid);
                    
                    
SELECT name, address
FROM Customer c
WHERE EXISTS ( SELECT *
				FROM Orders o
                WHERE c.custid=o.custid );
