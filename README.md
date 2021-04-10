## Prerequisites

You'll need to have R installed along with standard Linux utilities such as wget and zip.

## Running the scripts

To download all the counties' data from the North Carolina election website, run this script:
```
./code/download_data.sh
```

To generate graphs, fit polynomials, and extract age demographics from a county dataset, run this script:
```
./code/unzip_and_run_extractor.sh <county_id>
```

## Output

The output of the script will be:
- graphs for the county's general elections in the `images` directory
- registered voter counts, votes, and 'late registrations' broken out by county, election, and age in the `results` directory
- r values in the `results` directory
- `late registration` counts in the results directory

Some pregenerated output is included in the repo as an example.

## Tip

Some counties have a whole lot of data, and processing those counties takes a long time.  Estimate about a 10s per megabyte.  The recommended approach is to sort the datafiles by size, and pick county ids (last numbers in the dataset filenames) that have a file size of a few megabytes.

This way you can see results from substantial voting populations without processing datasets for many minutes.

## Strangeness
The 2012 and 2016 elections have many voters who were not registered until sometimes much after the election.  Not sure if this is a glitch with the North Carolina database, or illegal voting.