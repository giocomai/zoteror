
<!-- README.md is generated from README.Rmd. Please edit that file -->
ZoteroR - Access the Zotero API in R
====================================

This package aims to introduce basic functionalities to access the Zotero API. Its main goal at this stage is to have enough function to allow facilitate resizing the storage space used, by ordering items by attachment size, and by allowing to add a tag if certain criteria are met.

It may be integrated with a RZotero package if it is actually developed by someone else, or might in time grow and increase its functionalities.

It is under active development, but is not currently functioning.

What works at this stage
========================

### Create an API key and store credentials

``` r
credentials <- AuthZot(store = TRUE)
```

The verification code that appears at the end of the URL after authorization in browser should be input as verification PIN. If the parametere store is enabled - AuthZot(store=TRUE) - zoteroR stores the credentials in a local file called "ZoteroCredentials.rds", which should be considered confidential since it provides access to a given Zotero account. If a pre-existing "ZoteroCredentials.rds" exists, it is loaded automatically.

### Create a collection

``` r
key <- CreateZotCollection(user = 12345, collectionName = "ZoteroRtest", credentials = "<API>")
```

Creates a new collection by the given name, and outputs its key. If a collection with the same name already exists, it does not create a new one, but rather outputs the key of the pre-existing collection. `CreateZotCollection` requires an API key with write access.

### Extract details of an item

``` r
item <- ReadZotItem(user = 12345, id = "<itemId>", credentials = <API>)
```

Outputs a list with all available information on the item.

### Calculate size of all locally stored zotero items

``` r
size <- ZotSize(path = "/home/user/.mozilla/firefox/mdk7yirc.default/zotero/storage")
}
```

It requires the full path to the local Zotero folder. Outputs size of stored items in bytes and in Mb.
