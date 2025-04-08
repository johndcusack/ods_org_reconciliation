update_org_names <- function(df,code_column,name_column,verbose=TRUE) {
  
  #' Update org names
  #' 
  #' This function takes in a dataframe with a column of organisation codes. 
  #' Uses those codes to pull out a json object for each code from the ODS API. (cached_ods_json_list)
  #' Create a table from that API with the organisation code, organisation name. (create_ods_table)
  #' Creates a column with the current organisation name, as recorded by the Organisation Data Service.
  #' Note that this function does not merge or update supereceded trusts, and will use their most recent
  #' name. To update codes to account for any mergers use the replace_with_successor function first.
  #' @param df The dataframe 
  #' @param code_column A string of the column that has the organisation codes being evaluated
  #' @param name_column A string for the column being produced. If this matches an existing
  #' column in the dataframe it will overwrite that column. 
  #' @param verbose Logical. If TRUE, prints the number of replacements made.
  #' 
  #' This function will work on a code containing any organisation code registered in the ODS
  #' It will not work on site codes 
  
  source('setup_r/cached_ods_json_list.R')
  source('setup_r/create_ods_table.R')
  
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("The 'dplyr' package is required but not installed. Please install it.")
  }
  
  if (!code_column %in% names(df)) {
    stop("The specified code_column does not exist in the dataframe.")
  }

  sym_code <-  rlang::sym(code_column)
  sym_name <- rlang::sym(name_column)
  org_list <- cached_ods_json_list(df,code_column)
  ods_table <-  create_ods_table(org_list) |> dplyr::select(-successor_code)
  
  
  org_lookup <- setNames(ods_table$org_name, ods_table$org_code)
  
  df_2 <- df |> 
    dplyr::mutate(
      !!sym_name := dplyr::coalesce(org_lookup[as.character(!!sym_code)], "Unknown")
    )

  if (verbose){
    unknowns <- sum(df_2[[name_column]] == "Unknown", na.rm = TRUE)
    message(unknowns, " unrecognised organisation codes, ",name_column," set to 'Unknown'.")
  }
  return(df_2)
}