#' Transform a characther vectors of creators (authors, etc.) into a list of properly categorised data frames
#'
#' Transform a characther vectors of creators (authors, etc.) into a list of properly categorised data frames
#'
#'
#' @param item_type Defaults to "book". It must correspond to a valid item type. You can chech which item types are valid with the function `zot_get_item_types()`
#' @param cache Logical, defaults to TRUE. If TRUE, it stores the template in a "zot_cache" folder in the current working directory.
#' @return A data frame, with one column for each accepted input for the given item type.
#' @export
#' @examples
#'
#' zot_convert_creators_to_df(creator = "De Gasperi, Alcide")

zot_convert_creators_to_df <- function(creator) {
    purrr::map(.x = creator, .f = function(x) {
        temp_author_l <- purrr::map(.x = x,
                                    .f = function(y) stringr::str_split(string = y,
                                                                        pattern = ", ",
                                                                        simplify = TRUE))

        temp_author <- purrr::map_dfr(.x = temp_author_l,
                                      .f = tibble::as_tibble)

        if (ncol(temp_author)==1) {
            tibble::tibble(creatorType = "author",
                           firstName = "",
                           lastName = purrr::pluck(.x = temp_author, 1))

        } else {
            tibble::tibble(creatorType = "author",
                           firstName = purrr::pluck(.x = temp_author, 2),
                           lastName = purrr::pluck(.x = temp_author, 1))

        }

    })
}


