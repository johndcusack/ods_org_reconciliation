replace_with_successor <- function(df, code_column, verbose = TRUE) {
  #' Replace with successor
  #'
  #' This function takes in a dataframe with a column of organisation codes. 
  #' Uses those codes to pull out a json object for each code from the ODS API. (cached_ods_json_list)
  #' Create a table from that API with the organisation code, organisation name and any successor code. (create_ods_table)
  #' Compares the organisation codes in the original dataframe's code column to the table created above. 
  #' If the code has been superseded the code is replaced with the successor organisation otherwise 
  #' it remains the same.
  #' @param df The dataframe 
  #' @param code_column A string of the column that has the organisation codes being evaluated
  #' @param verbose Logical. If TRUE, prints the number of replacements made.
  #' 
  #' This function will work on a code containing any organisation code registered in the ODS
  #' It will not work on site codes 
  
  source("setup_org_rec/cached_ods_json_list.R")
  source("setup_org_rec/create_ods_table.R")
  
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("The 'dplyr' package is required but not installed.")
  }
  
  if (!code_column %in% names(df)) {
    stop("The specified code_column does not exist in the dataframe.")
  }
  
  # Build lookup table
  org_list <- cached_ods_json_list(df, code_column)
  ods_table <- create_ods_table(org_list) |>
    dplyr::select(org_code, successor_code)
  
  # Join using base R string tools and tidyverse function
  # setNames is telling R to treat the code_column as if it was called "org_code"
  # allowing us to pass a column in dynamically but treat it as a string for the 
  # purpose of the by part of left_join.
  df_2 <- dplyr::left_join(df, ods_table, by = setNames("org_code", code_column))
  
  # Replace old code with successor code if it exists and isn't "None"
  # create TRUE/FALSE vector where TRUE indicates there is a successor code to update
  replacement_mask <- !is.na(df_2$successor_code) & df_2$successor_code != "None"
  # where replacement mask is TRUE rewrite the contents of the code column with the successor code 
  df_2[[code_column]][replacement_mask] <- df_2$successor_code[replacement_mask]
  
  # Drop helper column
  df_2 <- dplyr::select(df_2, -successor_code)
  
  # Feedback
  if (verbose) {
    replacements <- sum(df[[code_column]] != df_2[[code_column]], na.rm = TRUE)
    message(replacements, " organisation codes were replaced with successors.")
  }
  
  return(df_2)
}