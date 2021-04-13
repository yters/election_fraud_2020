library(reshape2) # for the melt command

reg_votes <- read.table('results/reg_votes.txt')
reg_votes[reg_votes==0.1]<-0

registered_2020 <- unique(reg_votes[reg_votes[,4]=='all_reg',5:134])
voted_2020 <- unique(reg_votes[reg_votes[,4]=='voted'&reg_votes[,3]=='2020-11-03',5:134])
voted_2016 <- unique(reg_votes[reg_votes[,4]=='voted'&reg_votes[,3]=='2016-11-08',5:134])
voted_2012 <- unique(reg_votes[reg_votes[,4]=='voted'&reg_votes[,3]=='2012-11-06',5:134])

fit_model <- function(voted, registered, degrees) {
ratios <- voted/registered
x <- as.numeric(substr(as.character(melt(t(ratios[1:30,]))[,1]), 2,4))
y <- melt(t(ratios[1:30,]))[,3]
fit <- lm(y ~ poly(x, degrees), na.action=na.exclude)
}

fit_2020 <- fit_model(voted_2020, registered_2020, 6)
fit_2016 <- fit_model(voted_2016, registered_2020, 6)
fit_2012 <- fit_model(voted_2012, registered_2020, 6)

total_votes_2020 <- c()
total_votes_2016 <- c()
total_votes_2012 <- c()
all_r_vals_2020 <- c()
all_r_vals_2016 <- c()
all_r_vals_2012 <- c()

for(i in 1:98) {
county_id <- reg_votes[i*10,1]
county <- reg_votes[i*10,2]

votes <- unlist(voted_2020[i,])
pred <- unlist(fitted(fit_2020)[1:130]*registered_2020[i,1:130])
r_val <- cor.test(votes, pred)$estimate

png(paste('images/2020/',substr(format(round(r_val,3),nsmall=3),3,5),'-',county_id,'-',county,'-2020-11-03.png',sep=''))
ylim <- c(0, max(registered_2020[i,]))
plot(votes, type='l', ylim=ylim)
par(new=TRUE)
plot(pred, ylim=ylim, type='l', col='red')
title(paste(county_id,county,'2020-11-03','R =',round(r_val,3),'votes =',sum(votes)))
tmp <- dev.off()

total_votes_2020 <- c(total_votes_2020, sum(votes))
all_r_vals_2020 <- c(all_r_vals_2020, r_val)

votes <- unlist(voted_2016[i,])
pred <- unlist(fitted(fit_2016)[1:130]*registered_2020[i,1:130])
r_val <- cor.test(votes, pred)$estimate

png(paste('images/2016/',substr(format(round(r_val,3),nsmall=3),3,5),'-',county_id,'-',county,'-2016-11-08.png',sep=''))
ylim <- c(0, max(registered_2020[i,]))
plot(votes, type='l', ylim=ylim)
par(new=TRUE)
plot(pred, ylim=ylim, type='l', col='red')
title(paste(county_id,county,'2016-11-08','R =',round(r_val,3),'votes =',sum(votes)))
tmp <- dev.off()

total_votes_2016 <- c(total_votes_2016, sum(votes))
all_r_vals_2016 <- c(all_r_vals_2016, r_val)

votes <- unlist(voted_2012[i,])
pred <- unlist(fitted(fit_2012)[1:130]*registered_2020[i,1:130])
r_val <- cor.test(votes, pred)$estimate

png(paste('images/2012/',substr(format(round(r_val,3),nsmall=3),3,5),'-',county_id,'-',county,'-2012-11-03.png',sep=''))
ylim <- c(0, max(registered_2020[i,]))
plot(votes, type='l', ylim=ylim)
par(new=TRUE)
plot(pred, ylim=ylim, type='l', col='red')
title(paste(county_id,county,'2012-11-06','R =',round(r_val,3),'votes =',sum(votes)))
tmp <- dev.off()

total_votes_2012 <- c(total_votes_2012, sum(votes))
all_r_vals_2012 <- c(all_r_vals_2012, r_val)
}