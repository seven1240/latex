PANDOC := pandoc

all: mobile book print

VER=7

SRC = meta.md \
	README.md \
	chapter-2.md \
	chapter-3.md \
	postface.md

preface.tex: preface.md
	$(PANDOC) -s --variable documentclass=report \
	--template template-dummy.tex \
	-o preface.tex preface.md

out:
	mkdir out

book: out preface.tex $(SRC)
	$(PANDOC) -s --toc \
	--template template.tex \
	--number-sections \
	--pdf-engine=xelatex \
	--include-in-header=cover-std.tex \
	--include-before=header.tex \
	--include-before-body=preface.tex \
	-o out/技术图书排版-标准版-$(VER).pdf \
	$(SRC)

mobile: out preface.tex $(SRC)
	$(PANDOC) -s --toc \
	--template template.tex \
	--number-sections \
	--pdf-engine=xelatex \
	--variable mobile=true \
	--include-in-header=cover.tex \
	--include-before=header.tex \
	--include-before-body=preface.tex \
	-o out/技术图书排版-移动版-$(VER).pdf \
	$(SRC)

print: out preface.tex $(SRC)
	$(PANDOC) -s --toc \
	--variable print=true \
	--variable fontsize=11pt \
	--template template.tex \
	--number-sections \
	--pdf-engine=xelatex \
	--include-in-header=cover-dummy.tex \
	--include-before=header.tex \
	-o out/技术图书排版-印刷版-$(VER).pdf \
	$(SRC)

docker:
	docker run -it -v `pwd`:/team dujinfang/texlive_pandoc:latest bash
