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
pandoc -f markdown -t beamer -s -S -V theme:Amsterdam --slide-level 2 ${_src} -o ${_base}-beamer.pdf
