# docker-freeradius
Full configureable freeradius container.<br>
The big advantage over all other docker based freeradius implementations is,<br>
that this version can be configured as you need it, without to build a new container and on kubernetes no persistent volumes are needed.<br>

## Configuration for Docker
Edit the ```compose.yaml```
### Environment Variables
| Name | Values / Description |
| :---- | :---- |
| RAD_DEBUG | yes / no |
| LINKS_REMOVE | Links to remove in the /etc/raddb - directory |
| LINKS_ADD | Links to add to the /etc/raddb - directory |
| TZ | Timezone |

Start the container with:
```
docker compose up -d
```

## Configuration for Kubernetes and OKD/Openshift
See here in [./kubernetes/readme.md](https://github.com/EHerzog76/docker-freeradius/kubernetes/readme.md)
