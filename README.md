# docker-freeradius
Full configureable freeradius container.<br>
The big advantage over all other docker based freeradius implementations is,<br>
that this version can be configured as you need it, without to build a new container and on kubernetes no persistent volumes are needed.<br>

## Configuration for Docker
Edit the ```compose.yaml``` and start the container with:
```
docker compose up -d
```

## Configuration for Kubernetes and OKD/Openshift
See here in [./kubernetes/readme.md](https://github.com/EHerzog76/docker-freeradius/kubernetes/readme.md)
