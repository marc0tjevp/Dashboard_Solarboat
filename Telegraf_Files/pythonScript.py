#!/usr/bin/env python

import socket
from http.server import HTTPServer, BaseHTTPRequestHandler

from io import BytesIO
import socket

TCP_IP = '127.0.0.1'
TCP_PORT = 8080
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((TCP_IP, TCP_PORT))

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Hello, world!')

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        self.send_response(200)
        self.end_headers()
        #response = BytesIO()
        #response.write(b'This is POST request. ')
        #response.write(b'Received: ')
        #response.write(body)
        #self.wfile.write(response.getvalue())
        s.send(body)


httpd = HTTPServer(('localhost', 8888), SimpleHTTPRequestHandler)
httpd.serve_forever()

