#!/usr/bin/env python
from fastcgi import *
from pathlib import Path
from socketserver import UnixStreamServer,TCPServer
from warnings import warn

class TestHandler(FcgiHandler):
    def handle(self):
        self.print(f'Content-type: text/html\n\nHello {self.content()}')

p = Path('fcgi.sock')
if p.exists(): p.unlink()
with UnixStreamServer(str(p), TestHandler) as srv: srv.serve_forever()

