#' Create a collection in Zotero
#'
#' Create a collection in Zotero
#'
#' Creating a collection needs an API with write access
#'
#' @param user Zotero userId
#' @param collectionName Name of the collection to be added
#' @param credentials Either an R object created with AuthZot(store = TRUE), or an API secret key with write access created at https://www.zotero.org/settings/keys
#' @return
#' @export
#' @examples
#'
#' CreateZotCollection(user = 12345, collectionName = "ZoteroRtest", credentials = "<API>")

CreateZotCollection <- function(user, collectionName, credentials) {
    if (class(credentials)[1]=="OAuth") {
        secret <- credentials$oauthSecret
    } else {
        secret <- credentials
    }
    response <- POST(url = paste0("https://api.zotero.org/users/", user, "/collections?key=", secret), config = add_headers("Content-Type : application/json", paste0("Zotero-Write-Token: ", paste0(as.character(randomStrings(n=1, len=16, digits=TRUE, upperalpha=FALSE, loweralpha=TRUE, unique=TRUE, check=TRUE)), as.character(randomStrings(n=1, len=16, digits=TRUE, upperalpha=FALSE, loweralpha=TRUE, unique=TRUE, check=TRUE))))), body = jsonlite::toJSON(x = tribble(~name, collectionName)))
    response
}
