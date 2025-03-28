
<!-- README.md is generated from README.Rmd. Please edit that file -->

# zoteror - Access the Zotero API in R

This package aims to introduce basic functionalities to access the
Zotero API. Its main goal at this stage is to have enough
functionalities to facilitate resizing the storage space used, by
ordering items by attachment size, and by allowing to add items to a
collection if certain criteria are met.

It now tenatively allows to create new Zotero items, and to take a csv
file (or data frame) and import it into Zotero, as long as data are
properly mapped. `zoteror` has function that facilitate giving to
tabular data a structure that can properly be read into Zotero. See at
the bottom of this document for an example \[this is still
work-in-progress and not functional for all item/attribute types\].

# Install

``` r
if(!require("remotes")) install.packages("remotes")
remotes::install_github(repo = "giocomai/zoteror")
```

# What works at this stage

## Create an API key and store credentials

``` r
credentials <- zot_auth(cache = TRUE)
```

The verification code that appears at the end of the URL after
authorization in browser should be input as verification PIN. If the
parameter store is enabled - AuthZot(cache=TRUE) - `zoteror` stores the
credentials in a local file called “zotero_credentials.rds”, which
should be considered confidential since it provides access to a given
Zotero account. If a pre-existing “zotero_credentials.rds” exists, it is
loaded automatically.

