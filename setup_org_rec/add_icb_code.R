add_icb_code <- function(df, code_column){
  #' Adds the ICB code associated with the organisation
    #'
  #' This function takes a dataframe and a column containing organisation codes, 
  #' then creates a new column with the ICB code based on a predefined named vector.
  #' The function works is limited to the South East Region
  #'
  #' @param df A data frame containing the data.
  #' @param code_column The name of the column in `df` that contains the lookup codes.
  #'
  #' @return A data frame with an additional column containing the ICB codes.

  
  # Ensure the code_column exists in the dataframe
  if (!(code_column %in% colnames(df))) {
    stop("Column", code_column, "does not exist in the dataframe")
  }
  
  if("icb_code" %in% colnames(df)) {
    stop("Dataframe already has an ICB column")
  }
  
  # setup names lookup as a named vector
  names_lookup <- c(
    #BOB
    'RHW' = 'QU9',
    'RTH' = 'QU9',
    'RWX' = 'QU9',
    'RXQ' = 'QU9',
    'RNU' = 'QU9',
    'QU9' = 'QU9',
    #Frimley
    'RDU' = 'QNQ',
    'QNQ' = 'QNQ',
    #HIOW
    'R1F' = 'QRL',
    'RHM' = 'QRL',
    'RHU' = 'QRL',
    'RN5' = 'QRL',
    'RW1' = 'QRL', #this was Southern Health and is now HIOW trust
    'R1C' = 'QRL', # this code is dead and has been replaced with HIOW RW1
    'RYE' = 'QRL',
    'QRL' = 'QRL',
    #KM
    'RN7' = 'QKS',
    'RPA' = 'QKS',
    'RVV' = 'QKS',
    'RWF' = 'QKS',
    'RXY' = 'QKS',
    'RYY' = 'QKS',
    'QKS' = 'QKS',
    #Surrey
    'RA2' = "QXU",
    'RTK' = "QXU",
    'RTP' = "QXU",
    'RXX' = "QXU",
    'RYD' = "QXU",
    'QXU' = 'QXU',
    #Sussex
    'RPC' = "QNX",
    'RXC' = "QNX",
    'RYR' = "QNX",
    'RX2' = "QNX",
    'QNX' = 'QNX',
    #Region
    'Y59' = 'Y59')
  
  
  df[["icb_code"]] <- unname(names_lookup[as.character(df[[code_column]])])
  df[["icb_code"]][is.na(df[["icb_code"]])] <- "Unknown"
 
  return(df)      
  
}