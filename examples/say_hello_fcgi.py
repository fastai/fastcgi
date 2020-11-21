#!/usr/bin/env python
from fastcgi import *
from time import sleep

@fastcgi
def hello():
    name = sys.stdin.read()
    sys.stdout.write(f'Content-type: text/html\n\nHello {name}\n')
    sys.stdout.write(f'{os.environ}\n')

