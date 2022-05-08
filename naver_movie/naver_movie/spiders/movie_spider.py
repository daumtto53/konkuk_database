import scrapy
import encodings.idna
import datetime
from ..items import NaverMovieItem

class MovieSpider(scrapy.Spider):
    name = "movie"

    def start_requests(self):
        urls = [
            "https://movie.naver.com/movie/running/current.naver"
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):

        item = NaverMovieItem()
        movie_sels = response.css('ul.lst_detail_t1 > li')

        for movie_sel in movie_sels:
            title = movie_sel.css('.tit > a::text').get(default='')
            # print('title :', title)

            movie_rate = movie_sel.css('.tit > span::text').get(default='RATE NULL')
            # print(movie_rate)

            rate_list = movie_sel.css('div.star_t1 > a > span.num::text').getall()
            # print('netizen_rate:', rate_list)

            netizen_rate = rate_list[0]
            if len(rate_list) == 2:
                journalist_score = rate_list[1]
            else:
                journalist_score = 'None'

            count_list = movie_sel.css('span.num2 > em::text').getall()
            # print('netizen_count:', count_list)

            netizen_count = count_list[0]
            if len(count_list) == 2:
                journalist_count= count_list[1]
            else:
                journalist_count= 'None'


            #일단 pass.
            scope_list = movie_sel.css('.tit_t1+ dd .link_txt > a::text').getall()
            # print(scope_list)

            director_list = movie_sel.css('.tit_t2+ dd a::text').getall()
            # print('director:', director_list)
            director = director_list[0]

            image = movie_sel.css('div.thumb > a > img::attr(src)').get()
            # print(image)

            opening_date_list = movie_sel.css('.info_txt1 .tit_t1+ dd::text').getall()
            for i in range(len(opening_date_list)) :
                opening_date_list[i] = opening_date_list[i].strip()
            # print(opening_date_list)
            playing_time = int(opening_date_list[2].strip('분'))
            opening_date = opening_date_list[3].replace(" ", "").replace("개", "").replace("봉", "")
            opening_date = datetime.datetime.strptime(opening_date, '%Y.%m.%d')
            # print(playing_time)
            # print(opening_date)


            item['title'] = title
            item['movie_rate'] = movie_rate
            item['netizen_rate'] = netizen_rate
            item['journalist_score'] = journalist_score
            item['netizen_count'] = netizen_count
            item['journalist_count'] = journalist_count
            item['scope_list'] = scope_list
            item['director_list'] = director_list
            item['image'] = image
            item['opening_date'] = opening_date
            item['playing_time'] = playing_time

            yield item