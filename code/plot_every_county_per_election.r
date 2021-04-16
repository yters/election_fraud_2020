library(reshape2) # for the melt command

fit_model <- function(votes, registrations, degrees, sample_count) {
    ratios <- votes/registrations
    x <- rep(1:dim(ratios)[2], sample_count)
    y <- melt(t(ratios[sample(1:dim(ratios)[1],30),]))[,3]
    fit <- lm(y ~ poly(x, degrees), na.action=na.exclude)
}

plot_all_counties <- function(year, votes, registrations, fit) {
    crs <- c()
    for (i in 1:dim(votes)[1]) {
        truth <- unlist(votes[i,])
        pred <- unlist(fitted(fit)[1:130]*registrations[i,])
        crs <- c(crs, cor.test(truth, pred)$estimate)
    }
    r_value <- mean(crs)
    
    png(paste('images/_all_counties_',year,'.png',sep=''))
    matplot(t(votes/registrations), type='l', ylab='Turnout ratio', xlab='Voter age in 2020', ylim=c(0,1))
    lines(1:130, fitted(fit)[1:130], col='black', pch=20, lwd=10, lty=1)
    title(paste('All NC counties turnout ratios',year,'votes =',sum(votes),'R =',round(r_value,3)))
    tmp <- dev.off()
}

registrations_2020 <- read.table('results/registrations_2020.txt')
registrations_2016 <- read.table('results/registrations_2016.txt')
registrations_2012 <- read.table('results/registrations_2012.txt')

votes_2020 <- read.table('results/votes_2020.txt')
votes_2016 <- read.table('results/votes_2016.txt')
votes_2012 <- read.table('results/votes_2012.txt')

poly_deg <- 6
sample_count <- 30
fit_2020 <- fit_model(votes_2020, registrations_2020, poly_deg, sample_count)
fit_2016 <- fit_model(votes_2016, registrations_2016, poly_deg, sample_count)
fit_2012 <- fit_model(votes_2012, registrations_2012, poly_deg, sample_count)

plot_all_counties('2020', votes_2020, registrations_2020, fit_2020)
plot_all_counties('2016', votes_2016, registrations_2016, fit_2016)
plot_all_counties('2012', votes_2012, registrations_2012, fit_2012)

