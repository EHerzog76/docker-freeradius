# docker-freeradius
Full configureable freeradius container.<br>
The big advantage over all other docker based freeradius implementations is,<br>
that this version can be configured as you need it, without to build a new container and on kubernetes no persistent volumes are needed.<br>

## Configuration for Docker
Edit the [compose.yaml](https://github.com/EHerzog76/docker-freeradius/blob/main/compose.yaml)

### Environment Variables
| Name | Values / Description |
| :---- | :---- |
| RAD_DEBUG | yes / no |
| LINKS_REMOVE | Links to remove in the /etc/raddb - directory |
| LINKS_ADD | Links to add to the /etc/raddb - directory |
| TZ | Timezone |

### Volumes
| Path | Description |
| :---- | :---- |
| /etc/raddb | The freeradius  raddb, on container start, the original radius-raddb will be synced to this folder (no files will be overwritten). |
| /raddb-overwrites | Optional, all config files from here will be synced to the /etc/raddb (existing files will be overwritten). |

Start the container with:
```
docker compose up -d
```

## Configuration for Kubernetes and OKD/Openshift
See here in [./kubernetes/readme.md](https://github.com/EHerzog76/docker-freeradius/blob/main/kubernetes/readme.md)

## Build (Optional)
```
#For help:
./build-run.sh -h

./build-run.sh -u Username -p *** -n freeradius -v x.y.z -r https://your-container-repository.domain
```
## freeradius documentations
- [wiki.ubuntuusers.de/FreeRADIUS](https://wiki.ubuntuusers.de/FreeRADIUS/)
- [freeradius-server 3.2.7](https://www.freeradius.org/documentation/freeradius-server/3.2.7/)
