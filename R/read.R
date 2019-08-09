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
#' item <- zot_read_item()

zot_read_item <- function(id, user = NULL, credentials = NULL) {
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
        user <- zot_options("user")
    }
    if (is.null(credentials) == TRUE) {
        credentials <- zot_options("credentials")
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
#' categories <- zot_which_collection(item = "X1X2X3")

zot_which_collection <- function(id, user = NULL, credentials = NULL) {
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
  item <- zot_read_item(id = id, user = user, credentials = secret)
  if (is.null(item$data$collections)==TRUE) {
      id <- item$data$parentItem
      item <- zot_read_item(id = id, user = user, credentials = secret)
  }
  item$data$collections
}

#' Find and show all valid item types
#'
#' Find and show all valid item types
#'
#'
#' @param item_type Defaults to "book". It must correspond to a valid item type. You can chech which item types are valid with the function `zot_get_item_types()`
#' @param cache Logical, defaults to TRUE.  If TRUE, it stores the list of valid item types in a "zot_cache" folder in the current working directory.
#' @param locale Defaults to English. If given, it should correspond to a language code such as "it" or "fr-FR"
#' @return A charachter vector including all categories in which given item is included.
#' @export
#' @examples
#'
#' item_types <- zot_get_item_types()

zot_get_item_types <- function(cache = TRUE, locale = NULL) {
  if (cache == TRUE) {
    dir.create(path = "zot_cache", showWarnings = FALSE)
    if (is.null(locale)==TRUE) {
      file_location <- fs::path("zot_cache", "item_types.rds")
    } else {
      file_location <- fs::path("zot_cache", paste0("item_types-", locale, ".rds"))
    }

    if (fs::file_exists(file_location)) {
      return(readRDS(file_location))
    } else {
      if (is.null(locale)) {
        item_types <- jsonlite::fromJSON(txt = "https://api.zotero.org/itemTypes")
      } else {
        item_types <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypes?locale=", locale))
      }
      readr::write_rds(x = item_types, path = file_location)
    }
  } else {
    if (is.null(locale)) {
      item_types <- jsonlite::fromJSON(txt = "https://api.zotero.org/itemTypes")
    } else {
      item_types <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypes?locale=", locale))
    }
  }
  return(item_types)
}

#' Find and show all valid creator types
#'
#' Find and show all valid creator types
#'
#'
#' @param cache Logical, defaults to TRUE.  If TRUE, it stores the list of valid item types in a "zot_cache" folder in the current working directory.
#' @param locale Defaults to English. If given, it should correspond to a language code such as "it" or "fr-FR"
#' @return A list including all valid creator types for given item type.
#' @export
#' @examples
#'
#' creator_types <- zot_get_creator_types()

zot_get_creator_types <- function(item_type = "book",
                                  cache = TRUE,
                                  locale = NULL) {
  if (cache == TRUE) {
    fs::dir_create(path = "zot_cache")
    if (is.null(locale)==TRUE) {
      file_location <- fs::path("zot_cache", paste0(item_type, "_creator_types.rds"))
    } else {
      file_location <- fs::path("zot_cache", paste0(item_type, "_creator_types", locale, ".rds"))
    }
    if (fs::file_exists(file_location)) {
      return(readr::read_rds(path = file_location))
    } else {
      if (is.null(locale)) {
        creator_types <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypeCreatorTypes?itemType=", item_type))
      } else {
        creator_types <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypeCreatorTypes?itemType=", item_type, "&locale=", locale))
      }
      readr::write_rds(x = creator_types, path = file_location)
    }
  } else {
    if (is.null(locale)) {
      creator_types <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypeCreatorTypes?itemType=", item_type))
    } else {
      creator_types <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypeCreatorTypes?itemType=", item_type, "&locale=", locale))
    }
  }
  return(creator_types)
}


#' Get an item template for a valid item type
#'
#' Get an item template for a valid item type
#'
#'
#' @param item_type Defaults to "book". It must correspond to a valid item type. You can chech which item types are valid with the function `zot_get_item_types()`
#' @param cache Logical, defaults to TRUE. If TRUE, it stores the template in a "zot_cache" folder in the current working directory.
#' @return A list. A template for creating items of the given item_type.
#' @export
#' @examples
#'
#' item_types <- zot_get_item_types()

zot_get_item_template <- function(item_type = "book", cache=TRUE) {
  if (cache == TRUE) {
    dir.create(path = "zot_cache", showWarnings = FALSE)
    template_location <- file.path("zot_cache", paste0(paste("item", item_type, "template", sep = "_"), ".rds"))
    if (file.exists(template_location)) {
      return(readRDS(template_location))
    } else {
      item_template <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/items/new?itemType=", item_type))
      saveRDS(object = item_template, file = template_location)
      return(item_template)
    }
  } else {
    jsonlite::fromJSON(txt = paste0("https://api.zotero.org/items/new?itemType=", item_type))
  }
}




#' Find and show all valid creator types
#'
#' Find and show all valid creator types
#'
#'
#' @param cache Logical, defaults to TRUE.  If TRUE, it stores the list of valid item types in a "zot_cache" folder in the current working directory.
#' @param locale Defaults to English. If given, it should correspond to a language code such as "it" or "fr-FR"
#' @return A list including all valid creator types for given item type.
#' @export
#' @examples
#'
#' creator_types <- zot_get_creator_types()

zot_get_item_types_fields <- function(item_type = "book",
                                      cache = TRUE,
                                      locale = NULL) {
  if (cache == TRUE) {
    if (is.null(locale)==TRUE) {
      file_location <- fs::path("zot_cache", paste0(item_type, "_item_types_fields.rds"))
    } else {
      file_location <- fs::path("zot_cache", paste0(item_type, "_item_types_fields", locale, ".rds"))
    }

    fs::dir_create(path = "zot_cache")
    if (fs::file_exists(file_location)) {
      return(readRDS(file_location))
    } else {
      if (is.null(locale)) {
        item_types_fields <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypeFields?itemType=", item_type))
      } else {
        item_types_fields <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypeFields?itemType=", item_type, "&locale=", locale))
      }
    }
  } else {
    if (is.null(locale)) {
      item_types_fields <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypeFields?itemType=", item_type))
    } else {
      item_types_fields <- jsonlite::fromJSON(txt = paste0("https://api.zotero.org/itemTypeFields?itemType=", item_type, "&locale=", locale))
    }
  }
  return(item_types_fields)
}
