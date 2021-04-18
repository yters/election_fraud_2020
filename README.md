## Hypothesis

This analysis is meant to test the hypothesis that the 2020 election is heavily influenced by an algorithm.  A physicist named Dr. Douglas G. Frank has claimed that an algorithm used a 6 degree polynomial to add votes to the 2020 election, and each state (that he has checked so far) has a specific polynomial shape.

As of the time of this commit, the video where the claim is made can be found here:
- https://cdn.jigg.cloud/ScientificProofTVSpecial-03-31-21-FINALHQ/mp4/ScientificProofTVSpecial-03-31-21-FINALHQ.mp4

In the video, the physicist has checked a few states, and claims starting at 2:44 his regression model has a 'parts per million detail' which means the fit is 'not an accident', thus he has discovered 'it has to be done by an algorithm' that added votes to influence the election.  The show's host, Michael Lindell, claims the physicist's result 'is impossible to be done by humans', and thus corroborates another video produced by Mr. Lindell which provides evidence of a cyber attack on the election.

## Test of hypothesis approach

The difficulty with verifying Dr. Frank's claim is many states paywall their data, and have restrictions on who can access the data, often only a resident of the state.  This analysis attempts to verify the physicist's claim in a state with a freely accessible public dataset of voter level granularity.  In this case, I am using North Carolina's dataset: https://www.ncsbe.gov/results-data.  

To test the hypothesis, for each age group and county, I am dividing the total votes for an election by the total registered voting population.  I do this for the 2020 election as well and 2016 and 2012.  If Dr. Frank's claim holds true for North Carolina, then the 2020 election dataset should be significantly different from 2016 and 2012, and a 6 degree polynomial should fit much better.  Additionally, it should be clear this is not due to the law of large numbers, i.e. that a statistic approaches an underlying natural distribution as the number of samples increases.

My suspicion is the latter is the reason why Dr. Frank found a 6 degree polynomial can predict the 2020 election voter turnout so well.  Since the 2020 election has a much higher than normal voter turnout, the alternate explanation for a polynomial fitting the election turnout so well is the law of large numbers.  In my opinion, even if the polynomial fits 2020 better than 2016 and 2012, if there is still a good fit for 2016 and 2012, then we should accept the law of large numbers explanation over algorithmic voter manipulation.  In the latter case the fit should be extremely precise, as per Dr. Frank's claim, to distinguish between a natural vs a deterministic cause for the voter turnout ratios.

## Prerequisites

You'll need to have R installed along with standard Linux utilities such as wget and zip.

## Downloading data

To download all the counties' data from the North Carolina election website, run this script:
```
./code/download_data.sh
```

There are 100 counties in North Carolina, so once the script completes you will have 200 zip files.  Download will take a couple minutes.

## Processing data

To extract age demographics from a county dataset, run this script:
```
./code/unzip_and_run_extractor.sh <county_id>
```

Some counties have a whole lot of data, and processing those counties takes a long time.  Estimate about a 10s per megabyte.  The recommended approach is to sort the datafiles by size, and pick county ids (last numbers in the dataset filenames) that have a file size of a few megabytes.

This way you can see results from substantial voting populations without processing datasets for many minutes.

## Processed output

The output of the script will be:
- `results/north_carolina/reg_votes.txt`: registered voter counts, votes, and 'late registrations' broken out by county, election, and age 
- `results/north_carolina/r_values.txt`: r values for the fitted polynomials
- `results/north_carolina/late_reg.txt`: 'late registration' counts, the number of voters who registered to vote after the election

All processed output is included in the repo as an example.

## Strangeness
The 2012 and 2016 elections have many voters who were not registered until sometimes much after the election.  Not sure if this is a glitch with the North Carolina database, people reregistering (e.g. regaining residency in state), or illegal voting.

## Plotting all counties

After all the datasets are processed, you can create a plot of all counties per election by running the following script:
```
RScript code/plot_every_county_per_election.r
./code/convert_to_vote_registration_files.sh
RScript code/draw_county_graph.r
```

This will create the following three files in `images`:
- `images/north_carolina/_all_counties_2012.png`
- `images/north_carolina/_all_counties_2016.png`
- `images/north_carolina/_all_counties_2020.png`

Each image is the plot of all counties' turnout ratios for that specific election, along with a best fit line using a 6 degree polynomial.  The total number of votes for that election and the R value of the best fit line are part of the plot title.

