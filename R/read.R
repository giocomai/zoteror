#' Read details of a Zotero item
#'
#' Read details of a Zotero item
#'
#'
#' @param user UserId
#' @return
#' @export
#' @examples
#'
#' item <- ReadZotItem()

ReadZotItem <- function(user, id, credentials) {
    jsonlite::fromJSON(txt = paste0("https://api.zotero.org/users/", user, "/items/", id, "?key=", credentials$oauthSecret))
}

