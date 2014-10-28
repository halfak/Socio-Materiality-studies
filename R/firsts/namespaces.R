source("loader/sampled_first_namespace_edits.R")
source("loader/sampled_users.R")

first_ns = load_sampled_first_namespace_edits(reload=T)
users = load_sampled_users(reload=T)

user_first_ns = merge(first_ns, users, by=c("wiki", "user_id"))

user_first_ns$time_since_reg = with(user_first_ns,
                               as.numeric(timestamp - user_registration))


user_first_ns = user_first_ns[time_since_reg > 0,]

user_first_ns$namespace_group = factor(
    sapply(
        user_first_ns$page_namespace,
        function(ns){
            if(ns == 0){
                "mainspace"
            }else if(ns == 1){
                "talk"
            }else if(ns == 2){
                "user"
            }else if(ns == 3){
                "user talk"
            }else if(ns == 4 || ns == 5){
                "project"
            }else if(ns %% 2 == 0){
                "other"
            }else if(ns %% 2 == 1){
                "other talk"
            }
        }
    ),
    levels = c("mainspace", "talk", "user", "user talk",
               "project", "other", "other talk")
)

svg("firsts/plots/first_namespace_edit.density.by_attached_method.svg",
    height=12,
    width=7)
ggplot(
    user_first_ns[page_namespace <= 16,],
    aes(
        x=time_since_reg,
        group=factor(page_namespace)
    )
) +
geom_density(
    aes(
        fill=factor(page_namespace),
        color=factor(page_namespace)
    ),
    alpha=0.2
) +
theme_bw() +
facet_wrap(~ attached_method, ncol=1) +
scale_x_log10(
    "Time since registration",
    breaks=c(60, 60*60, 60*60*24, 60*60*24*7, 60*60*24*30, 60*60*24*365),
    labels=c("minute", "hour", "day", "week", "month", "year")
) +
scale_fill_discrete("Page namespace") +
scale_color_discrete("Page namespace")
dev.off()



user_first_ns$user_registration_epoch = factor(
    sapply(
        user_first_ns$user_registration,
        function(reg){
            if(reg < as.POSIXct("2004-01-01")){
                "early"
            }else if(reg < as.POSIXct("2007-02-01")){
                "growth"
            }else{
                "decline"
            }
        }
    ),
    levels = c("early", "growth", "decline")
)

svg("firsts/plots/first_namespace_edit.density.by_registration_epoch.svg",
    height=7,
    width=7)
ggplot(
    user_first_ns[page_namespace <= 16,],
    aes(
        x=time_since_reg,
        group=factor(page_namespace)
    )
) +
geom_density(aes(fill=factor(page_namespace)), alpha=0.2) +
theme_bw() +
facet_wrap(~ user_registration_epoch, ncol=1) +
scale_x_log10(
    "Time since registration",
    breaks=c(60, 60*60, 60*60*24, 60*60*24*7, 60*60*24*30, 60*60*24*365),
    labels=c("minute", "hour", "day", "week", "month", "year")
) +
scale_fill_discrete("Page namespace")
dev.off()
