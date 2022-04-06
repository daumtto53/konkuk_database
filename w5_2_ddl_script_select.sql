use university;

select *
from student
where dept = '컴퓨터';

select *
from student
where not (year = 3 or dept = '컴퓨터');

select *
from student
order by year, sno;

select *
from student
where sname like '나%';

select distinct year
from student
order by year desc;

select *
from student;

update student
set dept = null
where sno = 200;

select *
from student
where dept is not null;

select *
from student
where dept = '컴퓨터';

select *
from student;

select *
from student
where update_date is null;

select *
from student
where update_date > '2022-04-01';