N.B. At this stage, it may be easier to actually login on Zotero, go to
the (Feeds/API page in
Settings)\[<https://www.zotero.org/settings/keys>\], and create an API
from there.

### Set options

Instead of inputting `user` and `credentials` each time a function is
run, it is easier to set them with `ZotSetOptions` at the beginning of
every session:

``` r
zot_set_options(user = 12345, credentials = "<API>")
```

The respective parameters can then be left empty (`NULL`, which is
default) when calling functions.

## Create a collection

``` r
key <- zot_create_collection(collection_name = "zoteror") 
```

Creates a new collection by the given name, and outputs its key. If a
collection with the same name already exists, it does not create a new
one, but rather outputs the key of the pre-existing collection.
`zot_create_collection()` requires an API key with write access.

## Extract details of an item

``` r
item <- zot_read_item(id = "<item_id>")
```

Outputs a list with all available information on the item.

## In which collection(s) is an item?

`zot_which_collection` allows to find out in which collection is an
item. If the ID given refers to a ‘child item’ (e.g. a pdf attachment to
a journal article), the function looks for the collection(s) in which
the parent item is included. \[attachments have separate IDs, and are
thus to be found in a collection only if the ‘parent item’ is\]

``` r
item <- zot_wich_collection(id = "<item_id>")
```

## Add an item to a collection

``` r
zot_add_to_collection(id = "<item_id>", collection_id = "<collection_id>")
```

## Calculate size of all locally stored zotero items

``` r
size <- zot_size(path = "/home/user/.zotero/XXXXXX.default/zotero/storage")
# by default, this was inside .mozilla/firefox subdirectory in earlier versions
```

It requires the full path to the local Zotero folder. Outputs size of
stored items in bytes and in human-readable Mb.

# Use case: add all items with attachments bigger than 5MB to a collection

``` r
library("zoteror")
library("dplyr")

zot_set_options(user = 12345, credentials = "<API>") # insert user id and API credentials
size <- zot_size(path = "/home/user/.zotero/XXXXXX.default/zotero/storage") # full path to Zotero storage folder

bigIDs <- size %>%
  filter(Size>5000000) %>%
  pull(ID) # filters items larger than 5MB

big_collection_id <- zot_create_collection(collectionName = "plus5") #creates collection "plus5", and if already existing simply outputs its key

for (i in bigIDs) {
    try(zot_add_to_collection(id = bigIDs$ID[i],
                              collection_id = big_collection_id))
}
```

This adds all items larger tan 5Mb to a collection called “plus5”.
`zot_add_to_collection()` is inside `try` to prevent timeout and other
errors to stop the script. While running the script outputs the title of
items being added to the collection. Currently it goes quite slowly,
thus giving time to stop the script if something odd happens. API would
allow much more efficient ways of bulk changing items; when the package
will work more efficiently, it will still allow to keep the process
artificially slow in order to monitor potential oddities.

# Use case: Import tabular data into Zotero with `zoteror`

In order to make sure your data match Zotero fields for a given item
type, you can first create a csv template for the given type and paste
your data there. Not all columns need to be filled.

``` r
library(zoteror)
zot_create_csv_template(item_type = "book", cache = FALSE) 
#> Warning: The `path` argument of `write_csv()` is deprecated as of readr 1.4.0.
#> ℹ Please use the `file` argument instead.
#> ℹ The deprecated feature was likely used in the zoteror package.
#>   Please report the issue to the authors.
#> This warning is displayed once every 8 hours.
#> Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
#> generated.
#> # A tibble: 0 × 27
#> # ℹ 27 variables: itemType <chr>, title <chr>, creators <chr>,
#> #   abstractNote <chr>, series <chr>, seriesNumber <chr>, volume <chr>,
#> #   numberOfVolumes <chr>, edition <chr>, place <chr>, publisher <chr>,
#> #   date <chr>, numPages <chr>, language <chr>, ISBN <chr>, shortTitle <chr>,
#> #   url <chr>, accessDate <chr>, archive <chr>, archiveLocation <chr>,
#> #   libraryCatalog <chr>, callNumber <chr>, rights <chr>, extra <chr>,
#> #   tags <chr>, collections <chr>, relations <chr>
```

If you enable `cache=TRUE` it will store a csv file in the
`zot_csv_templates` sub-folder of the current working directory.

Translation in other languages of all fields are available with:

``` r
zot_get_item_types_fields(item_type = "book",
                          cache = "FALSE",
                          locale = "it")
#>              field                 localized
#> 1            title                    Titolo
#> 2     abstractNote                  Abstract
#> 3           series                     Serie
#> 4     seriesNumber        Numero della serie
#> 5           volume                    Volume
#> 6  numberOfVolumes          Numero di volumi
#> 7          edition                  Edizione
#> 8            place         Luogo di edizione
#> 9        publisher                   Editore
#> 10            date                      Data
#> 11        numPages               # di Pagine
#> 12        language                    Lingua
#> 13            ISBN                      ISBN
#> 14      shortTitle              Titolo breve
#> 15             url                       URL
#> 16      accessDate                Consultato
#> 17         archive                  Archivio
#> 18 archiveLocation     Posizione in archivio
#> 19  libraryCatalog Catalogo della biblioteca
#> 20      callNumber              Collocazione
#> 21          rights                   Diritti
#> 22           extra                     Extra
```

Internally, Zotero does not store data in a tabular format, so some
transformation will be necessary.

For example, if we have data in this format:

``` r
europe_books <- 
    tibble::tribble(~itemType, ~creators, ~title, ~tags,
                    "book", "Spinelli, Altiero; Rossi, Ernesto", "Il Manifesto di Ventotene", "europe; history")

europe_books
#> # A tibble: 1 × 4
#>   itemType creators                          title                     tags     
#>   <chr>    <chr>                             <chr>                     <chr>    
#> 1 book     Spinelli, Altiero; Rossi, Ernesto Il Manifesto di Ventotene europe; …
```

We need first to transform them in a format that fully mirrors Zotero’s
data structure:

``` r
library(dplyr)

europe_books_zot <- 
    europe_books %>% 
    mutate(creators = zot_convert_creators_to_df_list(creator = creators), 
           tags = zot_convert_tags_to_df_list(tags = tags))
#> Warning: There was 1 warning in `mutate()`.
#> ℹ In argument: `creators = zot_convert_creators_to_df_list(creator =
#>   creators)`.
#> Caused by warning:
#> ! The `x` argument of `as_tibble.matrix()` must have unique column names if
#>   `.name_repair` is omitted as of tibble 2.0.0.
#> ℹ Using compatibility `.name_repair`.
#> ℹ The deprecated feature was likely used in the purrr package.
#>   Please report the issue at <https://github.com/tidyverse/purrr/issues>.

europe_books_zot
#> # A tibble: 1 × 4
#>   itemType creators         title                     tags            
#>   <chr>    <list>           <chr>                     <list>          
#> 1 book     <tibble [2 × 3]> Il Manifesto di Ventotene <tibble [2 × 1]>
```

Having previously set your credentials, you can now upload it to your
Zotero accounts.

``` r
zot_create_items(item_df = europe_books_zot,
                 collection = "europe")
```

\[full support for all data types and more appropriate output will be
added in a future version\]
