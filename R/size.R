#' Find size of zotero objects stored locally
#'
#' Find size of zotero objects stored locally
#'
#'
#' @param path Path to local Zotero storage sub-folde, e.g. "/home/user/.mozilla/firefox/mdk7yirc.default/zotero/storage"
#' @return A data.frame (tibble) with ID and size of each item present in the local storage.
#' @export
#' @examples
#'
#' size <- zot_size()

zot_size <- function(path) {
    itemFolders <- list.files(path = path, full.names = TRUE)
    id <- sub(pattern = ".*storage/", replacement = "", x = itemFolders)
    itemSize <- tibble::tibble(ID = id, Size = as.numeric(NA))
    for (i in seq_along(itemFolders)) {
        itemSize$Size[i] <- sum(file.info(list.files(path = itemFolders[i], all.files = TRUE, recursive = TRUE, full.names = TRUE))$size)
    }
    message(paste(nrow(itemSize), "items found, for a total of "),
            utils:::format.object_size(sum(itemSize$Size), "Mb"))
    itemSize %>%
        dplyr::arrange(desc(Size)) %>%
        dplyr::mutate(SizeMb = utils:::format.object_size(Size, "Mb"))
}


