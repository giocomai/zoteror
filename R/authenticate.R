#' Authenticate to a Zotero account
#'
#' Authenticate to a Zotero account (get keys)
#'
#' The verification code that appears at the end of the URL after authorization in browser should be input as verification PIN
#'
#' @param
#' @return
#' @export
#' @examples
#'
#' credentials <- AuthZot()

AuthZot <- function() {
    credentials <-
        ROAuth::OAuthFactory$new(consumerKey="16dc29d962b135e62352",
                                 consumerSecret="97f0c56a2a7b7a93cb9e",
                                 requestURL="https://www.zotero.org/oauth/request",
                                 accessURL="https://www.zotero.org/oauth/access",
                                 authURL="https://www.zotero.org/oauth/authorize")
    credentials$handshake()
    credentials
}

