% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read.R
\name{zot_get_item_types}
\alias{zot_get_item_types}
\title{Find and show all valid item types}
\usage{
zot_get_item_types(cache = TRUE, locale = NULL)
}
\arguments{
\item{cache}{Logical, defaults to TRUE.  If TRUE, it stores the list of valid
item types in a "zot_cache" folder in the current working directory.}

\item{locale}{Defaults to English. If given, it should correspond to a
language code such as "it" or "fr-FR"}

\item{item_type}{Defaults to "book". It must correspond to a valid item type.
You can chech which item types are valid with the function
`zot_get_item_types()`}
}
\value{
A charachter vector including all categories in which given item is
  included.
}
\description{
Find and show all valid item types
}
\examples{
\dontrun{
item_types <- zot_get_item_types()
}
}
