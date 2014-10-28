source("loader/sampled_first_portal_edits.R")
source("loader/sampled_users.R")

first_portal = load_sampled_first_portal_edits(reload=T)
users = load_sampled_users(reload=T)

user_first_portal = merge(first_portal, users, by=c("wiki", "user_id"))

user_first_portal$time_since_reg = with(user_first_portal,
                               as.numeric(timestamp - user_registration))


svg("firsts/plots/first_portal_edit.density.by_attached_method.svg",
    height=12,
    width=7)
ggplot(
    user_first_portal[
        attached_method=="new" |
        attached_method=="primary",],
    aes(
        x=time_since_reg,
        group=portal
    )
) +
facet_wrap(~ portal, ncol=1) +
geom_density(fill="#000000", alpha=0.2) +
theme_bw() +
scale_x_log10(
    "Time since registration",
    breaks=c(60, 60*60, 60*60*24, 60*60*24*7, 60*60*24*30, 60*60*24*365),
    labels=c("minute", "hour", "day", "week", "month", "year")
)
dev.off()

svg("firsts/plots/first_portal_edit.reg_after_2013.density.by_attached_method.svg",
    height=7,
    width=7)
ggplot(
    user_first_portal[
        (
            attached_method=="new" |
            attached_method=="primary"
        ) & user_registration > as.POSIXct("2013-01-01 00:00:00")],
    aes(
        x=time_since_reg,
        group=portal,
        fill=portal
    )
) +
facet_wrap(~ portal, ncol=1) +
geom_density(fill="#000000", alpha=0.2) +
theme_bw() +
scale_x_log10(
    "Time since registration",
    breaks=c(60, 60*60, 60*60*24, 60*60*24*7, 60*60*24*30, 60*60*24*365),
    labels=c("minute", "hour", "day", "week", "month", "year")
)
dev.off()
