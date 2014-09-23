source("loader/sampled_first_namespace_edit.R")

first_ns = load_sampled_first_namespace_edits(reload=T)

first_ns$time_since_reg = with(first_ns,
                               as.numeric(timestamp - user_registration))


first_ns = first_ns[time_since_reg > 0,]

svg("firsts/plots/first_namespace_edit.density.by_attached_method.svg",
    height=12,
    width=7)
ggplot(
    first_ns[page_namespace <= 16,],
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



first_ns$user_registration_epoch = factor(
    sapply(
        first_ns$user_registration,
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
    first_ns[page_namespace <= 16,],
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
