#' Read details of a Zotero item
#'
#' Read details of a Zotero item
#'
#'
#' @param user Zotero userId
#' @return A list including all available details on a given item.
#' @export
#' @examples
#'
#' item <- ZotReadItem()

ZotReadItem <- function(user, id, credentials) {
    if (class(credentials)[1]=="OAuth") {
        secret <- credentials$oauthSecret
    } else {
        secret <- credentials
    }
    jsonlite::fromJSON(txt = paste0("https://api.zotero.org/users/", user, "/items/", id, "?key=", secret))
}

