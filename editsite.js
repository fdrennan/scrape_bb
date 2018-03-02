// scrape_techstars.js
var webPage = require('webpage')
var page = webPage.create();
var fs = require('fs');
var path ='website.html'
page.open('https://www.airbnb.com/s/homes?allow_override%5B%5D=&refinement_paths%5B%5D=%2Fhomes&ne_lat=30.97855687613024&ne_lng=-97.19728718511101&sw_lat=29.90656374808267&sw_lng=-98.21626911870476&search_by_map=true&zoom=9&s_tag=l5HL7UMh&section_offset=2', function (status) {
  var content = page.content;
 fs.write(path,content,'w')
  phantom.exit();
});
