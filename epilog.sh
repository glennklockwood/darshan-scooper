#!/usr/bin/env bash

(
    flock --exclusive --nonblock 200 || exit 1

#   only move files if they do not exist
#   if stat -t /tmp/*_id${SLURM_JOB_ID}*_mmap-log-*.darshan > /dev/null 2>&1
#   then
#       mv -vf /tmp/*_id${SLURM_JOB_ID}*_mmap-log-*.darshan $SLURM_SUBMIT_DIR
#   fi

    part_ct=0
    part_sz=0
    for partial_log in /tmp/*_id${SLURM_JOB_ID}*_mmap-log-*.darshan
    do
        if [ -f "$partial_log" ]; then
            part_ct=$((part_ct + 1))
            sz=$(gzip -9 -c "${partial_log}" | uuencode -m - | wc -c)
            part_sz=$((part_sz + sz))
            echo "darshan_partial: job ${SLURM_JOB_ID} ${partial_log} on $(uname -n): ${part_sz} bytes" >> "${SLURM_SUBMIT_DIR}/${SLURM_JOB_ID}_darshan_partials.log"

            mv -vf "$partial_log" "$SLURM_SUBMIT_DIR"
        fi
    done

    if [ $part_ct -gt 0 ]; then
        echo "Found ${part_ct} files, ${part_sz} bytes on node $(uname -n)" >> "${SLURM_SUBMIT_DIR}/${SLURM_JOB_ID}_darshan_partials.log"
    fi
)200>/tmp/epilog_$SLURM_JOB_ID

# EPILOG_LOG="${SLURM_SUBMIT_DIR}_${RANDOM}.log"
# SENTINEL_FILE="/tmp/epilog_${SLURM_JOB_ID}"
# flock --exclusive --nonblock $SENTINEL_FILE --command move_logs >> "$EPILOG_LOG" || /bin/true
