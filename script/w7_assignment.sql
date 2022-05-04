CREATE database medical_care;
use medical_care;

DROP table patient;
DROP table doctor;
DROP table record;

CREATE table patient (
	pno VARCHAR(5) PRIMARY KEY,
	name VARCHAR(15) NOT NULL,
    age INT UNSIGNED,
    gender CHAR(1),
    CHECK (gender='M' or gender='F')
);

CREATE table doctor (
	dno VARCHAR(5) PRIMARY KEY,
    name VARCHAR(15) NOT NULL,
    dept VARCHAR(8),
    gender CHAR(1),
    CHECK (gender='M' or gender='F')
);

CREATE table record (
	id INT auto_increment PRIMARY KEY,
    dno VARCHAR(5),
    pno VARCHAR(5),
    fee INT DEFAULT 0,
    d_date DATE,
    
    FOREIGN KEY(dno) REFERENCES doctor(dno)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY(pno) REFERENCES patient(pno)
		ON UPDATE CASCADE
        ON DELETE CASCADE
);
    

INSERT INTO patient (pno, name, age, gender)
VALUES
('P1', 'Olivia', 15, 'F'),
('P2', 'James', 20, 'M'),
('P3', 'Sophia', 25, 'F'),
('P4', 'Wayne', 30, 'M'),
('P5', 'Emma', 40, 'F');

INSERT INTO doctor (dno, name, dept, gender)
VALUES
('D1', 'Amelia', '치과', 'F'),
('D2', 'Robert', '정신과', 'M'),
('D3', 'Chole', '외과', 'F'),
('D4', 'John', '안과', 'M'),
('D5', 'David', '내과', 'M');

INSERT INTO record (dno, pno, fee, d_date)
VALUES
('D1', 'P1', 5000, '2022-01-10'),
('D1', 'P1', 10000, '2022-03-02'),
('D1', 'P3', 20000, '2022-04-20'),
('D1', 'P1', 5000, '2022-08-21'),

('D2', 'P1', 10000, '2022-06-02'),
('D2', 'P3', 15000, '2022-01-20'),
('D2', 'P2', 5000, '2022-09-01'),
('D2', 'P4', 10000, '2022-10-25'),

('D3', 'P3', 15000, '2022-07-25'),
('D3', 'P3', 30000, '2022-03-20'),
('D3', 'P4', 5000, '2022-02-15'),
('D3', 'P5', 15000, '2022-08-30'),

('D4', 'P3', 10000, '2022-11-05'),
('D4', 'P1', 20000, '2022-12-08'),
('D4', 'P3', 25000, '2022-05-01'),
('D4', 'P1', 15000, '2022-12-23'),

('D5', 'P3', 10000, '2022-06-07'),
('D5', 'P2', 5000, '2022-10-15'),
('D5', 'P1', 10000, '2022-03-15');

select *
from patient;

select *
from doctor;

select *
from record;

SELECT name, age, gender
FROM patient
WHERE (age >= 30 and age < 40) or (gender='F')
ORDER BY age;



SELECT month(d_date) as '월', count(*) as '건수'
FROM record
WHERE (fee <= 10000)
GROUP BY month(d_date)
HAVING count(*) >= 2
ORDER BY count(*) DESC;

SELECT fee, d_date
FROM record
ORDER BY d_date, fee ASC;



# 10000원 이하인 진료 건수 이외의 fee를 건수에 포함 할 때
SELECT month(d_date) as '월', count(*) as '건수'
FROM record
WHERE month(d_date) IN ( SELECT month(d_date)
				FROM record
				WHERE fee <= 10000
				GROUP BY month(d_date)
				HAVING count(*) >= 2 )
GROUP BY month(d_date)
HAVING count(*) >= 2
ORDER BY count(*) DESC;

# 10000원 이하인 진료 건수만 건수에 포함할 때.
SELECT month(d_date) as '월', count(*) as '건수'
FROM record
WHERE (fee <= 10000)
GROUP BY month(d_date)
HAVING count(*) >= 2
ORDER BY count(*) DESC;


# 3-1 , JOIN
SELECT DISTINCT d.name, d.dept
FROM record r, doctor d, patient p
WHERE p.name='Olivia' and r.dno=d.dno and r.pno=p.pno;

# 3-1, SUB
SELECT name, dept
FROM doctor
WHERE dno IN ( SELECT dno
				FROM record
				WHERE pno = (SELECT pno
					FROM patient
					WHERE name='Olivia'));
                    
                    
