# freeradius Kubernetes setup
This is a base pattern for running freeradius on Kubernetes.
Here we use a simple shell-based installation method.
If you use it in your production environment you will use your preferred installation method e.g. ArgoCD, flux or ...

## Configuration
To modify the freeradius configuration, we have to different ways.
1. Use a ConfigMap and define here all configuration-files
2. Use a Volume and connet to your Pod to change here the configuration-files

### 1. ConfigMap
Edit the cm-radius-raddb-overwrites.yaml and add here all your freeradius configuration-files.
But only real files not the file-links !

### 2. Volume
Enter your Pod:
```
kubectl -n radius exec -it radius-<Pod-Instancename> -- /bin/bash
```
Edit here the configuration in the directory: <b>/etc/raddb/<b>

## Setup / Deploy
```
git clone https://github.com/EHerzog76/docker-freeradius.git
cd docker-freeradius/kubernetes
#
# to see all parameters run:
#    radius-install.sh -h
radius-install.sh -kd k8sdomain.local -n namespace -kc <kubectl | oc>
```

## Build (Optional)

