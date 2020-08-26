#!/bin/bash


git clone https://github.com/cbmckni/dtp-requests.git /workspace
cd /workspace/dtp-requests
for dir in */ ; do
    mkdir -p /workspace/dtp-jobs/$dir
    cd /workspace/dtp-requests/$dir
    for job in *.sh ; do
        jobname=${job%.sh}
        jobuid=$((1000 + RANDOM % 4294967295))
        (mkdir /workspace/dtp-jobs/$dir/$jobname && chown -R $jobuid:$jobuid /workspace/dtp-jobs/$dir/$jobname) || (echo "Job already submitted: ${job}" && continue)
        cp $job /workspace/dtp-jobs/$dir/$jobname
        submit-job.sh $dir $job $jobuid
    done
done
echo "DTP Requests update complete! Exiting..."
