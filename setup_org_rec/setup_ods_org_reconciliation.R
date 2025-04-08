# setup script
source("setup_org_rec/replace_with_successor.R")
source("setup_org_rec/update_org_names.R")
source("setup_org_rec/add_short_org_names.R")
source("setup_org_rec/extract_ods_json_list.R")

cached_ods_json_list <- memoise::memoise(extract_ods_json_list)
rm(extract_ods_json_list)