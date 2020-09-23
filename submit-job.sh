#!/bin/bash

job=$2
jobname=${2%.sh}
jobyaml="${jobname}.yaml"
dir=$1
jobuid=$3

echo ${BRANCH}
echo ${PVCPATH}
echo ${PVCNAME}

cd /workspace/dtp-jobs/$dir/$jobname

case $1 in
    dtp-aspera)
        cat <<EOF > "$jobyaml"
apiVersion: batch/v1
kind: Job
metadata:
  name: ${jobname}
spec:
  template:
    spec:
      securityContext:
        runAsUser: ${jobuid}
        runAsGroup: ${jobuid}
        fsGroup: ${jobuid}
      containers:
      - name: ${jobname}
        image: ibmcom/aspera-cli
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "cd /workspace/dtp-jobs/${dir}/${jobname} && ${job} && chmod -R 755 /workspace/dtp-jobs/${dir}/${jobname}" ]
      restartPolicy: Never
      resources:
          requests:
            cpu: 1
            memory: 2Gi
          limits:
            cpu: 1
            memory: 2Gi
      volumeMounts:
      - name: vol-1
        mountPath: ${PVCPATH}
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
  name: ${jobname}
spec:
  template:
    spec:
      securityContext:
        runAsUser: ${jobuid}
        runAsGroup: ${jobuid}
        fsGroup: ${jobuid}
      containers:
      - name: ${jobname}
        image: mesosphere/aws-cli
        command: ["/bin/sh"]
        args: ["-c", "apk update && apk upgrade && apk add bash && cd /workspace/dtp-jobs/${dir}/${jobname} && ${job} && chmod -R 755 /workspace/dtp-jobs/${dir}/${jobname}" ]
      restartPolicy: Never
      resources:
          requests:
            cpu: 1
            memory: 2Gi
          limits:
            cpu: 1
            memory: 2Gi
      volumeMounts:
      - name: vol-1
        mountPath: ${PVCPATH}
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
  name: ${jobname}
spec:
  template:
    spec:
      securityContext:
        runAsUser: ${jobuid}
        runAsGroup: ${jobuid}
        fsGroup: ${jobuid}
      containers:
      - name: ${jobname}
        image: google/cloud-sdk
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "cd /workspace/dtp-jobs/${dir}/${jobname} && ${job} && chmod -R 755 /workspace/dtp-jobs/${dir}/${jobname}" ]
      restartPolicy: Never
      resources:
          requests:
            cpu: 1
            memory: 2Gi
          limits:
            cpu: 1
            memory: 2Gi
      volumeMounts:
      - name: vol-1
        mountPath: ${PVCPATH}
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
  name: ${jobname}
spec:
  template:
    spec:
      securityContext:
        runAsUser: ${jobuid}
        runAsGroup: ${jobuid}
        fsGroup: ${jobuid}
      containers:
      - name: ${jobname}
        image: cbmckni/dtp-irods
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "cd /workspace/dtp-jobs/${dir}/${jobname} && ${job} && chmod -R 755 /workspace/dtp-jobs/${dir}/${jobname}" ]
      restartPolicy: Never
      resources:
          requests:
            cpu: 1
            memory: 2Gi
          limits:
            cpu: 1
            memory: 2Gi
      volumeMounts:
      - name: vol-1
        mountPath: ${PVCPATH}
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
  name: ${jobname}
spec:
  template:
    spec:
      securityContext:
        runAsUser: ${jobuid}
        runAsGroup: ${jobuid}
        fsGroup: ${jobuid}
      containers:
      - name: ${jobname}
        image: minio/mc
        command: ["/bin/sh"]
        args: ["-c", "apk update && apk upgrade && apk add bash && cd /workspace/dtp-jobs/${dir}/${jobname} && ${job} && chmod -R 755 /workspace/dtp-jobs/${dir}/${jobname}" ]
      restartPolicy: Never
      resources:
          requests:
            cpu: 1
            memory: 2Gi
          limits:
            cpu: 1
            memory: 2Gi
      volumeMounts:
      - name: vol-1
        mountPath: ${PVCPATH}
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
  name: ${jobname}
spec:
  template:
    spec:
      securityContext:
        runAsUser: ${jobuid}
        runAsGroup: ${jobuid}
        fsGroup: ${jobuid}
      containers:
      - name: ${jobname}
        image: cbmckni/ndn-tools
        command: [ "/bin/bash", "-c", "--" ]
        args: [ "'/usr/local/bin/nfd -c $CONFIG > $LOG_FILE 2>&1' && cd /workspace/dtp-jobs/${dir}/${jobname} && ${job} && chmod -R 755 /workspace/dtp-jobs/${dir}/${jobname}" ]
      restartPolicy: Never
      resources:
          requests:
            cpu: 1
            memory: 2Gi
          limits:
            cpu: 1
            memory: 2Gi
      volumeMounts:
      - name: vol-1
        mountPath: ${PVCPATH}
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
  name: ${jobname}
spec:
  template:
    spec:
      securityContext:
        runAsUser: ${jobuid}
        runAsGroup: ${jobuid}
        fsGroup: ${jobuid}
      containers:
      - name: ${jobname}
        image: ncbi/sra-tools
        command: [ "/bin/sh" ]
        args: ["-c", "apk update && apk upgrade && apk add bash && cd /workspace/dtp-jobs/${dir}/${jobname} && ${job} && chmod -R 755 /workspace/dtp-jobs/${dir}/${jobname}" ]
      restartPolicy: Never
      resources:
          requests:
            cpu: 1
            memory: 2Gi
          limits:
            cpu: 1
            memory: 2Gi
      volumeMounts:
      - name: vol-1
        mountPath: ${PVCPATH}
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