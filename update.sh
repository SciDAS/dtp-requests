#!/bin/bash

POD="$(kubectl get pods | grep dtp | grep Running | awk '{print $1}')"
ARRAY=($(kubectl get pods ${POD} -o jsonpath='{.spec.containers[*].name}'))

if [ ! -d /workspace/dtp-requests ]
then
    git clone https://github.com/cbmckni/dtp-requests.git /workspace/dtp-requests
else
    cd /workspace/dtp-requests
    git pull origin master
fi

for CONTAINER in "${ARRAY[@]}" ; do
    cd /workspace/dtp-requests/${CONTAINER}
    for job in *.sh ; do
        if kubectl exec -it ${POD} --container ${CONTAINER} -- /bin/bash "$job" ; then
            echo "Job succeeded" "$job"
            mv "$job" "$job".success
        else
            echo "Job failed" "$job"
            mv "$job" "$job".fail
        fi
    done
done
