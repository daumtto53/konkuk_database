# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: https://docs.scrapy.org/en/latest/topics/item-pipeline.html


# useful for handling different item types with a single interface
import pymysql
from itemadapter import ItemAdapter


class NaverMoviePipeline(object):

    def __init__(self):
        pass
        self.create_database()
        self.create_table()


    def create_database(self):
        self.open_db()
        sql = "DROP DATABASE IF EXISTS naver_movie"
        self.cur.execute(sql)
        sql = "CREATE DATABASE naver_movie"
        self.cur.execute(sql)
        self.conn.commit()
        self.close_db()


    def create_table(self):
        self.open_db()
        sql = """CREATE TABLE movie (
                id int auto_increment primary key, 
                title varchar(50),
                movie_rate varchar(30), 
                netizen_rate float(5,2), 
                netizen_count int, 
                journalist_score float(3,2),
                journalist_count int,
                scope varchar(40),
                playing_time int,
                opening_date date,
                director varchar(30),
                image varchar(2048),
                enter_date datetime default now()
                    on update now()
                );
            """
        self.cur.execute(sql)
        self.conn.commit()
        self.close_db()


    def open_db(self):
        self.conn = pymysql.connect(host='localhost', port=3306, user='cms', password='0512', db='naver_movie')
        self.cur = self.conn.cursor(pymysql.cursors.DictCursor)

    def close_db(self):
        self.conn.close()
        self.cur.close()

    def init_item(self, item, spider):
        if item['title'] == 'None':
            item['title'] = 'Null'
        if item['movie_rate'] == 'None':
            item['movie_rate'] = 'Null'
        if item['netizen_rate'] == 'None':
            item['netizen_rate'] = 0.0
        if item['journalist_score'] == 'None':
            item['journalist_score'] = 0.0
        if item['netizen_count'] == 'None':
            item['netizen_count'] = 0
        if item['journalist_count'] == 'None':
            item['journalist_count'] = 0
        if item['playing_time'] == 'None':
            item['playing_time'] = 0
        if item['opening_date'] == 'None':
            item['opening_date'] = 'Null'
        if item['image'] == 'None':
            item['image'] = 'Null'


    def insert_db_movie(self, item, spider):
        self.open_db()

        scope_concat = ''
        scope_list = item['scope_list']
        for i in scope_list:
            scope_concat += (i + ',')
        scope_concat = scope_concat[:-1]
        if scope_concat == '':
            scope_concat = None

        director_concat = ''
        director_list = item['director_list']
        for i in director_list:
            director_concat += (i + ',')
        director_concat = director_concat[:-1]
        if director_concat == '':
            director_concat = None
        print("#############")
        print(director_concat)
        print("#############")

        formatted_date = item['opening_date'].strftime('%Y-%m-%d')

        item['netizen_count'] = int(item['netizen_count'].replace(',',''))

        sql = \
            """
            insert
            into movie(title, movie_rate, netizen_rate, netizen_count, journalist_score, journalist_count, scope, \
                playing_time, opening_date, director, image)
            values (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
            """
        tup = (item['title'], item['movie_rate'], round(float(item['netizen_rate']), 2), int(float(item['netizen_count'])),\
                  round(float(item['journalist_score']), 2) , int(float(item['journalist_count'])), \
                  scope_concat,item['playing_time'],formatted_date,director_concat,item['image'])

        self.cur.execute(sql, tup)
        self.conn.commit()
        self.close_db()


    def process_item(self, item, spider):
        self.init_item(item, spider)
        self.insert_db_movie(item, spider)
        return item

# class QuotesPipeline:
#     def process_item(self, item, spider):
#         print("pipeline : " + item['title'][0])
#         return item
