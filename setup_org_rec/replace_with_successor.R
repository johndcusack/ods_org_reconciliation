replace_with_successor <- function(df,code_column,verbose=TRUE) {
  
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
  
  source('setup_org_rec/cached_ods_json_list.R')
  source('setup_org_rec/create_ods_table.R')
  
  if (!requireNamespace("dplyr", quietly = TRUE)) {
    stop("The 'dplyr' package is required but not installed. Please install it.")
  }
  
  if (!code_column %in% names(df)) {
    stop("The specified code_column does not exist in the dataframe.")
  }

  sym_column <-  rlang::sym(code_column)
  org_list <- cached_ods_json_list(df,code_column)
  ods_table <-  create_ods_table(org_list)
  
  ods_table <- ods_table |> dplyr::select(-org_name)

  df_2 <- df |> dplyr::left_join(ods_table, by = join_by(!!sym_column == org_code))
  
  df_2 <- df_2 |> dplyr::mutate(!!sym_column := if_else(successor_code == "None",
                                                        !!sym_column,
                                                        successor_code))
  
  df_2 <-  df_2 |> dplyr::select(-successor_code)
  
  if (verbose){
    replacements <- sum(df_2[[code_column]] != df[[code_column]], na.rm = TRUE)
    message(replacements, " organisation codes were replaced with successors.")
  }
  return(df_2)
  
}