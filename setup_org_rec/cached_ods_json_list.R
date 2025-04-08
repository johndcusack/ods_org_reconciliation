# This script wraps the extract function in memoise.
# Memoise caches the result of the API call in memory,
# improving performance on repeated calls during a session

source('setup_org_rec/extract_ods_json_list.R')

cached_ods_json_list <-  memoise::memoise(extract_ods_json_list)

rm(extract_ods_json_list) # clean up, removing the un-memoised function