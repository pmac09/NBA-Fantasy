
authConnect <- function(connection, passcode){

  token <- httr::oauth2.0_access_token(connection$endpoint, connection$app,code=passcode)
  
  return(token)
  
  ## REFERENCE
  # http://rstudio-pubs-static.s3.amazonaws.com/146824_176b45a20b134d4f8450985e8dac399d.html
  # https://stackoverflow.com/questions/49709988/r-yahoo-fantasy-api-permission

  }
  
