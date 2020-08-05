#!/bin/bash


cd /workspace/dtp-requests/$1
for job in *.sh ; do
    if /bin/bash "$job" > "$job".log 2>&1 ; then
        echo "Job succeeded" "$job"
        mv "$job" "$job".success
    else
        echo "Job failed" "$job"
        mv "$job" "$job".fail
    fi
done
