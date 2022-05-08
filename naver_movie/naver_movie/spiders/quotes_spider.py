import scrapy
from ..items import QuoteItem

class QuotesSpider(scrapy.Spider):
    name = "quotes"

    def start_requests(self):
        urls = [
            'http://quotes.toscrape.com/'
        ]
        for url in urls:
            yield scrapy.Request(url=url, callback=self.parse)

    def parse(self, response):

        items = QuoteItem()
        all_div_quotes = response.css('div.quote')

        for q in all_div_quotes:
            title = q.css('span.text::text').extract()
            author = q.css('.author::text').extract()
            tag = q.css('.tag::text').extract()

            items['title'] = title
            items['author'] = author
            items['tag'] = tag

            yield items