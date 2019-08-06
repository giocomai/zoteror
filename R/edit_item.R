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
#' item <- zot_add_to_collection(id = "<itemId>", collection_id = "<collection_id>")

zot_add_to_collection <- function(id, collection_id, user = NULL, credentials = NULL) {
    if (is.null(user) == TRUE) {
        user <- zot_options("user")
    }
    if (is.null(credentials) == TRUE) {
        credentials <- zot_options("credentials")
    }
    if (class(credentials)[1]=="OAuth") {
        secret <- credentials$oauthSecret
    } else {
        secret <- credentials
    }
    ## get info on item to find item version
    item <- zot_read_item(id = id, user = user, credentials = secret)
    ## if item id given is of an attachment, add the parent to given collection
    if (is.null(item$data$parentItem)==FALSE) {
        id <- item$data$parentItem
        item <- zot_read_item(id = id, user = user, credentials = secret)
    }
    previous_collections <- zot_which_collection(id, user = user, credentials = secret)
    if (length(previous_collections) > 0) {
        collection_id <- c(collection_id, previous_collections)
    }
    message(paste("Adding", item$data$itemType, dQuote(item$data$title)))
    response <- httr::POST(url = paste0("https://api.zotero.org/users/", user, "/items?key=", secret),
                           config = httr::add_headers("Content-Type : application/json",
                                                      paste0("Zotero-Write-Token: ", paste(sample(c(0:9, letters, LETTERS), 32, replace=TRUE), collapse=""))),
                           body = jsonlite::toJSON(x = tibble::tribble(~key, ~version, ~collections,
                                                                       id, item$version, c(collection_id, collection_id))))
    response
}
