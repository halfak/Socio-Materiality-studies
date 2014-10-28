source("loader/sampled_first_portal_edits.R")
source("loader/sampled_users.R")

first_portal = load_sampled_first_portal_edits(reload=T)
users = load_sampled_users(reload=T)

user_first_portal = merge(first_portal, users, by=c("wiki", "user_id"))

user_first_portal$time_since_reg = with(user_first_portal,
                               as.numeric(timestamp - user_registration))
