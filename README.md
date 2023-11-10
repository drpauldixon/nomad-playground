# nomad 3 client cluster

- 1x server
- 3x clients

```
vagrant up
vagrant ssh server-1
nomad job run traefik.nomad
nomad job run bob.nomad
nomad job run jane.nomad
```

Open the nomad dashboard:

- http://192.168.56.11:4646/ui/jobs

Access some services:

- http://192.168.56.21:8080/capi/bob/v1/get_status
- http://192.168.56.21:8080/capi/jane/v1/get_status

Repeat and you will see responses from each node the above services are running on.

## Ingress

Traefik acts as the ingress router. Sending an http request to any client node on port 8080 results in traefik routing the request to the relevant service.

The Traefik dashboard can be accessed on port 8081 on any client node. e.g. http://192.168.56.21:8081/dashboard/#/

## Try scaling a service

**Scale the jane-service from 2 to 3 running instances:**

```
nomad job scale jane-service 3
```

**Scale the bob-service from 2 to 5 running instances:**

```
nomad job scale bob-service 5
