#!/bin/bash
#SBATCH --job-name=4N-all
#SBATCH --partition=helios
#SBATCH --nodes=4          # Using 4 nodes
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:10:00    # Adjust time as necessary
#SBATCH --output=4N-all_%j.log
#SBATCH --chdir=/global/home/users/rdmaworkshop08/wdc

# Load necessary modules
module load gcc hpcx

# Use our version of UCC
export LD_LIBRARY_PATH=/global/home/users/rdmaworkshop08/wdc/opt/lib/ucc:$LD_LIBRARY_PATH
export OMPI_MCA_coll_tuned_use_dynamic_rules=1

# Set the collective type and message sizes
COLLECTIVE="allreduce"
MSG_SIZES="16384 65536 262144 1048576 4194304 16777216"  # 16K - 16 Mbytes
NUM_ITERATIONS=10
WARMUP_ITERATIONS=2

# Test allreduce algorithm IDs from 0 to 4
for ALGO_ID in {0..4}
do
    echo "=========================================="
    echo "Testing OMPI_MCA_coll_tuned_allreduce_algorithm=$ALGO_ID"
    echo "=========================================="
    export OMPI_MCA_coll_tuned_allreduce_algorithm=$ALGO_ID

    for MSG_SIZE in $MSG_SIZES; do
        echo "Running test for message size: $MSG_SIZE with algorithm ID: $ALGO_ID"
        mpirun --bind-to core --map-by slot -np 4 opt/bin/ucc_perftest -c $COLLECTIVE -b $MSG_SIZE -e $MSG_SIZE -n $NUM_ITERATIONS -w $WARMUP_ITERATIONS
        if [ $? -ne 0 ]; then
            echo "Test for message size $MSG_SIZE with algorithm ID $ALGO_ID failed, skipping."
        fi
    done
done
