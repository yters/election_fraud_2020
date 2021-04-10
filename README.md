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

## Output

The output of the script will be:
- `images/<county id>-<county>-<date>.png`: graphs with fitted polynomial for the county's general elections 
- `results/reg_votes.txt`: registered voter counts, votes, and 'late registrations' broken out by county, election, and age 
- `results/r_values.txt`: r values for the fitted polynomials
- `results/late_reg.txt`: 'late registration' counts, the number of voters who registered to vote after the election

Some pregenerated output is included in the repo as an example.

## Strangeness
The 2012 and 2016 elections have many voters who were not registered until sometimes much after the election.  Not sure if this is a glitch with the North Carolina database, or illegal voting.
