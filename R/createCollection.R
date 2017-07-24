#' Create a collection in Zotero
#'
#' Create a collection in Zotero. If a collection by the same name exists, it does not create a new one, but rather outputs the id of that collection.
#'
#' Creating a collection needs an API with write access
#'
#' @param collectionName Name of the collection to be added
#' @param user Zotero userId
#' @param credentials Either an R object created with AuthZot(store = TRUE), or an API secret key with write access created at https://www.zotero.org/settings/keys
#' @return The key of the newly created collection (or of the pre-existing collection, if already one with the same name exists) as a character vector
#' @export
#' @examples
#'
#' key <- ZotCreateCollection(user = 12345, collectionName = "ZoteroRtest", credentials = "<API>")

ZotCreateCollection <- function(collectionName, user = NULL, credentials = NULL) {
    if (is.null(user) == TRUE) {
        user <- ZotOptions("user")
    }
    if (is.null(credentials) == TRUE) {
        credentials <- ZotOptions("credentials")
    }
    if (is.null(credentials)==TRUE|is.null(user)==TRUE) {
        stop("User and credentials must be provided, either as parameter or with the dedicated function ZotSetOptions(user = 12345, credentials = <API>)")
    }
    if (class(credentials)[1]=="OAuth") {
        secret <- credentials$oauthSecret
    } else {
        secret <- credentials
    }
    # Check if collection by the same name exists
    collections <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/users/", user, "/collections/top", "?key=", secret))
    key <- collections$key[grepl(pattern = collectionName, x = collections$data$name)]
    if (length(key)==0) { # if collection does not exist, create it
        response <- httr::POST(url = paste0("https://api.zotero.org/users/", user, "/collections?key=", secret),
                               config = httr::add_headers("Content-Type : application/json",
                                                          paste(sample(c(0:9, letters, LETTERS), 32, replace=TRUE), collapse="")),
                               body = jsonlite::toJSON(x = tribble(~name, collectionName)))
        #parse positive response to extract key
        response <- jsonlite::fromJSON(txt = sub(pattern = ".* kB", replacement = "", x = response))
        key <- response$successful$`0`$data$key
    }
    key
}

