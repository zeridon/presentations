from flask import Flask, redirect
app = Flask(__name__)

import sys
from os import listdir
from os.path import isfile, join
target = sys.argv[1]
files = [ f for f in listdir(target) if isfile(join(target,f)) ]

@app.route('/update')
def populate():
    global files, target
    files = [ f for f in listdir(target) if isfile(join(target,f)) ]
    return 'ok'

@app.route('/')
def respond():
    global files
    return '\n'.join(files)

@app.route('/add/<name>', methods=['POST'])
def create_file(name):
    file = open(join(target,name), 'w')
    file.close()
    return redirect('/update')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
