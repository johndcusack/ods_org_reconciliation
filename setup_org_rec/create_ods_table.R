create_ods_table <- function(json_list) {
#' Create ODS table
#' 
#' @description This function takes in a list of json files extracted from 
#' the Organisational Data Service API such as the one created by cached_ods_json_list.R 
#' It returns a tibble. The tibble has three fields: 
#' The organisation code, 
#' The current organisation name as registered with the ODS
#' The successor code for the organisation, if that code has been retired and replaced or merged

  if (!requireNamespace("tidyr", quietly = TRUE)) {
    stop("The 'tidyr' package is required but not installed. Please install it.")
  }
  
  if (!requireNamespace("stringr", quietly = TRUE)) {
    stop("The 'stringr' package is required but not installed. Please install it.")
  }

output_list <- vector("list",length = length(json_list))

for (i in seq_along(json_list)){
json_data <- json_list[[i]]
json_data_df <- tibble(json_data)

org_code <- json_data_df |> 
  unnest_wider(json_data) |>
  unnest_wider(OrgId) |> 
  pull(extension) |> 
  first()

org_name <- json_data_df |> 
  hoist(json_data,"Name") |> 
  pull(Name) |> 
  first() |> 
  str_to_title() |> 
  str_replace("Nhs","NHS")

successor_check <- json_data_df |> 
  unnest_wider(json_data) 
  
successor_check <-  if (!'Succs' %in% names(successor_check)) {
  tibble()
  } else{
  successor_check |> 
    select(Succs) |>   
    unnest_wider(Succs) |>
    unnest_longer(Succ) |> 
    unnest_wider(Succ) |> 
    unnest_wider(Target) |> 
    unnest_wider(OrgId) |> 
    filter(Type == 'Successor') }

successor_code <- if (nrow(successor_check) == 1){
  pull(successor_check, extension)
  } else if (nrow(successor_check) == 0){
    'None'
  } else {
    'multiple_successors'
  }

output <- c(org_code,org_name,successor_code)

output_list[[i]] <- output
}

output_df <- suppressWarnings(as_tibble(do.call(rbind,output_list), .name_repair = 'unique'))
colnames(output_df) <- c("org_code","org_name","successor_code")

return(output_df)
}