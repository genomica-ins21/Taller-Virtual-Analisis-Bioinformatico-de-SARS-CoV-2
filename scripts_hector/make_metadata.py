#!/usr/bin/env python3
import pandas as pd
import sys

#  read in files from command line arguments
if len(sys.argv) < 4:
    print('Incorrect command format.\nUSAGE: make_metadata.py <USER METADATA CSV> <PANGOLIN OUTPUT> <TYPE VARIANTS OUTPUT>')
    sys.exit(1)

# get files from command line
user_metadata = sys.argv[1]
pangolin_output = sys.argv[2]
type_variants_output = sys.argv[3]

# read in user metadata
user_metadata_df = pd.read_csv(user_metadata)

# add autocolour for all columns except latitiude, longitude, day, month, year
for column in user_metadata_df.columns:
    if column.lower() in ['id', 'latitude', 'longitude', 'day', 'month', 'year']:
        continue
    # add autocolour for lineage
    user_metadata_df = user_metadata_df.rename(columns = {column: f'{column}__autocolour'})

# read in pangolin
pangolin_df = pd.read_csv(pangolin_output)
# drop columns not required
pangolin_df = pangolin_df.drop(columns = ['probability','pangoLEARN_version','note'])
# add autocolour for lineage
pangolin_df = pangolin_df.rename(columns = {'lineage': 'lineage__autocolour'})

# read in type variants
type_variants_df = pd.read_csv(type_variants_output)
# drop columns not required
type_variants_df = type_variants_df.drop(columns = ['ref_count','alt_count','other_count','fraction_alt'])

# function to add colour depending on if base is ref or alt
def add_colour(row, column, ref, alt):
    if row[column] == ref:
        return('LimeGreen')
    if row[column] == alt:
        return('IndianRed')
    else:
        return('Gold')

#  for each column, find the ref and alt bases
for column in type_variants_df.columns:
    #  skip query column
    if column == 'query':
        continue
    # get mutation type
    mutation_type = column.split(':')[0]
    if mutation_type == 'del':
        ref = 'ref'
        alt = 'del'
    elif mutation_type == 'snp' or mutation_type == 'aa':
        ref = column.split(':')[-1][0]
        alt = column.split(':')[-1][-1]
    type_variants_df[f'{column}__colour'] = type_variants_df.apply(
        lambda row: add_colour(row, column, ref, alt), axis=1
        )

# sort columns
type_variants_df = type_variants_df.sort_index(axis = 1)
# take the query column to the first position
query_col = type_variants_df.pop('query')
type_variants_df.insert(0, 'query', query_col)

# merge user and pangolin dataframes
merged_df = user_metadata_df.merge(pangolin_df, left_on='id', right_on = 'taxon', how='right').drop(columns = ['id']).rename(columns = {'taxon': 'id'})

# merge with type_variants dataframe
merged_df = merged_df.merge(type_variants_df, left_on='id', right_on = 'query', how='right').drop(columns = ['id']).rename(columns = {'query': 'id'})
id_col = merged_df.pop('id')
merged_df.insert(0, 'id', id_col)

merged_df.to_csv('combined_metadata.csv', index=False)  
