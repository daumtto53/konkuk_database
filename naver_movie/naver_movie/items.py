# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy

class NaverMovieItem(scrapy.Item):

    title = scrapy.Field()
    movie_rate= scrapy.Field()

    netizen_rate = scrapy.Field()
    journalist_score = scrapy.Field()

    netizen_count = scrapy.Field()
    journalist_count = scrapy.Field()

    scope_list = scrapy.Field()
    director_list = scrapy.Field()
    opening_date = scrapy.Field()
    playing_time = scrapy.Field()

    image = scrapy.Field()

class QuoteItem(scrapy.Item):
    title = scrapy.Field()
    tag = scrapy.Field()
    author = scrapy.Field()

