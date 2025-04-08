# Purpose of the project
A set of functions that can be used to reconcile NHS organisation data to the Organisation Data Service and add short organisation names for South East Region Trusts

This project uses a folder called setup_org_rec/ to store reusable functions.

To run scripts in this project:

Do not move or rename the setup_org_rec/ folder
All wrapper scripts assume this folder exists at the same level.

Use the setup script setup_ods_org_reconciliation.R to load all functions.

## Main functions
### replace_with_successor
This function takes in a dataframe with a column of organisation codes. 
Uses those codes to pull out a json object for each code from the ODS API. (cached_ods_json_list)
Create a table from that API with the organisation code, organisation name and any successor code. (create_ods_table)
Compares the organisation codes in the original dataframe's code column to the table created above. 
If the code has been superseded the code is replaced with the successor organisation otherwise it remains the same.

### update_org_names
This function takes in a dataframe with a column of organisation codes. 
Uses those codes to pull out a json object for each code from the ODS API. (cached_ods_json_list)
Create a table from that API with the organisation code, organisation name. (create_ods_table)
Creates a column with the current organisation name, as recorded by the Organisation Data Service.
Note that this function does not merge or update supereceded trusts, and will use their most recent name. 
To update codes to account for any mergers use the replace_with_successor function first.

### add_short_org_names
This function takes a dataframe and a column containing organisation codes, then creates a new column with shortened organization names based on a predefined named vector.
The function works on both ICB and provider codes, but only for the South East region.
The function requires the user to provide a new column name so that it can be applied more than once to the same dataframe without conflicts (allowing for separate provider and ICB columns)

## Helper functions

### extract_ods_json_list 
This function takes a column of NHS organisation codes and returns a list of JSON objects extracted from the Organisational Data Service's API.
The main functions described above use the wrapper cached_ods_json_list (created when running the setup script) instead of using this directly. 

### create_ods_table
This function takes in a list of json files extracted from the Organisational Data Service API such as the one created by cached_ods_json_list.R 
It returns a tibble. The tibble has three fields: 
 - The organisation code 
 - The current organisation name as registered with the ODS
 - The successor code for the organisation, if that code has been retired and replaced or merged

## Dependencies
 - dplyr
 - httr2
 - memoise
 - tidyr
 - stringr
