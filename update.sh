#!/bin/bash


git clone https://github.com/cbmckni/dtp-requests.git /workspace
cd /workspace/dtp-requests
for dir in */ ; do
    mkdir -p /workspace/dtp-jobs/$dir
    cd /workspace/dtp-requests/$dir
    for job in *.sh ; do
        jobname=${job%.sh}
        mkdir /workspace/dtp-jobs/$dir/$jobname || (echo "Job already submitted: ${job}" && continue)
        cp $job /workspace/dtp-jobs/$dir/$jobname
        submit-job.sh $dir $job
    done
done
    
