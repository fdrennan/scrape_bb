// scrape_techstars.js

var webPage = require('webpage');
var page = webPage.create();

var fs = require('fs');
var path = 'scrapePage.html'

page.open('https://finance.yahoo.com/quote/AAPL/key-statistics?p=AAPL', function (status) {
  var content = page.content;
  fs.write(path,content,'w')
  phantom.exit();
});