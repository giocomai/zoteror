
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ZoteroR - Access the Zotero API in R

This package aims to introduce basic functionalities to access the
Zotero API. Its main goal at this stage is to have enough function to
facilitate resizing the storage space used, by ordering items by
attachment size, and by allowing to add items to a collection if certain
criteria are met.

It is currently under active development and is not yet fully
functional.

# Install

``` r
if(!require(remotes)) install.packages("remotes")
remotes::install_github(repo = "giocomai/zoteroR")
```

# What works at this stage

### Create an API key and store credentials

``` r
credentials <- zot_auth(cache = TRUE)
```

The verification code that appears at the end of the URL after
authorization in browser should be input as verification PIN. If the
parameter store is enabled - AuthZot(cache=TRUE) - zoteroR stores the
credentials in a local file called “ZoteroCredentials.rds”, which should
be considered confidential since it provides access to a given Zotero
account. If a pre-existing “ZoteroCredentials.rds” exists, it is loaded
automatically.

N.B. At this stage, it may be easier to actually login on Zotero, go to
the (Feeds/API page in
Settings)\[<https://www.zotero.org/settings/keys>\], and create an API
from there.

### Set options

Instead of inputting `user` and `credentials` each time a function is
run, it is easier to set them with `ZotSetOptions` at the beginning of
every session:

``` r
ZotSetOptions(user = 12345, credentials = "<API>")
```

The respective parameters can then be left empty (`NULL`, which is
default) when calling
functions.

### Create a collection

``` r
key <- zot_create_collection(user = 12345, collectionName = "ZoteroR", credentials = "<API>")
```

Creates a new collection by the given name, and outputs its key. If a
collection with the same name already exists, it does not create a new
one, but rather outputs the key of the pre-existing collection.
`CreateZotCollection` requires an API key with write access.

### Extract details of an item

``` r
item <- zot_read_item(id = "<itemId>")
```

Outputs a list with all available information on the item.

### In which collection(s) is an item?

`ZotWhichCollection` allows to find out in which collection is an item.
If the ID given refers to a ‘child item’ (e.g. a pdf attachment to a
journal article), the function looks for the collection(s) in which the
parent item is included. \[attachments have separate IDs, and are thus
to be found in a collection only if the ‘parent item’
is\]

``` r
item <- zot_wich_collection(id = "<itemId>")
```

### Add an item to a collection

``` r
zot_add_to_collection(id = "<itemId>", collectionId = "<collectionId>")
```

### Calculate size of all locally stored zotero items

``` r
size <- zot_size(path = "/home/user/.mozilla/firefox/XXXXXX.default/zotero/storage")
```

It requires the full path to the local Zotero folder. Outputs size of
stored items in bytes and in human-readable
Mb.

## Use case: add all items with attachments bigger than 5MB to a collection

``` r
library("zoteroR")
zot_set_options(user = 12345, credentials = "<API>") # insert user id and API credentials
size <- zot_size(path = "/home/g/.mozilla/firefox/XXXXXXX.default/zotero/storage") # full path to Zotero storage folder

bigIDs <- size %>% filter(Size>5000000) %>% select(ID) #filters items larger than 5MB

big_collection_id <- zot_create_collection(collectionName = "plus5") #creates collection "plus5", and if already existing simply outputs its key

for (i in seq_along(bigIDs$ID)) {
    try(zot_add_to_collection(id = bigIDs$ID[i], collectionId = big_collection_id))
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

# Create new item
