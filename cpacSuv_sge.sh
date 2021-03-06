#! /bin/bash
## SGE batch file - cpacFAB
#$ -S /bin/bash
## cpacFAB is the jobname and can be changed
#$ -N cpac_fab
## execute the job using the mpi_smp parallel enviroment and 8 cores per job
## create an array of 28 jobs the number of subjects
#$ -t 1-25
#$ -V
#$ -l mem_free=2G
#$ -pe openmp 4
## change the following working directory to a persistent directory that is
## available on all nodes, this is were messages printed by the app (stdout
## and stderr) will be stored
#$ -wd /mnt/MD1200A/fbarrios/cpac_BIDS_rdc/cluster_files

module add singularity/2.2
## sudo chmod 777 /mnt
mkdir -p /mnt/MD1200A/fbarrios/cpac_BIDS_rdc/cpac_cluster_files/log/reports

sge_ndx=$(( SGE_TASK_ID - 1 ))

# random sleep so that jobs dont start at _exactly_ the same time
sleep $(( $SGE_TASK_ID % 10 ))

singularity run -B /mnt:/mnt  -B /mnt/MD1200A/fbarrios/tmp:/scratch \
  /mnt/MD1200A/fbarrios/fbarrios/singularity_images/cpac_v1.0.1a_16 \
  --n_cpus 4 --mem_gb 8 \
  --pipeline_file /mnt/MD1200A/fbarrios/cpac_BIDS_rdc/BIDS_rdc_pipeline_config.y
ml \
  --data_config_file /mnt/MD1200A/fbarrios/cpac_BIDS_rdc/BIDS_rdc_data_config.ym
l \
  /mnt/MD1200A/fbarrios/BIDS_rdc/ \
  /mnt/MD1200A/fbarrios/cpac_BIDS_rdc/ \
  participant --participant_ndx ${sge_ndx}
