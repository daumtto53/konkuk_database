import pymysql

def open_db():
    conn = pymysql.connect( \
        host='localhost', port=3306, user='cms', password='0512', db='university')
    curs = conn.cursor(pymysql.cursors.DictCursor)
    return conn, curs

def close_db(conn, curs):
    conn.close()
    curs.close()

def simple_select():
    conn, cur = open_db()
    sql = """select sname, dept
                from student;"""
    cur.execute(sql)

    row = cur.fetchone()
    while row:
        print(row['sname'], row['dept'])
        row = cur.fetchone()

    close_db(conn, cur)

def create_table_gen():
    conn, cur = open_db()
    sql = \
        """create table good_score_list (
            id int auto_increment primary key,
            sname varchar(20),
            cname varchar(20),
            midterm int,
            final int,
            medium float,
            enter_date datetime default now()
                on update now()
            );
        """
    cur.execute(sql)
    conn.commit()
    close_db(conn, cur)

def generate_good_score_list():
    conn1, cur1 = open_db()
    conn2, cur2 = open_db()

    sql = \
        """
        select s.sname, c.cname, e.midterm, e.final
        from student s, course c, enrol e
        where s.sno = e.sno and e.cno = c.cno
            and e.midterm >= 85 and e.final >= 85;
        """

    cur1.execute(sql)

    insert_sql = \
                """
                insert
                into good_score_list(sname, cname, midterm, final, medium)
                values(%s, %s, %s, %s, %s)
                """

    buffer = []
    r = cur1.fetchone()
    while r:
        t = (r['sname'], r['cname'], r['midterm'], r['final'], (r['midterm'] + r['final'] / 2.0))
        buffer.append(t)

        if len(buffer) % 2 == 0 :
            cur2.executemany(insert_sql, buffer)
            conn2.commit()
            buffer = []
        r = cur1.fetchone()
        if buffer:
            cur2.executemany(insert_sql, buffer)
            conn2.commit()

    close_db(conn1, cur1)
    close_db(conn2, cur2)


if __name__ == '__main__':
    generate_good_score_list()