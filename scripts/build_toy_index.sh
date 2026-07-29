#!/usr/bin/env bash
# Build the tutorial's toy host index for VANISH from the committed chrM.fa
# (human mitochondrial genome). Requires bowtie2, which is provided by the
# vanish-env conda environment:  mamba activate vanish-env
set -euo pipefail

HERE="$(cd "$(dirname "$0")/../data/host_index" && pwd)"
cd "$HERE"

# chrM.fa is committed to the repo. To re-fetch it from NCBI:
#   curl -fsS "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nucleotide&id=NC_012920.1&rettype=fasta&retmode=text" -o chrM.fa

bowtie2-build chrM.fa toy_human
echo
echo "Built toy_human.* in $HERE"
echo "Point VANISH at it with:  --host_index data/host_index/toy_human"
