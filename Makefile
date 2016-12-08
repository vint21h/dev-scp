# dev-scp
# Makefile

docs:
	rst2html README.rst > index.html && zip docs.zip index.html

clear:
	rm -rf index.html docs.zip build dist
