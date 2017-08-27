#!/usr/bin/python 

import socket

s = socket.socket()
host = socket.gethostname()
port = 45678
s.bind((host,port))
print('Hello')

s.listen(5)
c=s.accept()