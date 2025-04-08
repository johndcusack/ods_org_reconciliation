add_short_org_names <- function(df, code_column,new_col_name){
  #' Add short org names
    #'
  #' This function takes a dataframe and a column containing organisation codes, 
  #' then creates a new column with shortened organization names based on a predefined named vector.
  #' The function works on both ICB and provider codes, but only for the South East region.
  #' The function requires the user to provide a new column name so that it can be applied more than
  #' once to the same dataframe without conflicts (allowing for separate provider and ICB columns)
  #'
  #' @param df A data frame containing the data.
  #' @param code_column The name of the column in `df` that contains the lookup codes.
  #' @param new_col_name The name for the new column to be created with shortened organization names.
  #'
  #' @return A data frame with an additional column containing the shortened organization names.
  #'
  #' @examples
  #' df <- data.frame(org_code = c('QU9', 'RHW', 'QRL'))
  #' df <- fn_short_org_names(df, 'org_code', 'short_org_name')
  #' print(df)
  
  # Ensure the code_column exists in the dataframe
  if (!(code_column %in% colnames(df))) {
    stop(paste("Column", code_column, "does not exist in the dataframe"))
  }
  
  
  # setup names lookup as a named vector
  names_lookup <- c(
    #BOB
    'QU9' = 'BOB ICS',
    'RHW' = 'RBH',
    'RTH' = 'OUH',
    'RWX' = 'Berks Health',
    'RXQ' = 'BHT',
    'RNU' = 'OHealth',
    #Frimley
    'QNQ' = 'Frimley ICS',
    'RDU' = 'Frimley',
    #HIOW
    'QRL' = 'HIOW ICS',
    'R1F' = 'IOW',
    'RHM' = 'UHSotn',
    'RHU' = 'PHU',
    'RN5' = 'HHFT',
    'RW1' = 'HIOW FT',#this was Southern Health and is now HIOW trust
    'R1C' = 'Solent', # this code is dead and has been replaced with HIOW RW1
    'RYE' = 'SCAS',
    #KM
    'QKS' = 'KM ICS', 
    'RN7' = 'DGT',
    'RPA' = 'MedwayFT',
    'RVV' = 'EKH',
    'RWF' = 'MTW',
    'RXY' = 'KM SCP',
    'RYY' = 'KCH',
    #Surrey
    'QXU' = 'Surrey ICS',
    'RA2' = 'RSCH',
    'RTK' = 'ASP',
    'RTP' = 'SASH',
    'RXX' = 'SBorders',
    'RYD' = 'SECAMB',
    #Sussex
    'QNX' = 'Sussex ICS',
    'RPC' = 'QVH',
    'RXC' = 'ESH',
    'RYR' = 'UHSx',
    'RX2' = 'SxPartnership')
  
  df[[new_col_name]] <- sapply(df[[code_column]], 
                               function(x) {
                                 if (x %in% names(names_lookup)) {
                                   names_lookup[x]
                                 } else {
                                   "Unknown" # Default value for unknown codes
                                 }
                               })  
  return(df)      
  
}