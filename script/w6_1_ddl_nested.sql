use university;
select * from student;

update student
set dept='컴퓨터'
where sno=200;

select * from student;

select sname
from student s
where exists (select *
				from enrol e
                where e.sno = s.sno and e.cno='C413');
                
(select *
from student
where year=1)
union
(select *
from enrol
where cno='C324');

select *
from student;

select *
from enrol;

select sno, ( 
	select count(cno)
	from enrol e
    where s.sno = e.sno
) as count
from student s
where year=4;