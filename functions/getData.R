

getData <- function(vToken, url){
  pageData <- GET(url, add_headers(Authorization=paste0("Bearer ", vToken$access_token)))
  XMLdata <- content(pageData, as="parsed", encoding="utf-8")
  doc <- xmlTreeParse(XMLdata, useInternal=TRUE)
  vList <- xmlToList(xmlRoot(doc))
  return(vList)
}