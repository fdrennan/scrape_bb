scrapeJs = function(siteName = "http://www.scoreboard.com/mlb/results/", outputName = "scoreboard.html") {
  editSite=read.table("scrapePage.txt", sep = "\t", stringsAsFactors = FALSE, header = FALSE)
  editSite[2,1] = paste0("var webPage = require('webpage')")
  editSite[4,1] = paste0("var fs = require('fs');")
  editSite[5,1] = paste0("var path ='",outputName,"'")
  editSite[6,1]=paste0("page.open('", siteName,"', function (status) {")
  editSite[8,1] = paste0(" fs.write(path,content,'w')")
  write.table(editSite, 'editsite.js',quote = FALSE,row.names = FALSE,col.names = FALSE )
  system("./phantomjs editsite.js") # Crawls page using scrapePage.js (where you change the page name) . Find that file. 
}