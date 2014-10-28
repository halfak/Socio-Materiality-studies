source("util.R")
source("env.R")

load_sampled_users = tsv_loader(
    paste(DATA_DIR, "sampled_user.tsv", sep="/"),
    "SAMPLED_USER",
    function(dt){
        dt$user_registration = as.POSIXct(as.character(dt$user_registration),
                                          format="%Y%m%d%H%M%S",
                                          origin="1970-01-01")
        #dt$page_namespace = factor(dt$page_namespace)
        dt
    }
)
