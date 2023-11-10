# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Full configuration options can be found at https://www.nomadproject.io/docs/configuration

data_dir  = "/opt/nomad/data"
bind_addr = "0.0.0.0"

client {
  enabled = true
  servers = ["192.168.56.11"]
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

