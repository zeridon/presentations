#!/usr/bin/env bash
#
# Generate presenter artifacts
#
# $Id$

# Source is markdown passed on command line

_src=$1
_base=${_src%%.*}

# Gen html
pandoc -f markdown -t s5 -s -S -V s5-url:../assets/s5/amsterdam ${_src} -o ${_base}-s5.html

# Now the pdf
pandoc \
	--from markdown \
	--to beamer \
	--standalone \
	--smart \
	--variable theme:Amsterdam \
	--variable fonttheme:structurebold \
	--slide-level 2 \
	--template ../assets/beamer/beamer-custom.template \
	${_src} -o ${_base}-beamer.pdf
