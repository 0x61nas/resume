#!/usr/bin/env just --justfile

OUTDIR := "."
_main := "resume.tex"
_pdf_prog := "zathura"
_compiler := "pdflatex"
_cflags := "-halt-on-error -output-directory=" + OUTDIR

# alias w := whatch
alias c := compile
alias p := push

compile:
    #!/usr/bin/env bash
    set -euxo pipefail
    docker run -it --network=host -w '/work' -v "$(pwd):/work" latex-docker:latest bash -c "git config --global safe.directory '*' && ./build.sh"
    _OUTPUT_FILE=dist/$(cat build/output_path)
    _OUTPUT_FILE_NAME=${_OUTPUT_FILE##*/}
    doas chown anas:anas $_OUTPUT_FILE
    doas chmod 644 $_OUTPUT_FILE
    gpg --local-user EF4B4CB5DFB8822216A473B1597AB12E66262898 --detach-sign --armor $_OUTPUT_FILE
    cp $_OUTPUT_FILE ~/code/me/website/resume/archive/
    cp $_OUTPUT_FILE.asc ~/code/me/website/resume/archive/
    ln -srfv ~/code/me/website/resume/archive/$_OUTPUT_FILE_NAME ~/code/me/website/static/docs/anas-resume.pdf
    ln -srfv ~/code/me/website/resume/archive/$_OUTPUT_FILE_NAME.asc ~/code/me/website/static/docs/anas-resume.pdf.asc
    ln -srfv ~/code/me/website/resume/archive/$_OUTPUT_FILE_NAME ~/code/me/website/resume/anas-resume.pdf
    ln -srfv ~/code/me/website/resume/archive/$_OUTPUT_FILE_NAME.asc ~/code/me/website/resume/anas-resume.pdf.asc

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

push FLAGS="-u" BRANSH="aurora":
    git push {{FLAGS}} origin {{BRANSH}} 
    git push {{FLAGS}} gitlab {{BRANSH}} 
    git push {{FLAGS}} gitea {{BRANSH}} 
    git push {{FLAGS}} codeberg {{BRANSH}} 
    git push {{FLAGS}} disroot {{BRANSH}} 
    git push {{FLAGS}} tangled {{BRANSH}} 
    git push {{FLAGS}} codefloe {{BRANSH}} 
