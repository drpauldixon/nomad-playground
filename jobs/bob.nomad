job "bob-service" {
  datacenters = ["dc1"]
  group "bob-service" {

    # use scaling instead of count, to enable scaling in the UI
    # count = 1
    scaling {
      enabled = true
      min = 2
      max = 10
      policy {
      }
    }

    #constraint {
    #  distinct_hosts = true
    #}

    network {
      port "http" {}
    }

    task "bob-service" {
      driver = "raw_exec"
 
      config {
        command = "local/bobApp.py"
      }
      
      artifact {
        source = "http://192.168.56.11/bobApp.py"
      }

      resources {
        cpu = 200
        memory = 400
      }

      service {
        name = "bob-service"
        provider = "nomad"
        port = "http"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.bob-service.rule=PathPrefix(`/capi/bob/v1`)",
        ]
        check {
          type     = "tcp"
          port     = "http"
          interval = "10s"
          timeout  = "2s"
        }
      }

    }
  }
}
