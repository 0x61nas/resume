#!/usr/bin/env just --justfile

OUTDIR := "."
_main := "resume.tex"
_pdf_prog := "zathura"
_compiler := "pdflatex"
_cflags := "-halt-on-error -output-directory=" + OUTDIR

# alias w := whatch
alias c := compile
# alias p := preview

compile:
	#!/usr/bin/env bash
	set -euxo pipefail
	docker run -it --network=host -w '/work' -v "$(pwd):/work" latex-docker:latest bash -c "git config --global safe.directory '*' && ./build.sh"
	_OUTPUT_FILE=dist/$(cat build/output_path)
	doas chown anas:anas $_OUTPUT_FILE
	doas chmod 644 $_OUTPUT_FILE
	gpg --detach-sign --armor $_OUTPUT_FILE
	cp $_OUTPUT_FILE /mnt/work/dev/me/website/static/docs/anas-resume.pdf
	cp $_OUTPUT_FILE.asc /mnt/work/dev/me/website/static/docs/anas-resume.pdf.asc

# compile compiler=_compiler cflags=_cflags main=_main:
# 	{{compiler}} {{cflags}} {{main}}
# 	# bibtex resume
# 	# {{compiler}} {{cflags}} {{main}}
# 	# {{compiler}} {{cflags}} {{main}}

# preview prog=_pdf_prog compiler=_compiler cflags=_cflags main=_main: (compile compiler cflags main)
# 	{{prog}} {{OUTDIR}}/resume.pdf
#
#
# whatch prog=_pdf_prog compiler=_compiler cflags=_cflags main=_main:
# 	just preview {{prog}} &
# 	echo "{{main}}" | entr just compile "{{compiler}}" "{{cflags}}" "{{main}}"

clean:
	rm -fr *.toc *.snm *.out *.nav *.blg *.log *.bbl *.aux resume.pdf build/
