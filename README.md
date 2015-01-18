Presentations
=============

Presentations given on different places, conferences or just random ones

All work here is licensed under CC-BY-SA 4.0 or any later.

Feel free to use/Reuse/Remix but do not forget to atribute and share

Full text of license available in `LICENSE` or at http://creativecommons.org/licenses/by-sa/4.0/


How to use this
===============
The easiest way is to just copy `00-template` directory and start from there.

Notes can be added to slides with the construct
```
\note{
some notes
}
```
Take care not to use underscores (or escape them) in the notes as they have special meaning for latex math mode.

When finished with editing run:
```
../bin/gen-artifacts.sh file-name.pandoc
```

It will produce an html presentation based on [S5](http://meyerweb.com/eric/tools/s5/), pdf based on [LaTeX Beamer](https://bitbucket.org/rivanvx/beamer/wiki/Home) and handouts derived from the beamer slides.

Requirements
============
In order for all this to work you will need the following tools:

* Pandoc
* latex-beamer
* pdfjam

Either compile or install from packages

If you want to use the theme i am using (and not something else) you will need to install ``assets/beamer/beamer/themes/theme/beamerthemeAmsterdam.sty`` into the proper place and rehash the config for texmf.

HINTS:
=====
On Linux try ``kpsewhich --var-value=TEXMF``. This will give you a list of directories that LaTeX will look for styles and other stuff. Make the following directory structure beneath a directory you control (``~/.texmf-config`` maybe) ``tex/latex/beamer/themes/theme`` and copy your theme there.
