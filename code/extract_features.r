args <- commandArgs(trailingOnly = TRUE)
county <- args[1]
county_id <- args[2]
cat(paste('processing', county, '\n'))
cat('loading ncvoter\n')
ncvoter <- read.table(paste('data/ncvoter', county_id, '.txt', sep=''), sep='\t', header=TRUE, stringsAsFactors=FALSE)
cat('loading nchis\n')
ncvhis <- read.table(paste('data/ncvhis', county_id, '.txt', sep=''), sep='\t', header=TRUE, stringsAsFactors=FALSE)
cat('joining into ncvm\n')
ncvm <- merge(ncvhis, ncvoter, id='voter_reg_num')
cat('extracting reg_age\n')
reg_age <- unique(ncvm[,c('voter_reg_num','registr_dt','birth_age')])

major_elections <- c(
"11/03/2020", # 86530
"11/08/2016", # 74414
"11/06/2012"  # 71838
)

minor_elections <- c(
"03/03/2020", # 32015
"11/06/2018", # 57966
"05/08/2018", # 13463
"03/15/2016", # 33238
"11/04/2014", # 46721
"05/06/2014", # 13626
"05/08/2012"  # 31710
)

elections <- c(
major_elections
)

for (election in elections) {
cat(paste('tabulating election', election, '\n'))
y <- table(ncvm[ncvm[,'election_lbl']==election,'birth_age'])
x <- table(reg_age[as.Date(reg_age[,'registr_dt'], '%m/%d/%Y') <= as.Date(election, '%m/%d/%Y'),'birth_age'])
z <- table(ncvm[ncvm[,'election_lbl']==election & as.Date(ncvm[,'registr_dt'], '%m/%d/%Y') > as.Date(election, '%m/%d/%Y'),'birth_age'])
ny <- c()
nx <- c()
nz <- c()
for (i in 1:130) { p <- which(as.numeric(unlist(attr(y, 'dimnames')))==i); if (length(p) > 0) { ny[i] <- y[p] } else { ny[i] <- 0 } }
for (i in 1:130) { p <- which(as.numeric(unlist(attr(x, 'dimnames')))==i); if (length(p) > 0) { nx[i] <- x[p] } else { nx[i] <- 0 } }
for (i in 1:130) { p <- which(as.numeric(unlist(attr(z, 'dimnames')))==i); if (length(p) > 0) { nz[i] <- z[p] } else { nz[i] <- 0 } }

cat('fitting polynomial\n')
nr <- ny/nx
nr[which(!is.finite(nr))] <- NA
np <- 1:130
fit <- lm(nr ~ poly(np, 6), na.action=na.exclude)
R2 <- summary(fit)$r.squared
aR2 <- summary(fit)$adj.r.squared

cat('generating images\n')
png(paste('images/',county_id,'-',county,'-',as.Date(election, '%m/%d/%Y'),'.png',sep=''))
plot(ny/nx, type='l', ylim=c(0,1.2), xlim=c(18,125), xlab='Age', ylab='Turnout Ratio')
lines(18:130, fitted(fit)[18:130], col='red', pch=20)
abline(h=1)
title(paste(county_id,county,election,'R =',round(sqrt(R2),3),'votes =',sum(ny)))
tmp <- dev.off()
cat('saving data\n')
cat(paste(county_id, county, as.Date(election, '%m/%d/%Y'), 'registered', paste(x, collapse=' '), '\n'), file='results/reg_votes.txt', append=TRUE)
cat(paste(county_id, county, as.Date(election, '%m/%d/%Y'), 'voted', paste(y, collapse=' '), '\n'), file='results/reg_votes.txt', append=TRUE)
cat(paste(county_id, county, as.Date(election, '%m/%d/%Y'), 'late', paste(z, collapse=' '), '\n'), file='results/reg_votes.txt', append=TRUE)
cat(paste(county_id, county, as.Date(election, '%m/%d/%Y'), sqrt(R2), '\n'), file='results/r_values.txt', append=TRUE)
cat(paste(county_id, county, as.Date(election, '%m/%d/%Y'), sum(z), '\n'), file='results/late.txt', append=TRUE)
}
cat(paste('finished with', county, '\n\n'))
