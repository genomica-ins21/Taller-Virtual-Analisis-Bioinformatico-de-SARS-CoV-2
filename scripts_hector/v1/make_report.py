#!/usr/bin/env python3
import pandas as pd
import sys

#  read in files from command line arguments, 1) Pangolin output; 2) Nextclade output; 3) metrics.sh output 
if len(sys.argv) < 3:
    print('Incorrect command format.\nUSAGE: make_report.py <PANGOLIN_OUTPUT> <NEXTCLADE OUTPUT> <METRICS_OUTPUT>')
    sys.exit(1)

# get files from command line arguments
pangolin_output = sys.argv[1]
nextclade_output = sys.argv[2]
metrics_output = sys.argv[3]

# read and adapt pangolin
pangolin_df = pd.read_csv(pangolin_output)
pangolin_df = pangolin_df.rename(columns = {'taxon': 'id'})
pangolin_df = pangolin_df.drop(columns = ['pango_version','pangoLEARN_version','status'])
pangolin_df['id'] = pangolin_df['id'].str.replace('/ARTIC/nanopolish_MN908947.3','')



# read and adapt nextclade
nextclade_df = pd.read_csv(nextclade_output, sep=";")
nextclade_df = nextclade_df.rename(columns = {'seqName': 'id'})
nextclade_df = nextclade_df.drop(columns=['clade','qc.overallScore','qc.overallStatus','totalGaps','totalInsertions','totalMissing','totalMutations','totalNonACGTNs','totalPcrPrimerChanges','substitutions','missing','nonACGTNs','pcrPrimerChanges','totalAminoacidSubstitutions','aaDeletions','totalAminoacidDeletions','alignmentEnd','alignmentScore','alignmentStart','qc.missingData.missingDataThreshold','qc.missingData.score','qc.missingData.status','qc.missingData.totalMissing','qc.mixedSites.mixedSitesThreshold','qc.mixedSites.score','qc.mixedSites.status','qc.mixedSites.totalMixedSites','qc.privateMutations.cutoff','qc.privateMutations.excess','qc.privateMutations.score','qc.privateMutations.status','qc.privateMutations.total','qc.snpClusters.clusteredSNPs','qc.snpClusters.score','qc.snpClusters.status','qc.snpClusters.totalSNPs','errors'])
nextclade_df['id'] = nextclade_df['id'].str.replace('/ARTIC/nanopolish MN908947.3','')


# read and adapt metrics
metrics_df = pd.read_csv(metrics_output, sep=";")
metrics_df = metrics_df.rename(columns = {'Barcode': 'id'})
metrics_df['Coverage'] = metrics_df.eval('bases/29903')
metrics_df = metrics_df.drop(columns=['bases'])

# merge and save dataframes
merged_df = pd.merge(pangolin_df, metrics_df, on="id")
merged_df = pd.merge(merged_df, nextclade_df, on="id")
merged_df.to_csv('genomes_report.csv', sep=';', decimal=',', index=False)  
