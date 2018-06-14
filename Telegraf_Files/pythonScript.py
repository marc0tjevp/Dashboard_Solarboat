#!/usr/bin/env python
# /etc/init.d/pythonScript.py
### BEGIN INIT INFO
# Provides:          pythonScript.py
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time
# Description:       Enable service provided by daemon.
### END INIT INFO

import socket
import time
from http.server import HTTPServer, BaseHTTPRequestHandler
from io import BytesIO


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

    def do_POST(self):
        content_length = int(self.headers['Content-Length'])
        body = self.rfile.read(content_length)
        self.send_response(200)
        self.end_headers()
        socket.send(body)


TCP_IP = '127.0.0.1'
TCP_PORT = 8080

#Setup TCP-Socket
socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
socketConnected = False
while not socketConnected:
	try:	
		socket.connect((TCP_IP, TCP_PORT))
		socketConnected = True
	except:
		print("Failed to connect to Telegraf")
		time.sleep(1)


httpd = HTTPServer(('localhost', 8888), SimpleHTTPRequestHandler)
httpd.serve_forever()
