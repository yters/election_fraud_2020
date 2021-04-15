library(reshape2) # for the melt command

fit_model <- function(votes, registrations, degrees, sample_count) {
    ratios <- votes/registrations
    x <- rep(1:dim(votes)[2], sample_count)
    y <- melt(t(ratios[sample(1:dim(votes)[1],30),]))[,3]
    #y[!is.finite(y)] <- 0
    fit <- lm(y ~ poly(x, degrees), na.action=na.exclude)
}

r_vals <- function(votes, registrations, fit) {
    r_vals <- c()
    for(i in 1:dim(votes)[1]) {
        truth <- unlist(votes[i,])
        pred <- unlist(fitted(fit)[1:dim(registrations)[2]]*registrations[i,])
        r_vals <- c(r_vals, cor.test(truth, pred)$estimate)
    }
    r_vals
}

counties <- unlist(read.table('results/counties.txt', stringsAsFactors=FALSE))

plot_graph <- function(year, votes, registrations, fit) {
    for(i in 1:dim(votes)[1]) {
        county_id <- i
        county <- counties[i]
        
        truth <- unlist(votes[i,])
        pred <- unlist(fitted(fit)[1:130]*registrations[i,1:dim(registrations)[2]])
        r_val <- cor.test(truth, pred)$estimate
        
        png(paste('images/',year,'/',substr(format(round(r_val,3),nsmall=3),3,5),'-',county_id,'-',county,'-',year,'.png',sep=''))
        ylim <- c(0, max(registrations[i,]))
        plot(truth, type='l', ylim=ylim)
        par(new=TRUE)
        plot(pred, ylim=ylim, type='l', col='red')
        title(paste(county_id,county,year,'R =',round(r_val,3),'votes =',sum(truth)))
        tmp <- dev.off()
    }
}

registrations_2020 <- read.table('results/registrations_2020.txt')
registrations_2016 <- read.table('results/registrations_2016.txt')
registrations_2012 <- read.table('results/registrations_2012.txt')

votes_2020 <- read.table('results/votes_2020.txt')
votes_2016 <- read.table('results/votes_2016.txt')
votes_2012 <- read.table('results/votes_2012.txt')

fit_2020 <- fit_model(votes_2020, registrations_2020, 6, 30)
fit_2016 <- fit_model(votes_2016, registrations_2016, 6, 30)
fit_2012 <- fit_model(votes_2012, registrations_2012, 6, 30)

plot_graph('2020', votes_2020, registrations_2020, fit_2020)
plot_graph('2016', votes_2016, registrations_2016, fit_2016)
plot_graph('2012', votes_2012, registrations_2012, fit_2012)
