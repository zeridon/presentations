#!/usr/bin/python
"""Copyright 2008 Orbitz WorldWide

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License."""

import sys
import time
import os
import platform 
import subprocess
from socket import socket
from random import randint

CARBON_SERVER = '172.20.20.10'
CARBON_PORT = 10001

delay = 20
if len(sys.argv) > 3:
  delay = int( sys.argv[1] )
  CARBON_SERVER = sys.argv[2]
  CARBON_PORT = int( sys.argv[3] )

sock = socket()
try:
  sock.connect( (CARBON_SERVER,CARBON_PORT) )
except:
  print "Couldn't connect to %(server)s on port %(port)d, is carbon-agent.py running?" % { 'server':CARBON_SERVER, 'port':CARBON_PORT }
  sys.exit(1)

while True:
  now = int( time.time() )
  lines = []
  #We're gonna report all three loadavg values
  customers = [ 'boeing', 'airbus', 'northrop', 'bae' ]
  services = [ 'turbo', 'propeler', 'experimental' ]
  instances = [ 'eu', 'us', 'ap' ]
  for cust in customers:
      for srv in services:
          for sinst in instances:
              for inst in xrange(1,6):
                  # prod.i-123.junk_junk-bae:turbo:us.counter-queries
                  lines.append("prod.i-%s%s%s%s.junk1_junk2-%s:%s:%s.counter-queries %s %d" % (cust,srv,sinst,inst,cust,srv,sinst,randint(0,20),now))
                  lines.append("stg0.i-%s%s%s%s.junk1_junk2-%s:%s:%s.counter-queries %s %d" % (cust,srv,sinst,inst,cust,srv,sinst,randint(0,20),now))
                  lines.append("qa01.i-%s%s%s%s.junk1_junk2-%s:%s:%s.counter-queries %s %d" % (cust,srv,sinst,inst,cust,srv,sinst,randint(0,20),now))

  message = '\n'.join(lines) + '\n' #all lines must end in a newline
  print "sending %s ..." % (len(lines))
  #print message
  sock.sendall(message)
  time.sleep(delay)
