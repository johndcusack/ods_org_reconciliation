#' Cached ODS JSON List
#'
#' Returns a memoised version of the `extract_ods_json_list()` function
#' to cache API responses during an R session.
#'
#' @return A memoised function that behaves like `extract_ods_json_list()`.
#' @export
cached_ods_json_list <- memoise::memoise(extract_ods_json_list)