#!/usr/bin/env python

# -*- coding: utf-8 -*-

# check-code.py

import os

file_lst = []
for root, subFolders, files in os.walk('/home/vint21h/dev/board/'):
    for file in files:
	file_lst.append(os.path.join(root,file))
	
for file in file_lst:
    # processing only python sources
    if os.path.splitext(file)[1] == '.py':
	print file
