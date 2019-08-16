#' Transform a characther vectors of creators (authors, etc.) into a list of properly categorised data frames
#'
#' Transform a characther vectors of creators (authors, etc.) into a list of properly categorised data frames
#'
#'
#' @param creator A character vector (usually, a column in a data frame). Names must be given in the format: "Surname, Name; Surname, Name" (use semicolumn only to separate between multiple authors).
#' @param creator_type Defaults to "author". Must be a character vector of length 1.
#' @return A data frame, with one column for each accepted input for the given item type.
#' @export
#' @examples
#'
#' zot_convert_creators_to_df(creator = "De Gasperi, Alcide")

zot_convert_creators_to_df <- function(creator, creator_type = "author") {
    purrr::map(.x = creator, .f = function(x) {
        temp_author_l <- purrr::map(.x = x,
                                    .f = function(y) stringr::str_split(string = y,
                                                                        pattern = ", ",
                                                                        simplify = TRUE))

        temp_author <- purrr::map_dfr(.x = temp_author_l,
                                      .f = tibble::as_tibble)

        if (ncol(temp_author)==1) {
            tibble::tibble(creatorType = creator_type,
                           firstName = "",
                           lastName = purrr::pluck(.x = temp_author, 1))

        } else {
            tibble::tibble(creatorType = creator_type,
                           firstName = purrr::pluck(.x = temp_author, 2),
                           lastName = purrr::pluck(.x = temp_author, 1))

        }

    })
}


