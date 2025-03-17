# freeradius Kubernetes setup
This is a base pattern for running freeradius on Kubernetes.
Here we use a simple shell-based installation method.
If you use it in your production environment you will use your preferred installation method e.g. ArgoCD, flux or ...

## Configuration-Options
To modify the freeradius configuration, we have to different ways.
1. Use a volume of type ```EmptyDir``` and a ```ConfigMap``` and define here all configuration-files
2. Use a persistent Volume and connet to your Pod to change here the configuration-files

### 1. EmptyDir and ConfigMap
Edit the cm-radius-raddb-overwrites.yaml and add here all your freeradius configuration-files.
But only real files not the file-links !

### 2. Volume
Enter your Pod:
```
kubectl -n radius exec -it radius-<Pod-Instancename> -- /bin/bash
```
Edit here the configuration in the directory: <b>/etc/raddb/</b>

## Configuration
```
git clone https://github.com/EHerzog76/docker-freeradius.git
cd docker-freeradius/kubernetes
chmod +x ./radius-install.sh
chmod +x ./kubectlwithenv.sh
```
Edit the ```cm-radius-raddb-overwrites.yaml```,```radius-deployment.yaml``` for your needs.<br>

### for OKD/OpenShift
Create a serviceaccount e.g. in the Namespace ```radius``` and assign the scc ```anyuid```:
```
oc -n radius create serviceaccount sa-radius
oc adm policy add-scc-to-user anyuid system:serviceaccount:radius:sa-radius

# Check if it is assigned:
oc adm policy who-can use scc anyuid
```

Uncoment this lines:
```
securityContext: {}
serviceAccount: sa-radius
serviceAccountName: sa-radius
```

## Setup / Deploy
```
#
# to see all parameters run:
#    radius-install.sh -h
radius-install.sh -kd k8sdomain.local -n namespace -kc <kubectl | oc>
```

## Build (Optional)
```
#For help:
./build-run.sh -h

./build-run.sh -u Username -p *** -n freeradius -v x.y.z -r https://your-container-repository.domain
```
