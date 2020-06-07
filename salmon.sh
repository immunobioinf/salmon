#!/bin/bash

##================================================================================##
####################################################################################
##										  ##
## 	Title:	salmon								  ##	
## 	Author: Aimee L. Hanson							  ##
## 	Date:	05-06-2020							  ##
##										  ##
## 	RNASeq transcript quantification using Salmon			          ##
##	https://combine-lab.github.io/salmon/					  ##
##										  ##							
####################################################################################
##================================================================================##

if [[ ! $1 =~ .(fastq.gz|fastq|fq.gz|fq)$ ]] || [[ ! $2 =~ .(fastq.gz|fastq|fq.gz|fq)$ ]]; then
        echo "Please provide sample .fastq/.fastq.gz files for reads 1 and 2"
        exit 1
else
        echo "Provided files: $1 and $2"
fi

if [[ ! $3 =~ ^D7[0-9]{2}-D5[0-9]{2}$ ]]; then
	echo "Please provide index pair in format D7XX-D5XX"
	exit 1
else
	echo "Index pair: $3"
fi

rundate=`date +"%Y%m%d"`
start_time=`date -u +%s`

## Runid
runid="HHNGWDMXX"

## Directory containing salmon index of reference transcripts
index=/home/Index

## Directory for transcript quant outputs
quants=/home/TranscriptQuants
mkdir -p ${quants}/${rundate}_Salmon

sampleR1=$1
sampleR2=$2
indexpair=$3

######################################
## Quantify transcripts with salmon ##
######################################

printf "Quantifying transcripts for sample files\n${sampleR1} and\n${sampleR2}"

salmon quant \
-i ${index} \
-l ISR \
-1 ${sampleR1} \
-2 ${sampleR2} \
--gcBias \
--validateMappings \
--writeMappings \
--writeUnmappedNames \
-o ${quants}/${rundate}_Salmon/${rundate}_${runid}_${indexpair}_quant

end_time=`date -u +%s`
elapsed=$((end_time-start_time))

echo "Total of $((elapsed/3600)) hours, $(((elapsed/60)%60)) mins to complete"

