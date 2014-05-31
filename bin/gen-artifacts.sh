#!/usr/bin/env bash
#
# Generate presenter artifacts
#
# $Id$

# Source is markdown passed on command line

_src=$1
_base=${_src%%.*}
_t=$( readlink -f ${_src} )
_dir=$(cd ${_t%/*} && pwd -P )
_scriptdir=$(cd ${0%/*} && pwd -P )


# Gen html
pandoc \
	--from markdown \
	--to s5 \
	--standalone \
	--smart \
	--variable s5-url:${_scriptdir}/../assets/s5/amsterdam \
	${_src} -o ${_dir}/${_base}-s5.html

# Now the pdf
pandoc \
	--from markdown \
	--to beamer \
	--standalone \
	--smart \
	--template ${_scriptdir}/../assets/beamer/beamer-custom.template \
	--variable theme:Amsterdam \
	--variable fonttheme:professionalfonts \
	--variable lang:bulgarian \
	--slide-level 2 \
	--latex-engine=pdflatex \
	${_src} -o ${_dir}/${_base}-beamer.pdf
