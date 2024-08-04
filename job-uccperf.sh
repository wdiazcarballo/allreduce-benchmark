#!/bin/bash
#SBATCH --job-name=ucc_perftest
#SBATCH --partition=helios
#SBATCH --nodes=4          # Change this to 8 or 16 as needed
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:05:00
#SBATCH --output=ucc_perftest_%j.log
#SBATCH --chdir=/global/home/users/rdmaworkshop08/wdc

# Load necessary modules
module load hpcx

# Set the collective type and message sizes
COLLECTIVE="allreduce"
MIN_COUNT=16384     # 16K bytes
MAX_COUNT=16777216  # 16M bytes
NUM_ITERATIONS=1000
WARMUP_ITERATIONS=100

# Get the node list
NODELIST=($(scontrol show hostnames $SLURM_JOB_NODELIST))
NODE_COUNT=${#NODELIST[@]}

# Run the UCC All-Reduce test
mpirun --bind-to core --map-by slot -np $NODE_COUNT opt/bin/ucc_perftest -c $COLLECTIVE -b $MIN_COUNT -e $MAX_COUNT -n $NUM_ITERATIONS -w $WARMUP_ITERATIONS