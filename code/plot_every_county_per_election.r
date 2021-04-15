library(reshape2) # for the melt command

reg_votes <- read.table('results/reg_votes.txt')
reg_votes[reg_votes==0.1]<-0

registered_2020 <- reg_votes[reg_votes[,4]=='all_reg',5:134]

plot_all_counties <- function(year, election) {
voted <- reg_votes[reg_votes[,4]=='voted'&reg_votes[,3]==election,5:134]
ratios <- voted/registered_2020
x <- as.numeric(substr(as.character(melt(t(ratios[1:30,]))[,1]), 2,4))
y <- melt(t(ratios[sample(1:98,30),]))[,3]
fit <- lm(y ~ poly(x, 6), na.action=na.exclude)
# r_value <- sqrt(summary(fit)$adj.r.squared)
crs <- c()
for (i in 1:dim(ratios)[1]) {
crs <- c(crs, cor.test(unlist(fitted(fit)[1:130]*registered_2020[i,]), unlist(voted[i,]))$estimate)
}
r_value <- mean(crs)

votes <- sum(reg_votes[reg_votes[,4]=='voted'&reg_votes[,3]==election,5:134])

png(paste('images/_all_counties_',year,'.png',sep=''))
matplot(t(reg_votes[reg_votes[,4]=='voted'&reg_votes[,3]==election,5:134]/reg_votes[reg_votes[,4]=='all_reg'&reg_votes[,3]=='2012-11-06',5:134]), type='l', ylab='Turnout ratio', xlab='Voter age in 2020', ylim=c(0,1))
lines(1:130, fitted(fit)[1:130], col='black', pch=20, lwd=10, lty=1)
title(paste('All NC counties turnout ratios',year,'votes =',votes,'R =',round(r_value,3)))
tmp <- dev.off()
}

plot_all_counties('2020', '2020-11-03')
plot_all_counties('2016', '2016-11-08')
plot_all_counties('2012', '2012-11-06')

