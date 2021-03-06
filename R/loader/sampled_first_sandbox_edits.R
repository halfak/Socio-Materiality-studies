source("util.R")
source("env.R")

load_sampled_first_sandbox_edits = tsv_loader(
    paste(DATA_DIR, "sampled_first_sandbox_edit.tsv", sep="/"),
    "SAMPLED_FIRST_SANDBOX_EDITS",
    function(dt){
        dt$timestamp = as.POSIXct(as.character(dt$timestamp),
                                  format="%Y%m%d%H%M%S",
                                  origin="1970-01-01")
        #dt$page_namespace = factor(dt$page_namespace)
        dt
    }
)
