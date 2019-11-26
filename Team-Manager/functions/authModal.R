
authModal <- function(auth) {
  modalDialog(
    a("Yahoo Authentication", href=auth$connection$url, target="_blank"),
    textInput(inputId = "txtPasscode", label = "Enter Yahoo Authentication Passcode"),
    textInput(inputId = "txtPassword", label = NULL),
    footer = tagList(actionButton(inputId = "btnAuthConnect", label = "Connect"))
  )
}