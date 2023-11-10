#!/usr/bin/env python3
# A web server to echo back a request's headers and data.
#
# Usage: ./webserver
#        ./webserver 0.0.0.0:5000

# From: https://github.com/nickjj/webserver

import os,sys
from http.server import HTTPServer, BaseHTTPRequestHandler
from sys import argv

BIND_HOST = '0.0.0.0'
PORT = int(os.getenv('NOMAD_HOST_PORT_http', '0'))
if PORT == 0:
    print("Aborting: NOMAD_HOST_PORT_http is not set", file=sys.stderr)
    exit(1)

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        print(self.path)
        self.write_response(b'BOB SERVICE:'+str.encode(self.path))

    def do_POST(self):
        content_length = int(self.headers.get('content-length', 0))
        body = self.rfile.read(content_length)
        self.write_response(body)

    def write_response(self, content):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(content)

        print(self.headers)
        print(content.decode('utf-8'))

if len(argv) > 1:
    arg = argv[1].split(':')
    BIND_HOST = arg[0]
    PORT = int(arg[1])

print(f'Listening on http://{BIND_HOST}:{PORT}\n')

httpd = HTTPServer((BIND_HOST, PORT), SimpleHTTPRequestHandler)
httpd.serve_forever()

