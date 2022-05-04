use university;

select *
from good_score_list;

select *, count(sname)
from good_score_list
group by sname
having count(sname);

set sql_safe_updates = 0;
delete n1
from good_score_list n1, good_score_list n2
where n1.id > n2.id and n1.sname = n2.sname;

select *
from good_score_list;

alter table good_score_list AUTO_INCREMENT = 10;