# 3-2 
SELECT d.dno as '의사번호' , count(*) as '진료횟수'
FROM record r, doctor d, patient p
WHERE p.name='Olivia' and r.dno=d.dno and r.pno=p.pno
GROUP BY d.dno
ORDER BY count(*) DESC;

# 3-3
SELECT d.name, dept
FROM record r, doctor d, patient p
WHERE p.name='Olivia' and r.dno=d.dno and r.pno=p.pno
GROUP BY d.name
HAVING count(*) >= 2;

# 3-3
SELECT name, dept
FROM doctor
WHERE dno IN ( SELECT dno
				FROM record
				WHERE pno = (SELECT pno
							FROM patient
							WHERE name='Olivia')
				GROUP BY dno
                HAVING count(*) >= 2);
                
     
# 3-4
SELECT DISTINCT d.name, dept
FROM patient p, doctor d, record r
WHERE p.pno = r.pno and d.dno = r.dno
	and d.dno in (SELECT d.dno
					FROM record r, doctor d, patient p
					WHERE r.pno=p.pno and r.dno=d.dno and p.name='Olivia')
	and d.dno not in ( SELECT d.dno
						FROM record r, doctor d, patient p
						WHERE r.pno=p.pno and r.dno=d.dno and p.name='James');
                        
# 3-4
SELECT DISTINCT name, dept
FROM doctor
WHERE dno in (SELECT DISTINCT dno
				FROM record
				WHERE pno= (SELECT pno
							FROM patient
							WHERE name='Olivia'))
		and dno not in
				(SELECT DISTINCT dno
					FROM record
					WHERE pno = (SELECT pno
								FROM  patient
								WHERE name='James'));


# 3-5 
SELECT pno, name
FROM patient
WHERE pno IN (SELECT pno
				FROM record
				GROUP BY pno
				HAVING count(DISTINCT dno)=( SELECT count(DISTINCT dno)
												FROM doctor ));
                                                
                                                
                                                
# 2-1
SELECT name, age, gender
FROM patient
ORDER BY age ;

# 2-2
SELECT month(d_date), count(*)
FROM record
WHERE fee <= 10000
GROUP BY month(d_date)
HAVING count(d_date) >=2
ORDER BY count(*) ASC;

# 3-1
SELECT dept, name
FROM doctor d1
WHERE dno in (SELECT dno
				FROM record r1
                WHERE d1.dno = r1.dno and r1.pno = (SELECT pno
													FROM patient
                                                    WHERE name='Olivia'
													));
                                                    
# 3-1
SELECT dept, name
FROM doctor d1
WHERE EXISTS (SELECT *
				FROM record r1
				WHERE d1.dno = r1.dno and r1.pno = (SELECT pno
													FROM Patient WHERE name='Olivia'));
                                                    
                                                    
                                                    
# 3-2
SELECT r1.dno, count(r1.dno)
FROM record r1, doctor d1, patient p1
WHERE r1.pno = p1.pno and r1.dno = d1.dno and p1.name='Olivia'
GROUP BY r1.dno
ORDER BY count(*) DESC;

SELECT r1.dno, count(r1.dno)
FROM record r1
WHERE r1.dno IN (SELECT d1.dno
					FROM doctor d1
                    WHERE r1.pno = (SELECT pno FROM patient WHERE name = 'Olivia'))
GROUP BY r1.dno
ORDER BY count(*) DESC;


# 3-3 실패
SELECT d1.name, d1.dept
FROM doctor d1
WHERE EXISTS ( SELECT d1.dno
				FROM record r1
				WHERE d1.dno = r1.dno and r1.pno = (SELECT pno
														FROM patient
														WHERE name='Olivia')
				GROUP BY d1.dno
                HAVING count(*) >=2 );



# 3-4
SELECT d1.name, d1.dept
FROM doctor d1
WHERE d1.dno IN (SELECT r1.dno
					FROM record r1
					WHERE EXISTS (SELECT 1
									FROM patient p1
									WHERE p1.name='Olivia' and p1.pno = r1.pno))
	and d1.dno NOT IN (SELECT r1.dno
					FROM record r1
					WHERE EXISTS (SELECT 1
									FROM patient p1
									WHERE p1.name='James' and p1.pno = r1.pno));


# 3-5
SELECT pno, name
FROM patient
WHERE pno IN (SELECT pno
				FROM record
				GROUP BY pno
				HAVING count(distinct dno) = (SELECT count(distinct dno)
												FROM doctor));