# principal component analysis

precompile: g++ overlapping.cpp -o overlapping.o

Usage: pipeline.sh input.vcf 1000Genome.vcf


Step 1: convert VCF file to PLINK file

Step 2: filter variants with MAF>1%

Step 3: extract variants that were overlapped in both target dataset and 1000 Genome Projoect

Step 4: change the variant names to make it consistent across the two datasets

Step 5: combined the two datasets and perform PCA

Step 6: population stratification using KNN

Step 7: plot the first six principal components
