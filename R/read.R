#' Read details of a Zotero item
#'
#' Read details of a Zotero item
#'
#'
#' @param id Id code of a zotero item
#' @param user Zotero userId
#' @param credentials Either an R object created with AuthZot(store = TRUE), or an API secret key with write access created at https://www.zotero.org/settings/keys
#' @return A list including all available details on a given item.
#' @export
#' @examples
#'
#' item <- ZotReadItem()

ZotReadItem <- function(id, user = NULL, credentials = NULL) {
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
    jsonlite::fromJSON(txt = paste0("https://api.zotero.org/users/", user, "/items/", id, "?key=", secret))
}

#' Read details of all children of a Zotero item
#'
#' Read details of all children of a Zotero item
#'
#'
#' @param id Id code of a zotero item
#' @param user Zotero userId
#' @param credentials Either an R object created with AuthZot(store = TRUE), or an API secret key with write access created at https://www.zotero.org/settings/keys
#' @return A data.frame including details on all children of a given parent item.
#' @export
#' @examples
#'
#' item <- ZotReadChildren()

ZotReadChildren <- function(id, user = NULL, credentials = NULL) {
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
    jsonlite::fromJSON(txt = paste0("https://api.zotero.org/users/", user, "/items/", id, "/children", "?key=", secret), flatten = TRUE)
}


#' Read IDs of all children of a Zotero item
#'
#' Read IDs of all children of a Zotero item
#'
#'
#' @param id Id code of a zotero item
#' @param user Zotero userId
#' @param credentials Either an R object created with AuthZot(store = TRUE), or an API secret key with write access created at https://www.zotero.org/settings/keys
#' @return A vector including the ID of all children
#' @export
#' @examples
#'
#' item <- ZotReadChildren()

ZotReadChildrenId <- function(id, user = NULL, credentials = NULL) {
    if (is.null(user) == TRUE) {
        user <- ZotOptions("user")
    }
    if (is.null(credentials) == TRUE) {
        credentials <- ZotOptions("credentials")
    }
    ZotReadChildren(id = id, user = user, credentials = credentials)$key
}

#' Extract collections in which given item is included
#'
#' Extract collections in which given item is included
#'
#'
#' @param user Zotero userId
#' @param credentials Either an R object created with AuthZot(store = TRUE), or an API secret key with write access created at https://www.zotero.org/settings/keys
#' @return A charachter vector including all categories in which given item is included.
#' @export
#' @examples
#'
#' categories <- ZotWhichCollection(item = "X1X2X3")

ZotWhichCollection <- function(id, user = NULL, credentials = NULL) {
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
  item <- ZotReadItem(id = id, user = user, credentials = secret)
  if (is.null(item$data$collections)==TRUE) {
      id <- item$data$parentItem
      item <- ZotReadItem(id = id, user = user, credentials = secret)
  }
  item$data$collections
}
