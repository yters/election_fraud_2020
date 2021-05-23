library(reshape2) # for the melt command


fit_model <- function(votes, registrations, degrees, sample_count) {
    ratios <- votes/registrations
    x <- rep(1:dim(ratios)[2], sample_count)
    y <- melt(t(ratios[sample(1:dim(ratios)[1],30),]))[,3]
    y[!is.finite(y)] <- NA
    fit <- lm(y ~ poly(x, degrees), na.action=na.exclude)
}

plot_graph <- function(year, votes, registrations, fit) {
    for(i in 1:dim(votes)[1]) {
        county_id <- i
        
        truth <- unlist(votes[i,])
        pred <- unlist(fitted(fit)[1:dim(registrations)[2]]*registrations[i,1:dim(registrations)[2]])
        r_val <- cor.test(truth, pred)$estimate
        
        png(paste('images/',year,'/',substr(format(round(r_val,3),nsmall=3),1,5),'-',county_id,'-',year,'.png',sep=''))
	matplot(t(rbind(truth, pred)), type='l', col=c('black', 'red'), lty=c(1, 1), lwd=c(3, 3), ylab='Votes', xlab='Age in 2020')
        title(paste(county_id,year,'R =',round(r_val,3),'votes =',sum(truth)))
        tmp <- dev.off()
    }
}

base_path <- 'results/'

base_path <- 'results/'
poly_deg <- 6
sample_count <- 30

registrations_2020 <- unlist(read.table(paste(base_path,'registrations_2020.txt',sep='')))
registrations_2020 <- matrix(registrations_2020, nrow=87, byrow=TRUE)
votes_2020 <- unlist(read.table(paste(base_path,'votes_2020.txt',sep='')))
votes_2020 <- matrix(votes_2020, nrow=87, byrow=TRUE)
fit_2020 <- fit_model(votes_2020, registrations_2020, poly_deg, sample_count)
plot_graph('2020', votes_2020, registrations_2020, fit_2020)

registrations_2016 <- unlist(read.table(paste(base_path,'registrations_2016.txt',sep='')))
registrations_2016 <- matrix(registrations_2016, nrow=87, byrow=TRUE)
votes_2016 <- unlist(read.table(paste(base_path,'votes_2016.txt',sep='')))
votes_2016 <- matrix(votes_2016, nrow=87, byrow=TRUE)
fit_2016 <- fit_model(votes_2016, registrations_2016, poly_deg, sample_count)
plot_graph('2016', votes_2016, registrations_2016, fit_2016)

registrations_2012 <- unlist(read.table(paste(base_path,'registrations_2012.txt',sep='')))
registrations_2012 <- matrix(registrations_2012, nrow=87, byrow=TRUE)
votes_2012 <- unlist(read.table(paste(base_path,'votes_2012.txt',sep='')))
votes_2012 <- matrix(votes_2012, nrow=87, byrow=TRUE)
fit_2012 <- fit_model(votes_2012, registrations_2012, poly_deg, sample_count)
plot_graph('2012', votes_2012, registrations_2012, fit_2012)
