source("loader/sampled_first_sandbox_edits.R")

first_sandbox = load_sampled_first_sandbox_edits(reload=T)

first_sandbox$time_since_reg = with(first_sandbox,
                               as.numeric(timestamp - user_registration))


first_sandbox = first_sandbox[time_since_reg > 0,]

svg("firsts/plots/first_sandbox_edit.density.by_attached_method.svg",
    height=12,
    width=7)
ggplot(
    first_sandbox,
    aes(
        x=time_since_reg
    )
) +
geom_density(fill="#000000", alpha=0.2) +
theme_bw() +
facet_wrap(~ attached_method, ncol=1) +
scale_x_log10(
    "Time since registration",
    breaks=c(60, 60*60, 60*60*24, 60*60*24*7, 60*60*24*30, 60*60*24*365),
    labels=c("minute", "hour", "day", "week", "month", "year")
)
dev.off()



first_sandbox$user_registration_epoch = factor(
    sapply(
        first_sandbox$user_registration,
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

svg("firsts/plots/first_sandbox_edit.density.by_registration_epoch.svg",
    height=7,
    width=7)
ggplot(
    first_sandbox,
    aes(
        x=time_since_reg
    )
) +
geom_density(fill="#000000", alpha=0.2) +
theme_bw() +
facet_wrap(~ user_registration_epoch, ncol=1) +
scale_x_log10(
    "Time since registration",
    breaks=c(60, 60*60, 60*60*24, 60*60*24*7, 60*60*24*30, 60*60*24*365),
    labels=c("minute", "hour", "day", "week", "month", "year")
)
dev.off()
