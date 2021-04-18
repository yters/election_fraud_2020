library(reshape2) # for the melt command

fit_model <- function(votes, registrations, degrees, sample_count) {
    ratios <- votes/registrations
    x <- rep(1:dim(ratios)[2], sample_count)
    y <- melt(t(ratios[sample(1:dim(ratios)[1],30),]))[,3]
    fit <- lm(y ~ poly(x, degrees), na.action=na.exclude)
}

plot_all_counties <- function(state, year, votes, registrations, fit) {
    pred <- t(apply(registrations, 1, function(x) {x * fitted(fit)[1:130]}))
    r_value <- mean(mapply(function(x, y) {cor.test(x,y)$estimate}, as.data.frame(t(votes)), as.data.frame(t(pred))))
    
    png(paste('images/',state,'/_all_counties_',year,'.png',sep=''))
    matplot(t(votes/registrations), type='l', lty=1, ylab='Turnout ratio', xlab='Voter age in 2020', ylim=c(0,1))
    lines(1:130, fitted(fit)[1:130], col='black', pch=20, lwd=10, lty=1)
    title(paste('All NC counties turnout ratios',year,'votes =',sum(votes),'R =',round(r_value,3)))
    tmp <- dev.off()
}

base_path <- 'results/north_carolina/'

registrations_2020 <- read.table(paste(base_path,'registrations_2020.txt',sep=''))
registrations_2016 <- read.table(paste(base_path,'registrations_2016.txt',sep=''))
registrations_2012 <- read.table(paste(base_path,'registrations_2012.txt',sep=''))

votes_2020 <- read.table(paste(base_path,'votes_2020.txt',sep=''))
votes_2016 <- read.table(paste(base_path,'votes_2016.txt',sep=''))
votes_2012 <- read.table(paste(base_path,'votes_2012.txt',sep=''))

poly_deg <- 6
sample_count <- 30
fit_2020 <- fit_model(votes_2020, registrations_2020, poly_deg, sample_count)
fit_2016 <- fit_model(votes_2016, registrations_2016, poly_deg, sample_count)
fit_2012 <- fit_model(votes_2012, registrations_2012, poly_deg, sample_count)

plot_all_counties('north_carolina', '2020', votes_2020, registrations_2020, fit_2020)
plot_all_counties('north_carolina', '2016', votes_2016, registrations_2016, fit_2016)
plot_all_counties('north_carolina', '2012', votes_2012, registrations_2012, fit_2012)

