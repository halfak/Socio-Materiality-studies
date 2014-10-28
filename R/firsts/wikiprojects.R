source("loader/sampled_first_wikiproject_edits.R")
source("loader/sampled_users.R")

first_wikiproject = load_sampled_first_wikiproject_edits(reload=T)
users = load_sampled_users(reload=T)

user_first_wikiproject = merge(first_wikiproject, users, by=c("wiki", "user_id"))

user_first_wikiproject$time_since_reg = with(user_first_wikiproject,
                               as.numeric(timestamp - user_registration))


svg("firsts/plots/first_wikiproject_edit.density.by_attached_method.svg",
    height=12,
    width=7)
ggplot(
    user_first_wikiproject[
        attached_method=="new" |
        attached_method=="primary",],
    aes(
        x=time_since_reg
    )
) +
geom_density(fill="#000000", alpha=0.2) +
theme_bw() +
scale_x_log10(
    "Time since registration",
    breaks=c(60, 60*60, 60*60*24, 60*60*24*7, 60*60*24*30, 60*60*24*365),
    labels=c("minute", "hour", "day", "week", "month", "year")
)
dev.off()

wikiproject_users = user_first_wikiproject[,
    list(
        users=length(user_id)
    ),
    wikiproject
]

svg("firsts/plots/first_wikiproject_edit.density.by_attached_method.svg",
    height=12,
    width=7)
ggplot(
    merge(user_first_wikiproject, wikiproject_users, by="wikiproject")[
        (attached_method=="new" |
        attached_method=="primary") & users >= 50,
    ],
    aes(
        x=time_since_reg,
        group=wikiproject,
        fill=wikiproject
    )
) +
geom_density(alpha=0.2) +
theme_bw() +
scale_x_log10(
    "Time since registration",
    breaks=c(60, 60*60, 60*60*24, 60*60*24*7, 60*60*24*30, 60*60*24*365),
    labels=c("minute", "hour", "day", "week", "month", "year")
)
dev.off()
