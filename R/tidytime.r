#' tidytime: tidying functions for time series data
#'
#' tidytime provides functions for tidying time series data.
#' \code{tidytime} supports major time series formats including:
#'  \item builtin time.series (ts)
#'  \item zoo
#'  \item xts
#'
#' @docType package
#' @name tidytime
#'
#' @seealso \url{https://cran.r-project.org/web/packages/zoo/index.html}
#' @seealso \url{https://cran.r-project.org/web/packages/xts/index.html}
#'
NULL

#' Tidy time series objects.
#'
#' This function is an S3 generic.
#'
#' @param x time series object to tidy
#' @param ... extra arguments
#'
#' @return \code{tidytime} returns a \code{data_frame} with one row for each
#'   observation in each series, with the following columns:
#'
#'   \item{index}{Index (usually date)}
#'   \item{series}{Name of the series}
#'   \item{value}{Value of the observation}
#'
#' @export
tidytime <- function(x, ...) { UseMethod("tidytime") }

#' Tidier for NULL object
#'
#' @param x time series object to tidy
#' @param ... extra arguments
#'
#' @export
tidytime.NULL <- function(x, ...) {
  dplyr::data_frame()
}

#' Default tidytime method
#'
#' @param x time series object to tidy
#' @param ... extra arguments
#'
#' @export
tidytime.default <- function(x, ...) {
  warning(paste("No method for tidying an S3 object of class",
                class(x), ", using as.data.frame"))
  tbl_df(as.data.frame(x))

}

#' Tidier for zoo object
#'
#' identical to \code{broom::tidy.zoo} except this tidier returns a \code{tbl_df}
#'
#' @param x time series object to tidy
#' @param ... extra arguments
#'
#' @return tbl_df
#'
#' @examples
#'   x <- zoo::zoo(rnorm(5),
#'                 as.Date("2003-02-01") +
#'                  c(1, 3, 7, 9, 14) - 1)
#'   tidytime(x)
#'
#' @export
tidytime.zoo <- function(x, ...) {
  ret <- data.frame(as.matrix(x), index = zoo::index(x))
  ret <- tidyr::gather(ret, series, value, -index)
  ret <- dplyr::tbl_df(ret)
  ret
}

#' Tidier for time series object
#'
#' @param x time series object to tidy
#' @param ... extra arguments
#'
#' @return tbl_df
#'
#' @examples
#' class(uspop)
#' tidytime(uspop)
#'
#' @export
tidytime.ts <- function(x, ...) {

  ret <- data.frame(data.frame(x), index = zoo::index(x))
  ret <- tidyr::gather(ret, series, value, -index)
  ret <- dplyr::tbl_df(ret)

  ret
}

#' Tidier for xts object
#'
#' @param x time series object to tidy
#' @param ... extra arguments
#'
#' @return tbl_df
#'
#' @examples
#' if (require(xts)) {
#'   data(sample_matrix)
#'   sample.xts <- as.xts(sample_matrix)
#'   tidytime(sample.xts)
#' }
#'
#' @export
tidytime.xts <- tidytime.zoo
