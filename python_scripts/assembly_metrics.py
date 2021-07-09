import argparse, os

parser = argparse.ArgumentParser(description = 'Perform bwa index analysis')
parser.add_argument("-pr", "--prefixout", help="prefixout", required=True)

#Storing argument on variables
args = parser.parse_args()
prefixout = args.prefixout

try:
    os.system(f"bedtools bamtobed -i {prefixout}.sorted.bam > {prefixout}.sorted.bed \
                    && samtools view {prefixout}.sorted.bam -u | bamdst --cutoffdepth 1000 -p {prefixout}.sorted.bed -o . \
                    && gunzip ./region.tsv.gz \
                    && gunzip ./depth.tsv.gz \
                    && sed -i -e 's/NC_045512\.2/'{prefixout}'/g' chromosomes.report \
                    && sed -i -e 's/__/\//g' -e 's/--/|/g' chromosomes.report")
                    && sed -i -e 's/NC_045512\.2/'{prefixout}'/g' -e 's/MN908947\.3/'{prefixout}'/g' -e 's/#Chromosome/SampleId/g' -e 's/__/\//g' -e 's/--/|/g' -e 's/Avg depth/AverageDepth/g' -e 's/Cov /Coverage/g' -e 's/%//g' chromosomes.report")
except:
    print("Error in assembly metrics step")
