#!/bin/sh

cat results/reg_votes.txt | grep voted | grep 2020-11-03 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/votes_2020.txt
cat results/reg_votes.txt | grep voted | grep 2016-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/votes_2016.txt
cat results/reg_votes.txt | grep voted | grep 2012-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/votes_2012.txt


cat results/reg_votes.txt | grep all_reg | grep 2012-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/registrations_2020.txt
cat results/reg_votes.txt | grep all_reg | grep 2012-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/registrations_2016.txt
cat results/reg_votes.txt | grep all_reg | grep 2012-11-06 | sort | uniq | cut -f 5-134 -d ' ' | sed 's/0[.]1/0/g' > results/registrations_2012.txt
