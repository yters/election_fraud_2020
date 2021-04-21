from collections import namedtuple
import sys

VoterInfo = namedtuple('VoterInfo', ['birth_year', 'county_id'])
voters = {}
elections = set()
counties = set()
with open(sys.argv[1], encoding='cp1252') as f:
    for line in f:
        if 'VoteId' in line or 'CountyCode' in line:
            continue
        records = line.split(',')
        voter_id = int(records[1].replace('"',''))
        if 2 < len(records[20]) < 8:
            birth_year = int(records[20].replace('"',''))
        else:
            birth_year = -1
        county_id = int(records[1].replace('"',''))
        counties.add(county_id)

        voters[voter_id] = VoterInfo(birth_year, county_id)

results = {}
with open(sys.argv[2], encoding='cp1252') as f:
    for line in f:
        if 'VoteId' in line:
            continue
        records = line.split(',')
        voter_id = int(records[0].replace('"',''))
        if not voter_id in voters:
            continue
        election = records[1].replace('/','-').replace('"','')
        elections.add(election)
        birth_year = voters[voter_id].birth_year
        county_id = voters[voter_id].county_id
        cell = (county_id, election, birth_year)
        results[cell] = results.get(cell, 0) + 1

print(elections, counties)
for election in elections:
    with open('results/minnesota/votes_'+election+'.txt', 'w') as f:
        for county_id in counties:
            for year in [-1]+list(range(1900, 2020)):
                f.write(str(results.get((county_id, election, year), 0)) + ' ')
        f.write('\n')
