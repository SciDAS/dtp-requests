# Data Transfer Pod - Requests

**WORK IN PROGRESS**

A Data Transfer Pod is a configurable collection of containers, each representing a different data transfer protocol/interface. 

All containers are mounted to the same Persisten Volume Claim(PVC), so users can easily move data to/from Kubernetes clusters and multiple endpoints with a single deployment.

DTP-Requests is an automated system that continually checks for data transfer jobs and deploys them in the appropriate container. 

**USE CASE:** DTP-Requests is intended to be deployed by an admin of a Kubernetes cluster that serves various end users, who do not have direct access to the cluster. The request system allows end users to submit data transfer jobs with minimal reliance on the admin.

DTP-Requests can be used to transfer data in and out of the cluster to a variety of endpoints, without direct access to the cluster.

For use cases with a single user, or a single group of users that have the permission to deploy pods using *kubectl*. , see [DTP-Personal](https://github.com/cbmckni/dtp). 

Right now, the supported protocols are:

 - [Google Cloud SDK](https://cloud.google.com/sdk) 
 - [Globus Connect Personal](https://app.globus.org/)
 - [iRODS](https://irods.org/)
 - [Named-Data Networking(NDN)](https://named-data.net/)
 - [Aspera CLI](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.2.0/featured_applications/aspera_cli.html)
 - [Amazon Web Services](https://aws.amazon.com/cli/)
 - [MinIO](https://min.io/)
 - [NCBI's SRA Tools](https://github.com/ncbi/sra-tools)

## End-Users

To get started as an end-user of DTP-Requests, you must have the permission to submit pull requests to the branch/fork that your k8s cluster is using. 

To achieve this, fork the branch/fork that your k8s cluster is using.

Next, create a script that performs your data transfer using the appropriate protocol.

It is highly recommended that this script is tested using the container associated with the protocol you are using. Here are the containers:

 - [Google Cloud SDK](https://hub.docker.com/r/google/cloud-sdk) 
 - [Globus Connect Personal](https://hub.docker.com/r/ndslabs/gcp-docker)
 - [iRODS](https://hub.docker.com/r/cbmckni/dtp-irods)
 - [Named-Data Networking(NDN)](https://hub.docker.com/r/cbmckni/ndn-tools)
 - [Aspera CLI](https://hub.docker.com/r/ibmcom/aspera-cli)
 - [Amazon Web Services](https://hub.docker.com/r/mesosphere/aws-cli)
 - [MinIO](https://hub.docker.com/r/minio/minio)
 - [NCBI's SRA Tools](https://hub.docker.com/r/ncbi/sra-tools)

### Considerations

Your script will be executed in the directory for your job. This directory is the name of your script without the *.sh*. For example, an Aspera job called aspera-job-1.sh will be executed in the directory `/workspace/dtp-jobs/dtp-aspera/aspera-job-1`.

Your script should use relative paths when possible, and all absolute paths should reflect this job directory.

### Job Submission

To submit a job, place your script in the approprate directory for your protocol. Then add, commit, and push to the branch/fork you created. Then submit a pull request to the branch/fork your cluster uses to add your script to it.  

If you are also an admin, you can go ahead and merge the new script in. If not, you will have to wait for an admin to approve your request and merge the script into the correct fork/branch.

Within 15 minutes of approval, a container with the correct protocol will be deployed to execute your script in the defined directory on the PVC. 

### Creating a Globus Connect Personal Endpoint (optional)

A [Globus Connect Personal](https://www.globus.org/globus-connect-personal) endpoint on a cluster gives users the ability to transfer, view, and delete files from the online GUI. 

To submit a Globus job to DTP-Requests, first install the [Globus CLI](https://docs.globus.org/cli/). 

To generate a new endpoint with an associated setup key, run:

`globus endpoint create --personal $ENDPOINT_NAME`

Copy the setup key, then modify and rename [endpoint.sh.example](https://github.com/SciDAS/dtp-requests/blob/master/dtp-globus/endpoint.sh.example) to describe your new endpoint.

Make sure the new file contains the correct setup key and ends with `.sh`.

Finally, submit the file as you normally would by forking the repo(if necessary) and issuing a pull request to the branch/fork your cluster is using.

Within 15 minutes of approval, a container with Globus COnnect Personal will be deployed to set up your endpoint in the defined directory on the PVC. 


## Installation

First, install dependencies:
 - Helm 3(2 may also work)
 - kubectl

Make sure both Helm and kubectl are configured properly with the Kubernetes cluster of your choosing.

The K8s cluster MUST have either a valid PVC or storage class. If a valid PVC or storage class does not exist, here are some example instructions to set up a NFS storage class:

### Create NFS StorageClass (optional)

Update Helm's repositories(similar to `apt-get update)`:

`helm repo update`

Next, install a NFS provisioner onto the K8s cluster to permit dynamic provisoning for **10Gb**(example) of persistent data:

`helm install kf stable/nfs-server-provisioner \`

`--set=persistence.enabled=true,persistence.storageClass=standard,persistence.size=10Gi`

Check that the `nfs` storage class exists:

`kubectl get sc`

Make sure to edit the [values.yaml](https://github.com/SciDAS/dtp-requests/blob/master/helm/values.yaml) file later to use this storage class and size!

## Configuration

These are the steps necessary to set up DTP-Requests.

The first step is deciding who will administer DTP-Requests. If the deployment is to be used in conjunction with a SciDAS Appstore(administered by SciDAS admins), create a new branch.

If it is not being used with a SciDAS Appstore, or you want to handle the requests, fork this repo.

Go into [values.yaml](https://github.com/SciDAS/dtp-requests/blob/master/helm/values.yaml).

Change the `branch` field to the correct branch/fork you created for your cluster to use.

Configure the PVC section to either create a new PVC or use an existing one. 

**One must be enabled, the other must be disabled.**


## Usage

To deploy DTP-Requests, run:

`helm install dtp-requests helm`

As an admin, you will be responsible for approving the pull-requests for end users.

See the End-User Guide above for more usage instructions.

## Delete

To destroy the DTP when all transfers are complete, run `helm uninstall dtp-requests`

That's it for now!




