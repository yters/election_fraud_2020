## Prerequisites

You'll need to have R installed along with standard Linux utilities such as wget and zip.

## Downloading data

To download all the counties' data from the North Carolina election website, run this script:
```
./code/download_data.sh
```

There are 100 counties in North Carolina, so once the script completes you will have 200 zip files.  Download will take a couple minutes.


## Processing data

To generate graphs, fit polynomials, and extract age demographics from a county dataset, run this script:
```
./code/unzip_and_run_extractor.sh <county_id>
```

Some counties have a whole lot of data, and processing those counties takes a long time.  Estimate about a 10s per megabyte.  The recommended approach is to sort the datafiles by size, and pick county ids (last numbers in the dataset filenames) that have a file size of a few megabytes.

This way you can see results from substantial voting populations without processing datasets for many minutes.

## Processed output

The output of the script will be:
- `images/<county id>-<county>-<date>.png`: graphs with fitted polynomial for the county's general elections 
- `results/reg_votes.txt`: registered voter counts, votes, and 'late registrations' broken out by county, election, and age 
- `results/r_values.txt`: r values for the fitted polynomials
- `results/late_reg.txt`: 'late registration' counts, the number of voters who registered to vote after the election

All processed output is included in the repo as an example.

## Plotting all counties

After all the datasets are processed, you can create a plot of all counties per election by running the following script:
```
RScript code/plot_every_county_per_election.r
```

This will create the following three files in `images`:
- `images/_all_counties_2012.png`
- `images/_all_counties_2016.png`
- `images/_all_counties_2020.png`

Each image is the plot of all counties' turnout ratios for that specific election, along with a best fit line using a 6 degree polynomial.  The total number of votes for that election and the R value of the best fit line are part of the plot title.

## Strangeness
The 2012 and 2016 elections have many voters who were not registered until sometimes much after the election.  Not sure if this is a glitch with the North Carolina database, people reregistering, or illegal voting.
