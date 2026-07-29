#!/usr/bin/env bash
# Provenance: how data/rawdata_10K was created from the full-depth FASTQs.
# The teaching subset is the FIRST 10,000 read pairs of each sample
# (head-based, so R1/R2 stay perfectly in sync and pairing is preserved).
# The full raw reads are on NCBI SRA, BioProject PRJNA587635.
#
# Usage:  scripts/make_subset.sh <full_rawdata_dir> [out_dir]
#   <full_rawdata_dir> holds SRRxxxx_1.fastq.gz / SRRxxxx_2.fastq.gz
set -euo pipefail

RAW="${1:?path to the full rawdata directory}"
OUT="${2:-data/rawdata_10K}"
N_READS=10000
N_LINES=$((N_READS * 4))

mkdir -p "$OUT"
for r1 in "$RAW"/*_1.fastq.gz; do
  b="$(basename "$r1" _1.fastq.gz)"
  gunzip -c "$RAW/${b}_1.fastq.gz" | head -n "$N_LINES" | gzip > "$OUT/${b}_1.fastq.gz"
  gunzip -c "$RAW/${b}_2.fastq.gz" | head -n "$N_LINES" | gzip > "$OUT/${b}_2.fastq.gz"
  echo "subset $b"
done
echo "Done → $OUT  (first $N_READS read pairs per sample)"
