#!/bin/bash


git clone https://github.com/cbmckni/dtp-requests.git /workspace
cd /workspace/dtp-requests
for dir in dtp-*/ ; do
    dir=${dir%/}
    mkdir -p /workspace/dtp-jobs/$dir
    cd /workspace/dtp-requests/$dir
    for job in *.sh ; do
        jobname=${job%.sh}
        jobuid=$((1000 + RANDOM % 4294967295))
        echo $dir
        echo $job
        echo $jobname
        echo $jobuid
        if (mkdir /workspace/dtp-jobs/$dir/$jobname && chmod -R 777 /workspace/dtp-jobs) ; then
            echo "Submitting Job: ${job}"
            cp $job /workspace/dtp-jobs/$dir/$jobname
            /workspace/dtp-requests/submit-job.sh $dir $job $jobuid
        else
            echo "Job already submitted: ${job}"
        fi
    done
done
echo "DTP Requests update complete! Exiting..."
