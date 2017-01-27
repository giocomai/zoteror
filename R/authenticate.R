#' Authenticate to a Zotero account
#'
#' Authenticate to a Zotero account (get keys)
#'
#' The verification code that appears at the end of the URL after authorization in browser should be input as verification PIN. If the parametere store is enabled - AuthZot(store=TRUE) - zoteroR stores the credentials in a local file called "ZoteroCredentials.rds", which should be considered confidential since it provides access to a given Zotero account.
#' If a pre-existing "ZoteroCredentials.rds" exists, it is loaded automatically.
#'
#' @param store Logical, defaults to FALSE. If TRUE, it stores the credentials in the working diretory in a file called "ZoteroCredentials.rds", which should be considered confidential since it provides access to a given Zotero account.
#' @return A OAuth object including the Zotero API key.
#' @export
#' @examples
#'
#' credentials <- AuthZot(store=TRUE)

AuthZot <- function(store = FALSE) {
    if (file.exists("ZoteroCredentials.rds")==TRUE) {
        credentials <- read_rds(path = "ZoteroCredentials.rds")
    } else {
        credentials <-
            ROAuth::OAuthFactory$new(consumerKey="16dc29d962b135e62352",
                                     consumerSecret="97f0c56a2a7b7a93cb9e",
                                     requestURL="https://www.zotero.org/oauth/request",
                                     accessURL="https://www.zotero.org/oauth/access",
                                     authURL="https://www.zotero.org/oauth/authorize")
        credentials$handshake()
    }
    if (store == TRUE) {
        saveRDS(object = credentials, file = "ZoteroCredentials.rds")
    }
    credentials
}

