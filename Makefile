PANDOC := pandoc

all: mobile book print docx

VER=10

SRC = meta.md \
	chapter-1.md \
	chapter-2.md \
	chapter-3.md \
	chapter-4.md \
	chapter-5.md \
	chapter-6.md \
	postface.md

preface.tex: README.md
	$(PANDOC) -s --variable documentclass=report \
	--template template-dummy.tex \
	--lua-filter=color-box.lua \
	-o preface.tex README.md

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
	--lua-filter=diagram-generator.lua \
	--lua-filter=webp.lua \
	--lua-filter=color-box.lua \
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
	--lua-filter=diagram-generator.lua \
	--lua-filter=webp.lua \
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
	--include-before-body=preface.tex \
	--lua-filter=diagram-generator.lua \
	--lua-filter=webp.lua \
	-o out/技术图书排版-印刷版-$(VER).pdf \
	$(SRC)

docx: out preface.tex $(SRC)
	$(PANDOC) -s --toc \
	--number-sections \
	--lua-filter=diagram-generator.lua \
	--lua-filter=docx-figure-number.lua \
	--lua-filter=color-box.lua \
	-o out/技术图书排版-$(VER).docx \
	README.md $(SRC)

.PHONY: html
html: $(SRC)
	rm -rf html
	$(PANDOC) -s --toc \
	-t chunkedhtml \
	--split-level 1 \
	--number-sections \
	-o html \
	--mathml \
	--highlight-style tango \
	--template chunked.html \
	--variable title="技术图书排版" \
	--variable description-meta="《技术图书排版》，开源免费电子书。" \
	--lua-filter diagram-generator.lua \
	--lua-filter=docx-figure-number.lua \
	--include-before ad.html \
	--include-after after.html \
	README.md $(SRC)
	cp img/circle.webm html/img/
	cp img/typesetting*.png html/img/
	cp img/xyt1.jpg html/img/
	cp img/qr-wechat.png html/img/

cover:
	$(PANDOC) -s --variable documentclass="report" \
	--template template.tex \
	--pdf-engine=xelatex \
	--variable mobile=true \
	-o out/cover.pdf \
	--include-in-header=cover.tex \
	meta.md

	$(PANDOC) -s --variable documentclass="report" \
	--template template.tex \
	--pdf-engine=xelatex \
	-o out/cover2.pdf \
	--include-in-header=cover-std.tex \
	meta.md

docker:
	docker run --rm -it -v `PWD`:/team ccr.ccs.tencentyun.com/free/pandoc:tiny-3.0.1 bash

install:
	@echo upload to freeswitch.org.cn
	rsync --exclude=.DS_Store -rvz html/* root@www.freeswitch.org.cn:/var/www/freeswitch.org.cn/_site/books/typesetting/