In addition there are three subdirectories which contain all the individual county plots of votes (black) and predictions (red):
- `images/north_carolina/2020`
- `images/north_carolina/2016`
- `images/north_carolina/2012`

Also note, these turnout ratios and vote predictions are normalized using the entire voter registry database, instead of only those who are registered before the election.  This is the most conservative approach to minimize false positives when the hypothesis is the ratio is the product of an algorithm instead of a natural result of the law of large numbers.

## Results

The following graphs show the turnout ratios for every county in the general election for that year.  Additionally, there is a best fit polynomial based on all the turnout ratios.  In the graph title there is the total number of votes and the average R value for predicting the votes for each county individually.

We can see that generally the trend line stays the same and shifts to the left as the election year increases.  This shifting movement is somewhat obscured by the noise at the extremities of the graph due to a smaller voting population and the consequent higher variance.  Essentially, the graphs show that 60-80 years old is the prime voter turnout age.

To see the individual county vote prediction graphs, look in the image subdirectories as explained in the previous section.

### North Carolina

#### 2012 General Election
![north_carolina_2012](https://raw.github.com/yters/election_fraud_2020/master/images/north_carolina/_all_counties_2012.png)

#### 2016
![north_carolina_2016](https://raw.github.com/yters/election_fraud_2020/master/images/north_carolina/_all_counties_2016.png)

#### 2020
![north_carolina_2020](https://raw.github.com/yters/election_fraud_2020/master/images/north_carolina/_all_counties_2020.png)

## Conclusion

While the 2020 election's 6 degree polynomial fit is better than 2016 and 2012, it is not significantly better.  The average R value for 2020 is 0.995, while the R value for 2016 is 0.987 and the R value for 2012 is 0.985.  The increase in votes from 2012 to 2016 is 400,000, and the increase in votes from 2016 is 700,000.  From a subjective eyeball of the respective all county graphs, there does not appear to be a qualitative difference between the turnout graphs.  So, my conclusion is at least for North Carolina, either the past three elections have all been algorithmically controlled, or none of them have.

One may then state, perhaps North Carolina was not hacked.  However, if hacking is the reason Biden won, and otherwise Trump is supposed to have won by a landslide, that was not the case in North Carolina.  Trump only won over Biden in 2020 by 1.3%.  Quite narrow to be a landslide victory.

Neither does it seem North Carolina is sufficiently Democrat skewed that it does not need to be hacked, since it voted for the Republican candidate in the last three elections.  Rather, North Carolina has a significant number of electoral votes, and many close elections, so is a swing state that is especially important to hack for election victory.

Finally, per the state website, North Carolina does use election machines, although they are not supposed to be connected to the internet: https://www.ncsbe.gov/voting/voting-equipment.  However, this is also the law for Ohio, where hacking supposedly did occur: https://codes.ohio.gov/ohio-revised-code/section-3506.23.

Thus, the author does not know of any factors why North Carolina would be ignored by the hackers while Ohio was hacked, besides perhaps better security measures or more honest election process officials.  At any rate, North Carolina's voter databases demonstrates that not all US states were obviously hacked during the 2020 presidential election.

## Possibility of algorithm condition on past elections
One more possible objection is perhaps, since we have to use the 2020 registration database as the baseline for previous elections, the algorithm was tuned using the previous election dataset to look similar.  Thus, we would expect the algorithmic process to be indistinguishable from older elections.  This is a possibility, and the objector may further claim that the very high R value is prima facie evidence of algorithmic interference, and in fact the high R values for older elections makes an even stronger case for algorithmic interference.  One response to this line of reasoning is the principle of preferring chance explanations over interventionist explanations, e.g. maximum entropy.  In which case, the mere fact of high predictability is not in itself proof of algorithmic interference.  Natural stochastic processes are known to exhibit highly regular patterns when enough samples are aquired, which is the basis of the physical sciences.  We don't infer a non-natural intervention in the case of predicting physical phenomena, so we shouldn't automatically infer non-natural intervention when voter turnout is highly predictable.  To make this step we need to have an alternate hypothesis for a realistic natural stochastic model for voter turnout, and show the expectation for the observed predictability is much less than with the algorithmic intervention model.  An additional problem with this past conditioning objection is taken to an extreme makes the primary hypothesis of algorithimic intervention non falsifiable.