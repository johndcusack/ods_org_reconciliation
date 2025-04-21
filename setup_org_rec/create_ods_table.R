create_ods_table <- function(json_list) {
  #' Create ODS table
  #'
  #' @description This function takes in a list of json files extracted from 
  #' the Organisational Data Service API such as the one created by cached_ods_json_list.R 
  #' It returns a tibble with:
  #' - organisation code
  #' - organisation name (title case)
  #' - successor code (if retired and replaced/merged)
  
  if (!requireNamespace("tidyr", quietly = TRUE)) {
    stop("The 'tidyr' package is required but not installed.")
  }
  
  if (!requireNamespace("stringr", quietly = TRUE)) {
    stop("The 'stringr' package is required but not installed.")
  }
  
  output_list <- vector("list", length = length(json_list))
  
  for (i in seq_along(json_list)) {
    json_data <- json_list[[i]]
    json_data_df <- tibble::tibble(json_data)
    
    org_code <- json_data_df |> 
      tidyr::unnest_wider(json_data) |>
      tidyr::unnest_wider(OrgId) |> 
      dplyr::pull(extension) |> 
      dplyr::first()
    
    org_name <- json_data_df |> 
      tidyr::hoist(json_data, "Name") |> 
      dplyr::pull(Name) |> 
      dplyr::first() |> 
      stringr::str_to_title() |> 
      stringr::str_replace("Nhs", "NHS")
    
    successor_check <- json_data_df |> 
      tidyr::unnest_wider(json_data)
    
    successor_check <- if (!"Succs" %in% names(successor_check)) {
      tibble::tibble()
    } else {
      successor_check |> 
        dplyr::select(Succs) |>   
        tidyr::unnest_wider(Succs) |>
        tidyr::unnest_longer(Succ) |> 
        tidyr::unnest_wider(Succ) |> 
        tidyr::unnest_wider(Target) |> 
        tidyr::unnest_wider(OrgId) |> 
        dplyr::filter(Type == "Successor")
    }
    
    successor_code <- if (nrow(successor_check) == 1) {
      dplyr::pull(successor_check, extension)
    } else if (nrow(successor_check) == 0) {
      "None"
    } else {
      "multiple_successors"
    }
    
    output <- c(org_code, org_name, successor_code)
    output_list[[i]] <- output
  }
  
  output_df <- suppressWarnings(tibble::as_tibble(do.call(rbind, output_list), .name_repair = "unique"))
  colnames(output_df) <- c("org_code", "org_name", "successor_code")
  
  return(output_df)
}