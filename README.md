# docker-poweradmin-exporter

Docker Image with Prometheus exporter for Power Admin

## Usage
### TL;DR
```
docker run \
  -p 9575:9575 \
  -v <PATH_TO_CONFD_BACKEND_FILE>:/data/configuration.yaml \
  -e PA_EXPORTER_SERVER=<PA_EXPORTER_SERVER> \
  -e PA_EXPORTER_API_KEY=<PA_EXPORTER_API_KEY>
  fxinnovation/poweradmin-exporter:<TAG>
```

Where CONFD_BACKEND_FILE **must** follow this structure:
```
configuration: |-
  <configuration as yaml>
status_mapping: |-
  <status_mapping as yaml>
```

*NOTE: This is ugly, but it's currently the way it works, we will look into this in the future.*
