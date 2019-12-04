#!/usr/bin/env python
# -*- coding: utf-8 -*-
# 0.5

import SocketServer
import SimpleHTTPServer
import os
from timeit import default_timer as timer

PORT = 9113
dn = os.environ['USERTOSEARCH']
comando = 'bash /usr/local/bin/ldap_exporter-query.sh ' + dn

class CustomHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/metrics":
            #This URL will trigger our sample function and send what it returns back to the browser
            self.send_response(200)
            self.send_header('Content-type','text/html')
            self.end_headers()

            # leemos el resultado y creamos una lista de lineas
            start = timer()
            queryResult = os.popen(comando).read().splitlines()
            end = timer()
            queryTime = end - start
            # queryResult[0] debe tener 'dn: uid=ISORO2G,ou=personales,ou=usuarios,dc=mutua,dc=es'
            if (queryResult[0]).split(' ')[1].split(',')[0].split('=')[1] == dn:
                self.wfile.write('ldap_query_time ' + str(queryTime) +'\n')

            return
SocketServer.ThreadingTCPServer.allow_reuse_address = True
httpd = SocketServer.ThreadingTCPServer(('', PORT),CustomHandler)
#httpd.allow_reuse_address = True # Prevent 'cannot bind to address' errors on restart
#httpd.server_bind()     # Manually bind, to support allow_reuse_address
#httpd.server_activate() # (see above comment)

print "serving at port", PORT
httpd.serve_forever()