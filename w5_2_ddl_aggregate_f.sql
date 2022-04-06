use university;

select count(sno)
from student;

select *
from enrol;

select min(midterm), max(midterm)
from enrol; 

select sno, min(midterm), max(midterm)
from enrol
group by sno;

select avg(final) as final_avg
from enrol
where cno = 'C413';


select cno, count(*)
from enrol
where final >= 80
group by cno;


select cno, avg(final) as final_avg
from enrol
where final >= 80
group by cno;

# having 사용
select cno, avg(final) as final_avg
from enrol
where final >= 80
group by cno
having avg(final) >= 90;


select cno, count(*)
from enrol
group by cno
order by count(*);

select cno, avg(final) as final_avg
from enrol
where final >= 80
group by cno
having count(*) > 1;

/* 
	서브쿼리에 Alias를 주지 않았을 경우 발생하는 에러 발생 가능성
*/
select count(*)
from (
select cno, avg(final) as final_avg
from enrol
where final >= 80
group by cno
having avg(final) >= 90
) A;

select cno, avg(midterm)
from enrol
where final >= 80;

select cno, avg(midterm), count(*)
from enrol
group by cno
order by count(*) desc;


select cno, avg(midterm)
from enrol
where final >= 80
group by cno
order by count(*) desc, cno;