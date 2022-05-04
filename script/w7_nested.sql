use University;

SELECT *
from (select * from student where dept='컴퓨터') cs
WHERE year = 3;

select *
from enrol
where final = (select max(final) FROM enrol WHERE cno = 'C413');

select s.sno, s.year, e.cno
from student s, enrol e
where s.sno=e.sno
order by s.year;

select sno, (select count(cno) from enrol e where s.sno=e.sno) as course_count
from student s
where year = 4;


select s.sno, count(*)
from student s, enrol e
where s.sno=e.sno and year=4
group by e.cno;

select sname
from student
where sno in (select sno from enrol where cno='C413');

select *
from student s, enrol e
where s.sno=e.sno;

select sname
from student s, enrol e
where s.sno=e.sno and cno='C413';


select sname
from student
where sno not in (select sno from enrol where cno='C413');

select sname
from student s, enrol e
where s.sno=e.sno
and cno <> 'C413';

select sname
from student s
where exists (select * from enrol e where e.sno = s.sno and e.cno='C413');

(select sno from student where year = 4)
union 
(select sno from enrol where cno='C413');

select s.sname
from student s, enrol e
where s.sno=e.sno and s.year=4  and e.cno='C413';