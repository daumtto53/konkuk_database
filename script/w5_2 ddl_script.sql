CREATE database university;
use university;

create table student (
	sno integer primary key,
    sname varchar(10) not null,
    year integer not null default 1,
    dept varchar(10),
    email varchar(30),
    enter_date datetime default now(),
    update_date datetime on update now(),
    constraint year_const check ( year >= 1 and year <= 4)
);

select * from student;

insert into student(sno, sname, year, dept, email)
values 
(100, '나수영', 4, '컴퓨터', 'aaa@naver.com' ),
(200, '이찬수', 3, '전기', 'bbb@naver.com' ),
(300, '정기태', 1, '컴퓨터', 'ccc@naver.com' ),
(400, '송병길', 4, '컴퓨터', 'ddd@naver.com' ),
(500, '박종화', 2, '산공', 'eee@naver.com' );

create table course (
	cno char(4) primary key,
    cname varchar(10),
    credit integer default 3,
    dept varchar(10),
    prname varchar(10),
    enter_date datetime on update now(),
    update_date datetime on update now()
);

select * from course;

insert into course(cno, cname, credit, dept, prname)
values
('C123', '프로그래밍', 3, '컴퓨터', '김성국'),
('C312', '자료구조', 3, '컴퓨터', '황수관'),
('C324', '화일구조', 3, '컴퓨터', '이규찬'),
('C413', '데이터베이스', 3, '컴퓨터', '이일로'),
('E412', '반도체', 3, '전자', '홍봉진') ;

create table enrol (
	sno int,
    cno char(4),
    grade char(1),
    MIDTERM int,
    final int,
    ENTER_DATE datetime on update now(),
    UPDATE_DATE datetime on update now(),
    
    PRIMARY KEY (SNO, CNO),
    FOREIGN KEY (SNO) references STUDENT(SNO) 
		ON UPDATE CASCADE
		ON DELETE CASCADE,
	FOREIGN KEY (CNO) references COURSE(CNO)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	constraint grade_const CHECK (GRADE >= 'A' AND GRADE <= 'F')
);

INSERT INTO enrol(sno, cno, grade, midterm, final)
values
(100, 'C413', 'A', 90, 95),
(100, 'E412', 'A', 95, 90),
(200, 'C123', 'B', 85, 80),
(300, 'C312', 'A', 90, 95),
(300, 'C324', 'C', 75, 75),
(400, 'C312', 'A', 95, 90),
(400, 'C324', 'A', 95, 90),
(400, 'C413', 'B', 80, 85),
(400, 'E412', 'C', 65, 75),
(500, 'C312', 'B', 85, 80) ;
