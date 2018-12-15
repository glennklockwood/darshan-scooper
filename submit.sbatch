#!/usr/bin/env bash

srun --task-epilog=$SLURM_SUBMIT_DIR/epilog.sh $SLURM_SUBMIT_DIR/ior/src/ior

# srun --ntasks-per-node=1 $SLURM_SUBMIT_DIR/find_tmp.sh
