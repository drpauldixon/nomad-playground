# nomad job plan traefik.nomad
# nomad job run traefik.nomad
# nomad job stop traefik
job "traefik" {
  datacenters = ["dc1"]
  type = "system"
  group "traefik" {

    network {
      port "http" {
        static = 8080
      }

      port "api" {
        static = 8081
      }
    }

    service {
      name = "traefik"
      provider = "nomad"
      port = "http"

      check {
        name     = "alive"
        type     = "tcp"
        port     = "http"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "traefik" {
      driver = "raw_exec"

      config {
        command = "traefik"
        args = [  "--configfile",
                  "local/traefik.toml"
               ]
      }

    template {
      data = <<EOF
[accessLog]
format = "json"

[entryPoints]
    [entryPoints.http]
    address = ":8080"
    [entryPoints.traefik]
    address = ":8081"

[api]
    dashboard = true
    insecure  = true

# Enable Consul Catalog configuration backend.
[providers.nomad]
    prefix           = "traefik"
    exposedByDefault = false
EOF

      destination = "local/traefik.toml"
    }

      artifact {
        source      = "http://192.168.56.11/traefik"
      }
    }
  }
}
