#! /bin/sh

target=$1
reference=$2

plink --vcf $target.vcf --allow-extra-chr --set-missing-var-ids @:#,\$2,\$1 --geno 0.5 --maf 0.01 --make-bed --out $target.common

plink --bfile $target.common --freq --out $target.common


plink --vcf $reference.vcf --set-missing-var-ids @:#,\$2,\$1 --maf 0.01 --make-bed --out $reference.common

plink --bfile $reference.common --freq --out $reference.common


./overlapping.o $target.common $reference.common

plink --bfile $target.common --extract $target.common.overlap --make-bed --out $target.common.overlap

plink --bfile $reference.common --extract $reference.common.overlap --make-bed --out $reference.common.overlap

mv $reference.common.overlap.bim $reference.common.overlap.bim.backup

cp $target.common.overlap.bim $reference.common.overlap.bim

plink --bfile $target.common.overlap --bmerge $reference.common.overlap --make-bed --out $target.$reference.common

plink --bfile $target.$reference.common --pca --out $target.$reference

Rscript pca.R $target.$reference
