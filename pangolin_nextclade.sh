#!/bin/bash

# author: Laise de Moraes <laisepaixao@live.com>
# institution: Oswaldo Cruz Foundation, Gonçalo Moniz Institute, Bahia, Brazil
# URL: https://lpmor22.github.io
# date: 10 JUN 2021

background() {

    start=$(date +%s.%N)

    DATE="$(date +'%Y-%m-%d')"

    THREADS=$(lscpu | grep 'CPU(s):' | awk '{print $2}' | sed -n '1p')

    cat *consensus.fa > pangolin_nextclade.tmp

    source activate pangolin

    pangolin --update

    pangolin pangolin_nextclade.tmp -t "$THREADS" --outfile pangolin.tmp

    cat pangolin.tmp | (sed -u 1q; sort) | sed -e 's/\,/\t/g' > pangolin_all_"$DATE".txt

    source activate nextclade

    mamba update -y -n nextclade --all

    nextclade -i pangolin_nextclade.tmp -j "$THREADS" -c nextclade.tmp

    cat nextclade.tmp | (sed -u 1q; sort) | sed -e 's/\;/\t/g' > nextclade_all_"$DATE".txt

    rm -rf *tmp

    end=$(date +%s.%N)

    runtime=$(python -c "print(${end} - ${start})")

    echo "" && echo "Done. The runtime was $runtime seconds."

}

background &>pangolin_nextclade_log_"$(date +'%Y-%m-%d')".txt &
