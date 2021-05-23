library(reshape2) # for the melt command

fit_model <- function(votes, registrations, degrees, sample_count) {
    ratios <- votes/registrations
    x <- rep(1:dim(ratios)[2], sample_count)
    y <- melt(t(ratios[sample(1:dim(ratios)[1],30),]))[,3]
    y[!is.finite(y)] <- NA
    fit <- lm(y ~ poly(x, degrees), na.action=na.exclude)
}

plot_all_counties <- function(year, votes, registrations, fit) {
    ratios <- votes/registrations
    pred <- t(apply(registrations, 1, function(x) {x * fitted(fit)[1:dim(registrations)[2]]}))
    r_value <- mean(mapply(function(x, y) {cor.test(x,y)$estimate}, as.data.frame(t(votes)), as.data.frame(t(pred))))
    
    png(paste('images/','_all_counties_',year,'.png',sep=''))
    matplot(t(ratios)[dim(ratios)[2]:1,], type='l', lty=1, ylab='Turnout ratio', xlab='Voter age in 2020', ylim=c(0,1))
    lines(dim(ratios)[2]:1, fitted(fit)[1:dim(ratios)[2]], col='black', pch=20, lwd=10, lty=1)
    title(paste('All NC counties turnout ratios',year,'votes =',sum(votes),'R =',round(r_value,3)))
    tmp <- dev.off()
}

base_path <- 'results/'
poly_deg <- 6
sample_count <- 30

registrations_2020 <- unlist(read.table(paste(base_path,'registrations_2020.txt',sep='')))
registrations_2020 <- matrix(registrations_2020, nrow=87, byrow=TRUE)
votes_2020 <- unlist(read.table(paste(base_path,'votes_2020.txt',sep='')))
votes_2020 <- matrix(votes_2020, nrow=87, byrow=TRUE)
fit_2020 <- fit_model(votes_2020, registrations_2020, poly_deg, sample_count)
plot_all_counties('2020', votes_2020, registrations_2020, fit_2020)

#registrations_2016 <- unlist(read.table(paste(base_path,'registrations_2016.txt',sep='')))
#registrations_2016 <- matrix(registrations_2016, nrow=87, byrow=TRUE)
registrations_2016 <- registrations_2020[,1:dim(registrations_2020)[2]]
votes_2016 <- unlist(read.table(paste(base_path,'votes_2016.txt',sep='')))
votes_2016 <- matrix(votes_2016, nrow=87, byrow=TRUE)
votes_2016 <- votes_2016[,1:(dim(votes_2020)[2]-0)]
fit_2016 <- fit_model(votes_2016, registrations_2016, poly_deg, sample_count)
plot_all_counties('2016', votes_2016, registrations_2016, fit_2016)

#registrations_2012 <- unlist(read.table(paste(base_path,'registrations_2012.txt',sep='')))
#registrations_2012 <- matrix(registrations_2012, nrow=87, byrow=TRUE)
registrations_2012 <- registrations_2016[,1:dim(registrations_2016)[2]]
votes_2012 <- unlist(read.table(paste(base_path,'votes_2012.txt',sep='')))
votes_2012 <- matrix(votes_2012, nrow=87, byrow=TRUE)
votes_2012 <- votes_2012[,1:(dim(votes_2016)[2]-0)]
fit_2012 <- fit_model(votes_2012, registrations_2012, poly_deg, sample_count)
plot_all_counties('2012', votes_2012, registrations_2012, fit_2012)
