#' Authenticate to a Zotero account
#'
#' Authenticate to a Zotero account (get keys)
#'
#' The verification code that appears at the end of the URL after authorization
#' in browser should be input as verification PIN. If the parametere cache is
#' enabled - zot_auth(cache=TRUE) - zoteroR stores the credentials in a local
#' file called "zotero_credentials.rds", which should be considered confidential
#' since it provides access to a given Zotero account. If a pre-existing
#' "zotero_credentials.rds" exists, it is loaded automatically.
#'
#' @param cache Logical, defaults to TRUE If TRUE, it stores the credentials in
#'   the working diretory in a file called "zotero_credentials.rds", which
#'   should be considered confidential since it provides access to a given
#'   Zotero account.
#' @return A OAuth object including the Zotero API key.
#' @export
#' @examples
#' \dontrun{
#' credentials <- zot_auth(cache = TRUE)
#' }
zot_auth <- function(cache = TRUE) {
  if (cache == TRUE) {
    file_location <- fs::path("zot_cache", "zotero_credentials.rds")
    if (fs::file_exists(file_location) == TRUE) {
      credentials <- readr::read_rds(path = file_location)
    } else {
      credentials <-
        ROAuth::OAuthFactory$new(
          consumerKey = "16dc29d962b135e62352",
          consumerSecret = "97f0c56a2a7b7a93cb9e",
          requestURL = "https://www.zotero.org/oauth/request",
          accessURL = "https://www.zotero.org/oauth/access",
          authURL = "https://www.zotero.org/oauth/authorize"
        )
      credentials$handshake()
      fs::dir_create(path = "zot_cache")
      readr::write_rds(
        x = credentials,
        path = file_location
      )
    }
  }
  credentials
}
