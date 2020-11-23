#!/usr/bin/env python
from fastcore.script import *
import sys,os

@call_parse
def hello():
    length = int(os.environ.get('CONTENT_LENGTH', 0))
    name = sys.stdin.read(length)
    sys.stdout.write(f'Content-type: text/html\r\n\r\nHello {name}\r\n')

