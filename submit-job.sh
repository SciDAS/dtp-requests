#!/bin/bash

job=$2
jobname=${2%.sh}
jobyaml="${jobname}.yaml"
dir=$1
jobuid=$3

cd /workspace/dtp-jobs/$dir/$jobname

case $1 in
    dtp-aspera)
        cat <<EOF > "$jobyaml"
apiVersion: batch/v1
kind: Job
metadata:
  name: dtp-aspera-${jobname}-${jobuid}
spec:
  template:
    spec:
      containers:
      - name: dtp-aspera-${jobname}-${jobuid}
        image: ibmcom/aspera-cli
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "cd /workspace/dtp-jobs/${dir}/${jobname} && echo ${jobname}-${jobuid} && (time ./${job}) >> ${jobname}.log 2>&1" ]
        resources:
          requests:
            cpu: 1
            memory: 4Gi
          limits:
            cpu: 1
            memory: 4Gi
        volumeMounts:
        - name: vol-1
          mountPath: ${PVCPATH}
      restartPolicy: Never
      volumes:
        - name: vol-1
          persistentVolumeClaim:
            claimName: ${PVCNAME}
  backoffLimit: 4
EOF
        ;;
    dtp-aws)
        cat <<EOF > "$jobyaml"
apiVersion: batch/v1
kind: Job
metadata:
  name: dtp-aws-${jobname}-${jobuid}
spec:
  template:
    spec:
      containers:
      - name: dtp-aws-${jobname}-${jobuid}
        image: mesosphere/aws-cli
        command: ["/bin/sh"]
        args: ["-c", "cd /workspace/dtp-jobs/${dir}/${jobname} && apk update && apk upgrade && apk add bash && echo ${jobname}-${jobuid} && (time ./${job}) >> ${jobname}.log 2>&1" ]
        resources:
          requests:
            cpu: 1
            memory: 4Gi
          limits:
            cpu: 1
            memory: 4Gi
        volumeMounts:
        - name: vol-1
          mountPath: ${PVCPATH}
      restartPolicy: Never
      volumes:
        - name: vol-1
          persistentVolumeClaim:
            claimName: ${PVCNAME}
  backoffLimit: 4
EOF
        ;;
    dtp-gcp)
        cat <<EOF > "$jobyaml"
apiVersion: batch/v1
kind: Job
metadata:
  name: dtp-google-${jobname}-${jobuid}
spec:
  template:
    spec:
      containers:
      - name: dtp-google-${jobname}-${jobuid}
        image: google/cloud-sdk
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "cd /workspace/dtp-jobs/${dir}/${jobname} && echo ${jobname}-${jobuid} && (time ./${job}) >> ${jobname}.log 2>&1" ]
        resources:
          requests:
            cpu: 1
            memory: 4Gi
          limits:
            cpu: 1
            memory: 4Gi
        volumeMounts:
        - name: vol-1
          mountPath: ${PVCPATH}
      restartPolicy: Never
      volumes:
        - name: vol-1
          persistentVolumeClaim:
            claimName: ${PVCNAME}
  backoffLimit: 4
EOF
        ;;
    dtp-irods)
        cat <<EOF > "$jobyaml"
apiVersion: batch/v1
kind: Job
metadata:
  name: dtp-irods-${jobname}-${jobuid}
spec:
  template:
    spec:
      containers:
      - name: dtp-irods-${jobname}-${jobuid}
        image: cbmckni/dtp-irods
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "cd /workspace/dtp-jobs/${dir}/${jobname} && echo ${jobname}-${jobuid} && (time ./${job}) >> ${jobname}.log 2>&1" ]
        resources:
          requests:
            cpu: 1
            memory: 4Gi
          limits:
            cpu: 1
            memory: 4Gi
        volumeMounts:
        - name: vol-1
          mountPath: ${PVCPATH}
      restartPolicy: Never
      volumes:
        - name: vol-1
          persistentVolumeClaim:
            claimName: ${PVCNAME}
  backoffLimit: 4
EOF
        ;;
    dtp-minio)
        cat <<EOF > "$jobyaml"
