# PCA
principal component analysis

run pipeline.sh input.vcf

* reference 1000 Genome dataset was hard coded

Step 1: convert VCF file to PLINK file

Step 2: filter variants with MAF>1%

Step 3: extract variants that were overlapped in both target dataset and 1000 Genome Projoect

Step 4: change the variant names to make it consistent across the two datasets

Step 5: combined the two datasets and perform PCA

Step 6: population stratification using KNN
