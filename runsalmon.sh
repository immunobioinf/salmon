#!/bin/bash
#PBS -N salmon
#PBS -l walltime=50:00:00
#PBS -l select=2:ncpus=12:mem=50g
#PBS -j oe
#PBS -o /home/hansona/TCRgdProject/Containers/RunFiles/20200608-runsalmon-^array_index^.log
#PBS -M aimee.hanson@qut.edu.au
#PBS -m e
#PBS -J 1-32

source /etc/profile.d/modules.sh

module load atg/singularity/3.1.1

cd /home/hansona/TCRgdProject/Containers/salmon

## Local sample files (pre-processed)
fastq=/home/hansona/TCRgdProject/ReadProcessing/MergedFastq/20200603_PreProcessed
indexlist=${fastq}/../IndexPairs.txt

index=`sed -n "$PBS_ARRAY_INDEX p" ${indexlist}`

i7=`cut -d " " -f1 <<< ${index}`
i5=`cut -d " " -f2 <<< ${index}`
pair="${i7}-${i5}"

sampleR1=`ls ${fastq}/*.fq | grep "${pair}_R1_good.fq" | xargs basename`
sampleR2=`ls ${fastq}/*.fq | grep "${pair}_R2_good.fq" | xargs basename`

singularity exec -B /home/hansona/TCRgdProject/ReadProcessing/MergedFastq/20200603_PreProcessed:/home/Fastq -B /home/hansona/TCRgdProject/TranscriptQuants:/home/TranscriptQuants -B /home/hansona/TCRgdProject/GenomeRefs/hg38/salmon_sa_index/default:/home/Index docker://combinelab/salmon:latest /bin/bash salmon.sh /home/Fastq/${sampleR1} /home/Fastq/${sampleR2} ${pair}
