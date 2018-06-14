#!/usr/bin/env python3

import socket
import time
from http.server import HTTPServer, BaseHTTPRequestHandler
from io import BytesIO

# Socket with Telegraf
TCP_IP = '127.0.0.1'
TCP_PORT = 8080
socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)



class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        self.send_response(200)
        self.end_headers()
        send_to_telegraf(body)


def send_to_telegraf(content):
	try:
		socket.send(content)
	except socket.timeout:
		connect_socket()

#Setup TCP-Socket
def connect_socket():
	connected = False
	while not connected:
		try:	
			socket.connect((TCP_IP, TCP_PORT))
			connected = True
		except:
			print("Failed to connect to Telegraf")
			time.sleep(1)


connect_socket()

# HTTP listener for JSON data from Dashboard
httpd = HTTPServer(('localhost', 8888), SimpleHTTPRequestHandler)
httpd.serve_forever()

