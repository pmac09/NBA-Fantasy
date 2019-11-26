
authRequest <- function(cKey, cSecret){
  
  connection <- list()

  connection$app <- httr::oauth_app("yahoo", key=cKey, secret = cSecret, redirect_uri = "oob")
  connection$endpoint <- httr::oauth_endpoint(authorize ="https://api.login.yahoo.com/oauth2/request_auth", 
                                        access = "https://api.login.yahoo.com/oauth2/get_token", 
                                        base_url = "https://fantasysports.yahooapis.com")

  connection$url <- httr::oauth2.0_authorize_url(connection$endpoint, connection$app, scope="fspt-r", redirect_uri = connection$app$redirect_uri)

  return(connection)
  
  ## REFERENCE
  # http://rstudio-pubs-static.s3.amazonaws.com/146824_176b45a20b134d4f8450985e8dac399d.html
  # https://stackoverflow.com/questions/49709988/r-yahoo-fantasy-api-permission
}
