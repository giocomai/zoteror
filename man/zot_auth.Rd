% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/authenticate.R
\name{zot_auth}
\alias{zot_auth}
\title{Authenticate to a Zotero account}
\usage{
zot_auth(cache = TRUE)
}
\arguments{
\item{cache}{Logical, defaults to TRUE If TRUE, it stores the credentials in
the working diretory in a file called "zotero_credentials.rds", which
should be considered confidential since it provides access to a given
Zotero account.}
}
\value{
A OAuth object including the Zotero API key.
}
\description{
Authenticate to a Zotero account (get keys)
}
\details{
The verification code that appears at the end of the URL after authorization
in browser should be input as verification PIN. If the parametere cache is
enabled - zot_auth(cache=TRUE) - zoteroR stores the credentials in a local
file called "zotero_credentials.rds", which should be considered confidential
since it provides access to a given Zotero account. If a pre-existing
"zotero_credentials.rds" exists, it is loaded automatically.
}
\examples{
\dontrun{
credentials <- zot_auth(cache = TRUE)
}
}
