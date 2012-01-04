#!/usr/bin/env python

# -*- coding: utf-8 -*-

# check-code.py

try:
    import sys
    import os
    from subprocess import call
except ImportError, err:
    print "ERROR: Couldn't load module. %s" % (err)
    sys.exit(0)


PROJECT_NAME = sys.argv[1]
PROJECT_PATH = os.path.abspath('../' + PROJECT_NAME)
FLST = []
INDEX_TEMPLATE = u"""
    <html>
    <body>
    %s
    <body>
    </html>
"""
LINK_TEMPLATE = u"""<a href=file://%s>%s</a><br/>"""
INDEX_BODY = u""""""

if not os.path.exists(PROJECT_PATH):
    print 'Project directory does not exist.'
    sys.exit(0)


for root, subFolders, files in os.walk(PROJECT_PATH):
    for file in files:
        FLST.append(os.path.join(root, file))

for f in FLST:
    # processing only python sources
    if os.path.splitext(f)[1] == '.py' and PROJECT_NAME + '-venv' not in f and 'migrations' not in f:
	call('mkdir -p %s' % os.path.join(PROJECT_PATH, 'tmp/reports' ,os.path.dirname(f[f.find(PROJECT_NAME) + len(PROJECT_NAME) + 1:len(f)])), shell=True)  # create directory contains file
	target_file = f[f.find(PROJECT_NAME):len(f)]
	print target_file
	INDEX_BODY += LINK_TEMPLATE % (os.path.splitext(os.path.join(PROJECT_PATH, 'tmp/reports' , target_file[len(PROJECT_NAME) + 1:len(target_file)]))[0] + '.html', target_file)
	call('pylint -f html %s > %s' % (os.path.join('../', target_file), os.path.splitext(os.path.join(PROJECT_PATH, 'tmp/reports' , target_file[len(PROJECT_NAME) + 1:len(target_file)]))[0] + '.html'), shell=True)

# saving index page
INDEX_HTML = open(os.path.join(PROJECT_PATH, 'tmp/reports/index.html'), 'wb')
INDEX_HTML.write(INDEX_TEMPLATE % INDEX_BODY)
