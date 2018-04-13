DOCTYPE = LDM
DOCNUMBER = NNN
DOCNAME = $(DOCTYPE)-$(DOCNUMBER)

GITVERSION := $(shell git log -1 --date=short --pretty=%h)
GITDATE := $(shell git log -1 --date=short --pretty=%ad)
GITSTATUS := $(shell git status --porcelain)
ifneq "$(GITSTATUS)" ""
	GITDIRTY = -dirty
endif

export TEXMFHOME = lsst-texmf/texmf

$(DOCNAME).pdf: doc.tex meta.tex
	xelatex -jobname=$(DOCNAME) doc.tex
	bibtex $(DOCNAME)
	xelatex -jobname=$(DOCNAME) doc.tex
	xelatex -jobname=$(DOCNAME) doc.tex

.FORCE:

meta.tex: Makefile .FORCE
	rm -f $@
	touch $@
	echo '% GENERATED FILE -- edit this in the Makefile' >>$@
	/bin/echo '\newcommand{\lsstDocType}{$(DOCTYPE)}' >>$@
	/bin/echo '\newcommand{\lsstDocNum}{$(DOCNUMBER)}' >>$@
	/bin/echo '\newcommand{\vcsRevision}{$(GITVERSION)$(GITDIRTY)}' >>$@
	/bin/echo '\newcommand{\vcsDate}{$(GITDATE)}' >>$@