apiVersion: batch/v1
kind: Job
metadata:
  name: dtp-minio-${jobname}-${jobuid}
spec:
  template:
    spec:
      containers:
      - name: dtp-minio-${jobname}-${jobuid}
        image: minio/mc
        command: ["/bin/sh"]
        args: ["-c", "cd /workspace/dtp-jobs/${dir}/${jobname} && apk update && apk upgrade && apk add bash && echo ${jobname}-${jobuid} && (time ./${job}) >> ${jobname}.log 2>&1" ]
        resources:
          requests:
            cpu: 1
            memory: 4Gi
          limits:
            cpu: 1
            memory: 4Gi
        volumeMounts:
        - name: vol-1
          mountPath: ${PVCPATH}
      restartPolicy: Never
      volumes:
        - name: vol-1
          persistentVolumeClaim:
            claimName: ${PVCNAME}
  backoffLimit: 4
EOF
        ;;
    dtp-ndn)
        cat <<EOF > "$jobyaml"
apiVersion: batch/v1
kind: Job
metadata:
  name: dtp-ndn-${jobname}-${jobuid}
spec:
  template:
    spec:
      containers:
      - name: dtp-ndn-${jobname}-${jobuid}
        image: cbmckni/ndn-tools
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "cd /workspace/dtp-jobs/${dir}/${jobname} && echo ${jobname}-${jobuid} && (time ./${job}) >> ${jobname}.log 2>&1" ]
        resources:
          requests:
            cpu: 1
            memory: 4Gi
          limits:
            cpu: 1
            memory: 4Gi
        volumeMounts:
        - name: vol-1
          mountPath: ${PVCPATH}
      restartPolicy: Never
      volumes:
        - name: vol-1
          persistentVolumeClaim:
            claimName: ${PVCNAME}
  backoffLimit: 4
EOF
        ;;
    dtp-sra-tools)
        cat <<EOF > "$jobyaml"
apiVersion: batch/v1
kind: Job
metadata:
  name: dtp-sra-tools-${jobname}-${jobuid}
spec:
  template:
    spec:
      containers:
      - name: dtp-sra-tools-${jobname}-${jobuid}
        image: ncbi/sra-tools
        command: [ "/bin/sh" ]
        args: ["-c", "cd /workspace/dtp-jobs/${dir}/${jobname} && apk update && apk upgrade && apk add --no-cache util-linux bash && echo ${jobname}-${jobuid} && (time ./${job}) >> ${jobname}.log 2>&1" ]
        resources:
          requests:
            cpu: 1
            memory: 4Gi
          limits:
            cpu: 1
            memory: 4Gi
        volumeMounts:
        - name: vol-1
          mountPath: ${PVCPATH}
      restartPolicy: Never
      volumes:
        - name: vol-1
          persistentVolumeClaim:
            claimName: ${PVCNAME}
  backoffLimit: 4
EOF
        ;;
    dtp-globus)
        source /workspace/dtp-jobs/${dir}/${jobname}/${job}
        cat <<EOF > "$jobyaml"
apiVersion: batch/v1
kind: Job
metadata:
  name: dtp-globus-${jobname}-${jobuid}
spec:
  template:
    spec:
      containers:
      - name: dtp-globus-${jobname}-${jobuid}
        image: ndslabs/gcp-docker
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "/opt/globusconnectpersonal/start-globus-connect.sh ${GLOBUS_KEY} ${PVCPATH}/dtp-jobs && echo 'globus done'" ]
        resources:
          requests:
            cpu: 1
            memory: 4Gi
          limits:
            cpu: 1
            memory: 4Gi
        volumeMounts:
        - name: vol-1
          mountPath: ${PVCPATH}
      restartPolicy: Never
      volumes:
        - name: vol-1
          persistentVolumeClaim:
            claimName: ${PVCNAME}
  backoffLimit: 4
EOF
        ;;
    *)
        echo "Protocol ${dir} not found."
        exit 1
        ;;
esac

kubectl create -f $jobyaml
echo "Job ${jobname} submitted. Job ID is ${jobuid}"
