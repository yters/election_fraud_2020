#!/bin/sh

cut -f 1,2 -d ' ' results/north_carolina/reg_votes.txt | sort -n | uniq | cut -f 2 -d ' ' > results/north_carolina/counties.txt

cat results/reg_votes.txt | grep voted | grep 2020-11-03 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/north_carolina/votes_2020.txt
cat results/reg_votes.txt | grep voted | grep 2016-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/north_carolina/votes_2016.txt
cat results/reg_votes.txt | grep voted | grep 2012-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/north_carolina/votes_2012.txt

cat results/reg_votes.txt | grep all_reg | grep 2012-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/north_carolina/registrations_2020.txt
cat results/reg_votes.txt | grep all_reg | grep 2012-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/north_carolina/registrations_2016.txt
cat results/reg_votes.txt | grep all_reg | grep 2012-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/north_carolina/registrations_2012.txt
