#!/usr/bin/env python3
import pandas as pd
import sys

#  read in files from command line arguments, 1) metadata.tsv 
if len(sys.argv) < 1:
    print('Incorrect command format.\nUSAGE: filter.py <GISAIAD METADATA>')
    sys.exit(1)

# get files from command line arguments
gisaid = sys.argv[1]


# read and adapt pangolin
metadata_df = pd.read_csv(gisaid, sep='\t', dtype={'Variant': str, 'Is reference?': str, 'AA Substitutions': str})
metadata_df = metadata_df.drop(columns = ['Type','Host','Pangolin version', 'GC-Content', 'Sequence length'])
metadata_df.head()
metadata_df = metadata_df[metadata_df['AA Substitutions'].str.contains("N501Y", na=False)]
metadata_df = metadata_df[metadata_df['AA Substitutions'].str.contains("E484K", na=False)]
metadata_df = metadata_df[metadata_df['AA Substitutions'].str.contains("P681H", na=False)]
metadata_df.to_csv('filtered_metadata.tsv', sep='\t', decimal=',', index=False)
