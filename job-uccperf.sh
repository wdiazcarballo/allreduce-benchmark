#!/bin/bash
#SBATCH --job-name=ucc_perftest
#SBATCH --partition=helios
#SBATCH --nodes=4          
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --output=ucc_perftest_%j.log
#SBATCH --chdir=/global/home/users/rdmaworkshop08/wdc/ucc-perf

# Load necessary modules
module load hpcx

# Set the message sizes
MSG_SIZES="16K 64K 256K 1M 4M 16M"

# Get the node list
NODELIST=($(scontrol show hostnames $SLURM_JOB_NODELIST))
NODE_COUNT=${#NODELIST[@]}

# Run the UCC All-Reduce test
for MSG_SIZE in $MSG_SIZES; do
    srun --nodes=$NODE_COUNT --ntasks=$NODE_COUNT ../opt/bin/ucc_perftest -t allreduce -m $MSG_SIZE -c 0
done
