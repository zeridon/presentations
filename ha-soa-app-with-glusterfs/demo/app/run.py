#!/usr/bin/env python

# Import Flask ande define app
from flask import Flask, redirect
app = Flask(__name__)

# pull necessities so le can create some payload
import sys
from os import listdir
from os.path import isfile, join
target = sys.argv[1]

# Simulate app data by listing dir content
files = [ f for f in listdir(target) if isfile(join(target,f)) ]

# reload config (e.g. list dir again)
@app.route('/update')
def populate():
    global files, target
    files = [ f for f in listdir(target) if isfile(join(target,f)) ]
    return 'ok\n'

# serve some data
@app.route('/')
def respond():
    global files
    return '\n'.join(files) + '\n'

# Add data (we redirect to update as we are lasy to patch the list)
@app.route('/add/<name>')
def create_file(name):
    file = open(join(target,name), 'w')
    file.close()
    return redirect('/update')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
