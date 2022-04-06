# ![](C:\Users\MINSOO\AppData\Roaming\marktext\images\2022-04-05-23-15-27-image.png)

![](C:\Users\MINSOO\AppData\Roaming\marktext\images\2022-04-05-23-17-33-image.png)

# 5주차 2차시 - DDL

## enter_date datetime on update now()

```sql
create table course (
    ...
    enter_date datetime on update now(),
    update_date datetime on update now()
)
```

* `now()` : SQL 함수

* `on update` : update 할 때

* on delete ` : delete 할 때





## FOREIGN KEY Constraints



error : 

```shell
Error Code: 1046. No database selected Select the default DB \
 to be used by double-clicking its name in the SCHEMAS list in the sidebar.


```

> If you specify a `SET NULL` action, make sure that you have not declared the columns in the child table as `NOT NULL`.



**Primary key를 참조하고 있기에 - NULL 이면 안되는 조건을 달고 있는 것이나 마찬가지.**



* FOREIGN KEY는 Primary Key가 아닐 수도 있다. 단지, UNIQUE KEY 이기만 하면 된다...


