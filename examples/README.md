# CGI and FastCGI examples

## CGI

Run `python -m http.server --cgi 8000` in this directory. Then in another terminal:

    curl 'localhost:8000/cgi-bin/say_hello.py' -X POST -d yourname

Take a look at the `say_hello.py` script - it's only 3 lines of code.

## FastCGI

