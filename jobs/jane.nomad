job "jane-service" {
  datacenters = ["dc1"]
  group "jane-service" {

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

    task "jane-service" {
      driver = "raw_exec"
 
      config {
        command = "local/janeApp.py"
      }
      
      artifact {
        source = "http://192.168.56.11/janeApp.py"
      }

      resources {
        cpu = 200
        memory = 400
      }

      service {
        name = "jane-service"
        provider = "nomad"
        port = "http"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.jane-service.rule=PathPrefix(`/capi/jane/v1`)",
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
