#!/bin/bash

chmod 700 -R ../IAM_SARSCOV2

if [[ -z "$(which conda)" ]]; then
    cd
    wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -bfp miniconda3
    rm Miniconda3-latest-Linux-x86_64.sh
    echo 'export PATH=$HOME/miniconda3/bin:/usr/local/share/rsi/idl/bin:$PATH' >> $HOME/.*hrc
    export PATH=$HOME/miniconda3/bin:/usr/local/share/rsi/idl/bin:$PATH
    if [[ -z "$(which mamba)" ]]; then
        conda install -y -c conda-forge mamba
    else
        mamba update -y -n base conda
        mamba create -y -n iam_sarscov2 -c conda-forge -c bioconda -c defaults argparse bedtools bam-readcount biopython bwa fastp ivar mafft numpy pandas samtools==1.10 seqkit
        mamba create -y -n nextclade -c conda-forge -c bioconda -c defaults nodejs nextclade_js
        mamba create -y -n plot -c conda-forge -c bioconda -c defaults pysam numpy pandas seaborn
    fi
else
    if [[ -z "$(which mamba)" ]]; then
        conda install -y -c conda-forge mamba
    else
        mamba update -y -n base conda
        mamba create -y -n nextclade -c conda-forge -c bioconda -c defaults nodejs nextclade_js
        mamba create -y -n iam_sarscov2 -c conda-forge -c bioconda -c defaults argparse bedtools bam-readcount biopython bwa fastp ivar mafft numpy pandas samtools==1.10 seqkit
        mamba create -y -n plot -c conda-forge -c bioconda -c defaults pysam numpy pandas seaborn
    fi
fi

cd
git clone https://github.com/cov-lineages/pangolin.git
cd pangolin
mamba env create -f environment.yml
source activate pangolin
python setup.py install

cd
git clone https://github.com/shiquan/bamdst.git
cd bamdst
make

cd $HOME/IAM_SARSCOV2
wget https://github.com/dropbox/dbxcli/releases/download/v3.0.0/dbxcli-linux-amd64
chmod 700 dbxcli-linux-amd64

[ ! -d $HOME/bin ] && mkdir $HOME/bin -v
ln -s $HOME/IAM_SARSCOV2/dbxcli-linux-amd64 $HOME/bin/dbxcli
ln -s $HOME/IAM_SARSCOV2/fastcov/fastcov.py $HOME/bin/fastcov
ln -s $HOME/IAM_SARSCOV2/folder_info.sh $HOME/bin/folder_info
ln -s $HOME/IAM_SARSCOV2/iam_sarscov2.sh $HOME/bin/iam_sarscov2
ln -s $HOME/IAM_SARSCOV2/pangolin_nextclade.sh $HOME/bin/pangolin_nextclade
ln -s $HOME/IAM_SARSCOV2/sars2_assembly.sh $HOME/bin/sars2_assembly