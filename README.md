# fastcgi
> FastCGI and HTTP handlers for Python's `socketserver` classes


[FastCGI](http://www.mit.edu/~yandros/doc/specs/fcgi-spec.html) is a way for front-end servers to talk to back-end workers in a (somewhat) efficient and (somewhat) simple way. Although it's been around since 1996, it is not very widely appreciated, except in the PHP community, where it is very commonly used.

It can be a great approach for hosting Python scripts, avoiding the overhead of creating a new Python process for every request (as standard CGI would otherwise require) and without requiring large dependencies, complex C projects, or fiddly deployments. `fastcgi` has no dependencies other than [fastcore](https://fastcore.fast.ai/).

There's no new frameworks or concepts to learn. Just call `send` to send anything you like back to the client, read the parameters from `params`, and the input from the client from `stdin`.

`fastcgi` requires a front-end web server. If you don't already have one set up, we recommend [Caddy](https://caddyserver.com/). To forward all requests to `example.com` to a `fastcgi` server listening on port 1234 create a file called `Caddyfile` with the following contents, and then `caddy run`:

    example.com
    reverse_proxy localhost:1234 { transport fastcgi }

This library also provides an HTTP handler that can be used in an identical way, except remove `{ transport fastcgi }` from the above `Caddyfile` example. Python's standard library already includes an HTTP handler (in `http.server`), however the documentation warns that that module should not be used in production code. The HTTP handler provided here is trimmed down to a minimal implementation (just 40 lines of code) so that it can easily be studied and extended. It uses the same basic API as Python's other `socketserver` classes (and the same as `FcgiHandler` here) so there's fewer new concepts to understand.

## Install

`pip install fastcgi` or `conda install -c fastai fastcgi`

## How to use

See the full docs pages for each class for details. Quick overviews of each approach are shown below.

### fastcgi decorator

Using the `fastcgi` decorator you can use CGI scripts with minimal changes. Just add the decorator above a function used for CGI, and it converts that script automatically into a FastCGI server, e.g if you save this as `server.py`:

```python
@fastcgi()
def hello():
    query = os.environ["QUERY_STRING"]
    content = sys.stdin.read()
    sys.stdout.write(f"Content-type: text/html\r\n\r\n<html>{content} ; ")
    sys.stdout.write(f"{query}</html>\r\n")
```

...then if you run `python server.py` it will make a unix socket available as `fcgi.sock` in the current directory.

### FcgiHandler

`FcgiHandler` is used in much the same way as Python's [BaseRequestHandler](https://docs.python.org/3/library/socketserver.html#request-handler-objects). Here's an example:

```python
class TestHandler(FcgiHandler):
    def handle(self):
        print('query:', self.environ['QUERY_STRING'])
        print('content type:', self.environ['HTTP_CONTENT_TYPE'])
        print('stdin:', self['stdin'].read())
        self['stdout'].write(b"Content-type: text/html\r\n\r\n<html>foobar</html>\r\n")
```

You can run this using any of Python's `socketserver` classes, e.g to listen on localhost port 1234:

```python
with TCPServer(('localhost',1234), TestHandler) as srv:
    srv.handle_request()
```

See the API docs for `FcgiHandler` for an end-to-end example.

You can also create a forking or threading server by using Python's [mixins or predefined classes](https://docs.python.org/3/library/socketserver.html#socketserver.ThreadingMixIn).

In your `handle` method, you can use the `stdin`, `stdout`, and `stderr` attributes, which each contain a `BytesIO` stream.

### MinimalHTTPHandler

`fastcgi` also comes with the `MinimalHTTPHandler` class, which provides very similar functionality to `FcgiHandler`, but using the `HTTP` protocol instead of the `FastCGI` protocol. Here's an example:

```python
class _TestHandler(MinimalHTTPHandler):
    def handle(self):
        print(f'Command/path/version: {self.command} {self.path} {self.request_version}')
        print(self.headers)
        self.send_response(200)
        self.send_header("Content-Type", "text/plain")
        self.send_header('Content-Length', '2')
        self.end_headers()
        self.wfile.write(b'ok')
```

You can run it with a `socketserver` server in the same way shown above for `FcgiHandler`.
