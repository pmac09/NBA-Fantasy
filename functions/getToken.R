
getToken <- function(cKey, cSecret){
  
  yahoo <- httr::oauth_endpoint(authorize ="https://api.login.yahoo.com/oauth2/request_auth", 
                                access = "https://api.login.yahoo.com/oauth2/get_token", 
                                base_url = "https://fantasysports.yahooapis.com")
  
  myapp <- httr::oauth_app("yahoo", key=cKey, secret = cSecret, redirect_uri = "oob")
  httr::BROWSE(httr::oauth2.0_authorize_url(yahoo, myapp, scope="fspt-r", redirect_uri = myapp$redirect_uri))
  passcode = readline(prompt="Enter Passcode: ") 
  yahoo_token <- httr::oauth2.0_access_token(yahoo,myapp,code=passcode)
  
  return(yahoo_token)
  ## REFERENCE
  # http://rstudio-pubs-static.s3.amazonaws.com/146824_176b45a20b134d4f8450985e8dac399d.html
  # https://stackoverflow.com/questions/49709988/r-yahoo-fantasy-api-permission
}

