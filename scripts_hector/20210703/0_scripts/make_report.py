#!/usr/bin/env python3
import pandas as pd
import sys
import numpy as np

#  read in files from command line arguments, 1) Pangolin output; 2) Nextclade output; 3) metrics.sh output; 4) metadata
if len(sys.argv) < 4:
    print('Incorrect command format.\nUSAGE: make_report.py <PANGOLIN_OUTPUT> <NEXTCLADE OUTPUT> <METRICS_OUTPUT> <METADATA>')
    sys.exit(1)

# get files from command line arguments
pangolin_output = sys.argv[1]
nextclade_output = sys.argv[2]
metrics_output = sys.argv[3]
metadata_input = sys.argv[4]

# read and adapt pangolin
pangolin_df = pd.read_csv(pangolin_output)
pangolin_df = pangolin_df.rename(columns = {'taxon': 'barcode', 'lineage':'Linaje', 'note':'Nota pangolin'})
pangolin_df = pangolin_df.drop(columns = ['pango_version','pangoLEARN_version','status','pangolin_version','conflict','ambiguity_score','scorpio_conflict','version'])
pangolin_df['barcode'] = pangolin_df['barcode'].str.replace('/ARTIC/nanopolish_MN908947.3','')



# read and adapt nextclade
nextclade_df = pd.read_csv(nextclade_output, sep=";")
nextclade_df = nextclade_df.rename(columns = {'seqName': 'barcode', 'aaSubstitutions':'aaSustituciones','deletions':'Deleciones', 'insertions':'Inserciones'})
nextclade_df = nextclade_df.drop(columns=['clade','qc.overallScore','qc.overallStatus','totalDeletions','totalInsertions','totalSubstitutions','totalNonACGTNs','totalPcrPrimerChanges','substitutions','missing','nonACGTNs','pcrPrimerChanges','totalAminoacidSubstitutions','aaDeletions','totalAminoacidDeletions','alignmentEnd','alignmentScore','alignmentStart','qc.missingData.missingDataThreshold','qc.missingData.score','qc.missingData.status','qc.missingData.totalMissing','qc.mixedSites.mixedSitesThreshold','qc.mixedSites.score','qc.mixedSites.status','qc.mixedSites.totalMixedSites','qc.privateMutations.cutoff','qc.privateMutations.excess','qc.privateMutations.score','qc.privateMutations.status','qc.privateMutations.total','qc.snpClusters.clusteredSNPs','qc.snpClusters.score','qc.snpClusters.status','qc.snpClusters.totalSNPs','errors'])
nextclade_df['barcode'] = nextclade_df['barcode'].str.replace('/ARTIC/nanopolish MN908947.3','')
nextclade_df['Cobertura'] = nextclade_df.eval('1-(totalMissing/29903)')

# read and adapt metrics
metrics_df = pd.read_csv(metrics_output, sep=";")
metrics_df = metrics_df.rename(columns = {'Barcode': 'barcode','Avg.depth':'Profundidad'})
metrics_df['Cobertura_metricas'] = metrics_df.eval('bases/29903')
metrics_df = metrics_df.drop(columns=['bases'])

# read and adapt metadata
metadata_df = pd.read_csv(metadata_input, sep=";", encoding = 'latin-1')

# merge and save dataframes
merged_df = pd.merge(pangolin_df, metrics_df, on="barcode")
merged_df = pd.merge(merged_df, nextclade_df, on="barcode")
merged_df = pd.merge(merged_df, metadata_df, on="barcode")
merged_df['Observaciones']=np.nan
merged_df = merged_df[['Cod.','ID','Linaje','scorpio_call','scorpio_support','Fecha secuencia','barcode','Procedencia','Fecha muestra','Sexo','Edad','Estado','Deleciones','Inserciones','aaSustituciones','Cobertura','Profundidad','Observaciones']]
merged_df.to_csv('reporte_genomas.csv', sep=';', decimal=',', index=False)
