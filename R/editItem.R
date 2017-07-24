#' Add item to a collection
#'
#' Add item to a collection
#'
#' @param id Id code of a zotero item
#' @param user Zotero userId
#' @param credentials Either an R object created with AuthZot(store = TRUE), or an API secret key with write access created at https://www.zotero.org/settings/keys
#' @return A list including all available details on a given item.
#' @export
#' @examples
#'
#' item <- ZotAddToCollection(id = "<itemId>", collectionId = "<collectionId>")

ZotAddToCollection <- function(id, collectionId, user = NULL, credentials = NULL) {
    if (is.null(user) == TRUE) {
        user <- ZotOptions("user")
    }
    if (is.null(credentials) == TRUE) {
        credentials <- ZotOptions("credentials")
    }
    if (class(credentials)[1]=="OAuth") {
        secret <- credentials$oauthSecret
    } else {
        secret <- credentials
    }
    ## get info on item to find item version
    item <- ZotReadItem(id = id, user = user, credentials = secret)
    ## if item id given is of an attachment, add the parent to given collection
    if (is.null(item$data$parentItem)==FALSE) {
        id <- item$data$parentItem
        item <- ZotReadItem(id = id, user = user, credentials = secret)
    }
    previousCollections <- ZotWhichCollection(id, user = user, credentials = secret)
    if (length(previousCollections) > 0) {
        collectionId <- c(collectionId, previousCollections)
    }
    message(paste("Adding", item$data$itemType, dQuote(item$data$title)))
    response <- httr::POST(url = paste0("https://api.zotero.org/users/", user, "/items?key=", secret),
                           config = httr::add_headers("Content-Type : application/json",
                                                      paste0("Zotero-Write-Token: ", paste(sample(c(0:9, letters, LETTERS), 32, replace=TRUE), collapse=""))),
                           body = jsonlite::toJSON(x = tribble(~key, ~version, ~collections, id, item$version, c(collectionId, collectionId))))
    response
}
