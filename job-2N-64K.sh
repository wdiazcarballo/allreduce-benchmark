#!/bin/bash
#SBATCH --job-name=allreduce-2N-64K
#SBATCH --partition=helios
#SBATCH --nodes=2          # Using 2 nodes
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:10:00    # Adjust time as necessary
#SBATCH --output=allreduce-2N-64K_%j.log
#SBATCH --chdir=/global/home/users/rdmaworkshop08/wdc

# Load necessary modules
module load hpcx

# Set the collective type and message size
COLLECTIVE="allreduce"
MSG_SIZE=16384  # 16K bytes
NUM_ITERATIONS=10
WARMUP_ITERATIONS=2

# Run the UCC All-Reduce test using mpirun
mpirun --bind-to core --map-by slot -np 2 opt/bin/ucc_perftest -c $COLLECTIVE -b $MSG_SIZE -e $MSG_SIZE -n $NUM_ITERATIONS -w $WARMUP_ITERATIONS
