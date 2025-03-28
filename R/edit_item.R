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
#' \dontrun{
#' item <- zot_add_to_collection(id = "<itemId>", collection_id = "<collection_id>")
#' }
zot_add_to_collection <- function(id, collection_id, user = NULL, credentials = NULL) {
  if (is.null(user) == TRUE) {
    user <- zot_options("user")
  }
  if (is.null(credentials) == TRUE) {
    credentials <- zot_options("credentials")
  }
  if (class(credentials)[1] == "OAuth") {
    secret <- credentials$oauthSecret
  } else {
    secret <- credentials
  }
  ## get info on item to find item version
  item <- zot_read_item(id = id, user = user, credentials = secret)
  ## if item id given is of an attachment, add the parent to given collection
  if (is.null(item$data$parentItem) == FALSE) {
    id <- item$data$parentItem
    item <- zot_read_item(id = id, user = user, credentials = secret)
  }
  previous_collections <- zot_which_collection(id, user = user, credentials = secret)
  if (length(previous_collections) > 0) {
    collection_id <- c(collection_id, previous_collections)
  }
  message(paste("Adding", item$data$itemType, dQuote(item$data$title)))
  response <- httr::POST(
    url = paste0("https://api.zotero.org/users/", user, "/items?key=", secret),
    config = httr::add_headers(
      "Content-Type : application/json",
      paste0("Zotero-Write-Token: ", paste(sample(c(0:9, letters, LETTERS), 32, replace = TRUE), collapse = ""))
    ),
    body = jsonlite::toJSON(x = tibble::tribble(
      ~key, ~version, ~collections,
      id, item$version, c(collection_id, collection_id)
    ))
  )
  response
}


#' Create a template to facilitate import of csv files
#'
#' Create a template to facilitate import of csv files
#'
#'
#' @param item_type Defaults to "book". It must correspond to a valid item type.
#'   You can chech which item types are valid with the function
#'   `zot_get_item_types()`
#' @param cache Logical, defaults to TRUE. If TRUE, it stores the template in a
#'   "zot_cache" folder in the current working directory.
#' @return A data frame, with one column for each accepted input for the given
#'   item type.
#' @export
#' @examples
#'
#' book_template_df <- zot_create_csv_template(item_type = "book")
#' book_template_df
zot_create_csv_template <- function(item_type = "book", cache = TRUE) {
  item <- zot_get_item_template(item_type = item_type, cache = cache)

  item_df <- tibble::as_tibble(
    matrix(
      data = as.character(vector()),
      nrow = 0,
      ncol = length(names(item)),
      dimnames = list(c(), names(item))
    ),
    stringsAsFactors = FALSE
  )
  fs::dir_create(path = "zot_csv_templates")
  readr::write_csv(
    x = item_df,
    path = fs::path(
      "zot_csv_templates",
      paste0(
        item_type,
        "_template.csv"
      )
    )
  )
  return(item_df)
}


#' Create new items from a data frame
#'
#' Create new Zotero items from a data frame
#'
#' @param item_df A data frame representing new items. Column names must
#'   correspond to [zot_get_item_template()] for the given item type.
#' @param user Zotero userId
#' @param credentials Either an R object created with [zot_auth()], or
#'   an API secret key with write access created at
#'   \url{https://www.zotero.org/settings/keys)}
#' @return Nothing, used for its side effects (creates new items on Zotero)
#' @export
#' @examples
#' \dontrun{
#' item <- zot_create_items(item_df)
#' }
zot_create_items <- function(item_df,
                             collection = NULL,
                             user = NULL,
                             credentials = NULL) {
  if (is.null(user) == TRUE) {
    user <- zot_options("user")
  }
  if (is.null(credentials) == TRUE) {
    credentials <- zot_options("credentials")
    if (is.null(credentials)) {
      credentials <- zot_auth()
    }
  }
  if (class(credentials)[1] == "OAuth") {
    secret <- credentials$oauthSecret
  } else {
    secret <- credentials
  }

  if (is.null(collection) == FALSE) {
    item_df <- item_df %>%
      dplyr::mutate(collections = list(list(zot_create_collection(collection_name = collection, user = user, credentials = credentials))))
  }

  for (i in 1:nrow(item_df)) {
    temp_item_df <- item_df %>%
      slice(i)

    response <- httr::POST(
      url = paste0("https://api.zotero.org/users/", user, "/items?key=", secret),
      config = httr::add_headers(
        "Content-Type : application/json",
        paste0("Zotero-Write-Token: ", paste(sample(c(0:9, letters, LETTERS), 32, replace = TRUE), collapse = ""))
      ),
      body = jsonlite::toJSON(x = temp_item_df, auto_unbox = TRUE)
    )
    message(response)
  }
}
