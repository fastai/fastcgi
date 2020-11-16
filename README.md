# fastcgi
> A fastcgi handler for Python's `socketserver` classes


[FastCGI](http://www.mit.edu/~yandros/doc/specs/fcgi-spec.html) is a way for front-end servers to talk to back-end workers in a (somewhat) efficient and (somewhat) simple way. Although it's been around since 1996, it is not very widely appreciated, except in the PHP community, where it is very commonly used.

It can be a great approach for hosting Python scripts, avoiding the overhead of creating a new Python process for every request (as standard CGI would otherwise require) and without requiring large dependencies, complex C projects, or fiddly deployments. `fastcgi` has no dependencies other than [fastcore](https://fastcore.fast.ai/).

There's no new frameworks or concepts to learn. Just call `send` to send anything you like back to the client, read the parameters from `params`, and the input from the client from `stdin`.

`fastcgi` requires a front-end web server. If you don't already have one set up, we recommend [Caddy](https://caddyserver.com/). To forward all requests to `example.com` to a `fastcgi` server listening on port 1234 create a file called `Caddyfile` with the following contents, and then `caddy run`:

    example.com
    reverse_proxy localhost:1234 { transport fastcgi }

## Install

`pip install fastcgi` or `conda install -c fastai fastcgi`

## How to use

Probably the only thing you need to use is `FcgiHandler`, which is used in much the same way as Python's [BaseRequestHandler](https://docs.python.org/3/library/socketserver.html#request-handler-objects). Here's an example:

```python
class TestHandler(FcgiHandler):
    def handle(self):
        print('query:', self.params['QUERY_STRING'])
        print('content type:', self.params['HTTP_CONTENT_TYPE'])
        print('stdin:', self.stdin)
        self.send("Content-type: text/html\r\n\r\n<html>foobar</html>\n")
```

You can run this using any of Python's `socketserver` classes, e.g to listen on localhost port 1234:

```python
with TCPServer(('localhost',1234), TestHandler) as srv:
    srv.handle_request()
```

See the API docs for `FcgiHandler` for an end-to-end example.

You can also create a forking or threading server by using Python's [mixins or predefined classes](https://docs.python.org/3/library/socketserver.html#socketserver.ThreadingMixIn).
