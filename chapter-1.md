# 技术图书排版 {#typesetting}

欢迎来到排版世界。我们用 Markdown[^markdown-1]格式写作，用 LaTex 模板排版，用 Pandoc 做格式转换。

[^markdown-1]: <https://docs.xswitch.cn/xpedia/markdown/> 。

Markdown 是一个文档格式，它是基于纯文本的，通过简单的格式约定，既做到源文件易读，又做到可以支持一些基本的格式。本文就是用 Markdown 写成的。

Pandoc[^pandoc]是一个文档转换工具，是一个瑞士军刀。它可以在各种文档格式间转换，在此我们会将我们的 Markdown 文件转换成 PDF。

[^pandoc]: <https://pandoc.org/>

LaTex[^latex]是世界上最先进的排版系统，在文档转换过程中，我们会用到 LaTex。推荐安装 TexLive[^texlive]，但完整版安装包有 4 个多 G，太大了，所以一般安装 BasicTex 就够了，这个版本比较小，但宏包不全，遇到有缺少的宏包可以后续用`tlmgr install 包名`命令安装。

[^latex]: <https://www.latex-project.org/>
[^texlive]: <http://www.tug.org/mactex/morepackages.html>

本书是在 Mac 上编译的，笔者也制作了个 Docker 镜象方便大家使用，参见下一节。

这是本书的第一章。到此，章节、段落、脚注、链接等写法你都已经看到了（当然，如果你阅读的是 PDF 的话，你需要看一下源文件）。下面，我们看下本书中用到的一些文件。

## Makefile

关于 Pandoc 的用法我们不会详细解释，感兴趣的应该去看官方网站上的文档，我们只是解释一下我用到的一些命令。

先看 Makefile。好吧，我们需要先学习一下 Makefile。

Makefile 不是必需的，但作为一名程序员，它是一个很方便使用的工具。

首先定义了一个变量，`PANDOC`就指向`pandoc`可执行文件，如果在不同的系统上使用，可以更新路径。

`all`定义了一个目标（Target），如果在命令行上执行`make`命令，就默认使用这个目标。可以看到，它其实**依赖**于另外几个目标`mobile`、`book`和`print`，后面我们会讲到这些目标，在命令行上也可以单独`make`一个目标，如`make mobile`。

`VER`只是一个版本号。`SRC`为本书全部的源文件。

```makefile
PANDOC := pandoc

all: mobile book print docx

VER=7

SRC = meta.md \
	chapter-1.md \
	chapter-2.md \
	chapter-3.md \
	chapter-4.md \
	postface.md
```

先来个小目标;)，`preface.tex`是一个小目标，是『前言』部分。因为我们希望前言能在目录的前面，所以我们需要一个`tex`文件，但我们还是想用 Markdown 格式写，所以，我们会把`README.md`转换成`tex`并插入到文档相应的位置。

其中`-s`为 Smart 的意思（嗯，欲知详情看官方文档），`--variable`为变量，设置 LaTex 的文档格式，后面我们会有模板文件中看到。`--template`选择一个模板，在此，我们自创了一个空模板，它会生成不带模板的 LaTex 文件。好吧，如果听不明白也没关系，你可以看一下生成的这个文件的内容，初步了解一下 LaTex 的格式。

```makefile
preface.tex: README.md
	$(PANDOC) -s --variable documentclass=report \
	--template template-dummy.tex \
	--lua-filter=color-box.lua \
	-o preface.tex README.md
```

`out`是一个目标，这就是 Makefile 的魔术，如果没有这个目标文件夹，就执行下面的`mkdir`命令创建它。再次说明，Pandoc 并不依赖于 Makefile，你可以手工执行命令创建这个文件夹，但是我们使用 Makefile 只是为了方便。

```makefile
out:
	mkdir out
```

`book`是我们标准的目标，它会生成一个 PDF 文件（通过`-o`指定）。`--toc`是`Table of Content`，即自动生成图书目录。这里的`template.tex`是我们的模板文件，后面我们还会详细讲。`--number-sections`自动生成章节号。`pdf-engine`我们选`xelatex`，对中文比较友好，另一个选项是`pdflatex`，但对中文支持稍差点。`--include-xxx`表示将相关文件插入到模板文件相应的位置。

```makefile
book: out preface.tex $(SRC)
	$(PANDOC) -s --toc \
	--template template.tex \
	--number-sections \
	--pdf-engine=xelatex \
	--include-in-header=cover-std.tex \
	--include-before=header.tex \
	--include-before-body=preface.tex \
	--lua-filter=diagram-generator.lua \
	-o out/book-标准版-$(VER).pdf \
	$(SRC)
```

标准版是 A4 的纸张，在手机上显示不适合阅读，我们生成个移动版的，设置纸张大小为`9 x 16cm`，即对于`16:9`的手机屏幕，刚好显示一页。在此，我们传入了一个`mobile=true`参数。

```makefile
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
	-o out/book-移动版-$(VER).pdf \
	$(SRC)
```

图书是要出版的，一般出版的尺寸不会是 A4 的，所以要设置不同的尺寸，另外，出版图书跟电子阅读的版本还有一个重要的区别是奇偶页不同（页边距和页码位置等），我们加了个`print`变量控制打印的格式。看了这么多年书，你有没有注意到这个问题呢？

```makefile
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
	-o out/book-印刷版-$(VER).pdf \
	$(SRC)
```

为了照顾那些顽固地想看 Word 版的人，我们增加了一个`make docx`，就可以直接生成 Word 版了。

```makefile
docx: out preface.tex $(SRC)
	$(PANDOC) -s --toc \
	--number-sections \
	--lua-filter=color-box.lua \
	-o out/技术图书排版-$(VER).docx \
	README.md $(SRC)
```

如果你本地没有安装 Pandoc 以及 LaTex 环境，可以使用笔者制作的 Docker 镜象。在命令行上执行`make docker`会进入一个 Docker 容器中，并把当前目录映射到`/team`目录中，然后就可以继续`make`生成 PDF 了。

```makefile
docker:
	docker run --rm -it -v `PWD`:/team ccr.ccs.tencentyun.com/free/pandoc:multiarch bash
```

读到这里，如果你还是不理解 Makefile，可以参考笔者的另一篇文章《[Makefile 极速入门](https://docs.xswitch.cn/xpedia/makefile/)》。

## meta.md

`meta.md`里面定义了一些变量，YAML 格式。这些变量在主模板文件中会用到。

```yaml
---
documentclass: report
title: 技术图书排版
author: 杜金房
title-meta: 技术图书排版
author-meta: 杜金房
publisher: 版权所有\qquad 侵权必究
verbatim-in-note: true
---
```

## diagram-generator.lua

这是一个 Lua 脚本，用于将以`graphviz`和`mscgen`标记的代码块转换成图片。

## webp.lua

这也是一个 Lua 脚本，由于 Latex 不支持`webp`格式的图片，替换成一段说明。这主要是为了使用同一个 Markdown 源文件适配 PDF 和 HTML 的情况。

```lua
-- 实现一个函数判断字符串是否以某个字符串结尾
function string:endswith(ending)
    return ending == "" or self:sub(-#ending) == ending
end

-- 对每一个图片，将自动调用如下函数，该函数仅对latex格式生效
function Image(img)
    if FORMAT ~= "latex" then return end

    if img.src:endswith(".webp") then
        return pandoc.Str("!PDF版不支持该类型的图片[webp image]！")
    end
end
```

## docx-figure-number.lua

Lua 脚本，仅用于`docx`格式的文件，为图片添加编号。

Pandoc 虽然有 native-numbering 选项，但是对于图片编号不能区分章节。

## color-box.lua

Lua 脚本，用于添加带颜色的文本框。

```lua
local supported_boxes = { -- 支持以下三种类型
	redbox = 'redbox',
	greenbox = 'greenbox',
	bluebox = 'bluebox'
}

function CodeBlock(block)
	for class, env in pairs(supported_boxes) do
		if block.classes:includes(class) then      -- 将符合条件的代码块转换成文本框
			local parsed = pandoc.read(block.text, 'markdown')  -- 读取代码块中的 markdown 内容
			if FORMAT == "latex" then              -- LaTex 和 PDF
				local latex_content = pandoc.write(parsed, 'latex')
				local caption = '{}'
				if block.attributes.caption then
					caption = '{' .. block.attributes.caption .. '}'
				end
				local latex_start = '\\begin{' .. class .. '}' .. caption .. '\n'
				local latex_end = '\n\\end{' .. class .. '}'
				local content = latex_start .. latex_content .. latex_end
				return pandoc.RawBlock('latex', content)
			elseif FORMAT == "docx" then          -- docx，需要一个额外的样式参考文件
				if block.attributes.caption then
					local caption = pandoc.Strong(block.attributes.caption .. '：')
					table.insert(parsed.blocks[1].content, 1, caption)
				end
				local div = pandoc.Div(parsed.blocks)
				div.attr.attributes['custom-style'] = class
				return div
			elseif FORMAT == "html" or FORMAT == "chunkedhtml" then -- HTML
				if block.attributes.caption then
					local caption = pandoc.Strong(block.attributes.caption .. '：')
					table.insert(parsed.blocks[1].content, 1, caption)
				end
				local div = pandoc.Div(parsed.blocks)
				div.classes:insert(class) -- 需要对应的 CSS 样式
				return div
			end
		end
	end
	return nil
end
```

使用方法如下：

````markdown
```{.redbox, caption="标题"}
带标题的文本框
```

```greenbox
不带标题的文本框
```
````

效果如下：

```{.redbox caption="标题"}
带标题的文本框
```

```greenbox
不带标题的文本框
```

## cover.tex

我们先从这个文件熟悉一下 LaTex 的语法。你不需要精通 LaTex，但学一点总是有好处。

这是本书的封面，如果读到这里，你应该已经看到这个封面了。简单起见，我直接用了《FreeSWITCH 文集》的封面。虽然我们可以直接用个 PNG 或 JPEG 图片做封面，但是作为一名程序员，我还是喜欢用代码生成封面，尽量少地依赖 PhotoShop 之类的软件。

我们使用`tikz`宏包，嗯，它是在 LaTex 里画图用的。类似于程序语言中的模块，LaTex 使用宏包扩展本身的功能。其中`%`是注释。如果把`texcoord`那行注释去掉，可以看到一些参考线。

```tex
\usepackage{tikz}
\usepackage[absolute,overlay]{textpos}
% uncomment to see grid system
% \usepackage[texcoord,grid,gridcolor=red!10,subgridcolor=green!10,gridunit=cm]{eso-pic}
```

`shadowtext`给『技术图书排版』画上阴影。

```tex
\usepackage{shadowtext}
\shadowcolor{black}
\shadowoffset{1pt}
```

下面定义了一个新命令`\cover`，用于在正文中『画』封面。从`yellow`到`Orange`做个渐变的颜色背景。然后把颜色再切换成白色。

```tex
\newcommand{\cover}{
\begin{tikzpicture}[remember picture,overlay]
\path [top color = yellow, bottom color = Orange] (current page.south west) rectangle (current page.north east);
\end{tikzpicture}
\color{white}
```

设置这是一个『空』（`empty`）页面（告诉 LaTex 不需要自动生成页码之类的），居中，写上『FreeSWITCH』，加上`wenji.png`，这是一个图片，然后写上作者。

```tex
\thispagestyle{empty}
\pagenumbering{gobble}
% \chapter*{}
\bigskip
\begin{center}
  \textbf{\fontsize{36}{48}\selectfont\shadowtext{技术图书排版}}
  \\[2em]
  \Oldincludegraphics[width=0.5\paperwidth]{wenji.png}
  \\[2em]
  \textbf{\large \theauthors \quad 著\\[2em]}
\end{center}
```

找一个位置，放上『小樱桃出品』，使用绝对坐标。

```tex
\begin{textblock*}{4cm}[0.5,0.5](0.5\paperwidth, 13.8cm)
\small
\color{white}
\center
\textbf{小樱桃出品}
\color{black}
\end{textblock*}
```

`bigskip`会自动填充中间的空间，然后在下面画一个文本框放上一些装饰文本（笔者是做 SIP 通信的，因此放了一段 SIP 消息）。

```tex
\bigskip
\vfill
\begin{adjustwidth}{-2.3mm}{}
\mbox{\vbox{
\color{yellow}
\small
INVITE sip:you@xswitch.cn SIP/2.0\newline
Via: SIP/2.0/TLS xswitch.cn:5060;branch=z9hG4bK74bf9\newline
Max-Forwards: 70\newline
From: {\color{yellow!60!white}\Oldtexttt{"}Seven Du\Oldtexttt{"}} <sip:seven@xswitch.cn>;tag=9fxced76sl\newline
To: You <sip:you@xswitch.cn>\newline
Call-ID: 3848276298220188511@xswitch.cn\newline
CSeq: 2 INVITE\newline
Contact: <sip:seven@xswitch.cn;transport=tls>
}}
\end{adjustwidth}

\color{black}
}
```

LaTex 的语法比较奇怪，还是那句话，懂不懂没关系（因为模板我已经写好了啊，除非你要做自己的封面 ;)）。

不过瘾？下面再来一个。

## cover-std.tex

这个文件其实跟`cover.tex`差不多，只是调整了一些尺寸，看看`diff`吧：

```diff
$ diff cover.tex cover-std.tex
8c8
< \shadowoffset{1pt}
---
> \shadowoffset{2pt}
21c21
<   \textbf{\fontsize{36}{48}\selectfont\shadowtext{技术图书排版}}
---
>   \textbf{\fontsize{72}{96}\selectfont\shadowtext{技术图书排版}}
23c23
<   \Oldincludegraphics[width=0.5\paperwidth]{img/wenji.png}
---
>   \Oldincludegraphics[width=0.4\paperwidth]{img/wenji.png}
25c25
<   \textbf{\large \theauthors \quad 著\\[2em]}
---
>   \textbf{\huge \theauthors \quad 著\\[2em]}
28,29c28,29
< \begin{textblock*}{4cm}[0.5,0.5](0.5\paperwidth, 13.8cm)
< \small
---
> \begin{textblock*}{4cm}[0.5,0.5](0.5\paperwidth, 24cm)
> \Large
38d37
< \begin{adjustwidth}{-2.3mm}{}
41c40
< \small
---
> \Large
51d49
< \end{adjustwidth}
```

## header.tex

嗯，标准的书上都有个『图书在版编目（CIP）数据』，我们的书还没有出版，就加上个『不』吧。

其中`tabular`是表格，其它的不多解释了吧，对照效果图自己看，哈哈。

```tex
\newpage
\pagecolor{white}
\thispagestyle{empty}
% \vspace*{0.5cm}
\noindent\textbf{图书不在版编目（NCIP）数据}

\vspace{1em}

\noindent\thetitle/\theauthor\quad 著/2019.7
\\
\noindent ISBN 7-DU-777777-7

% \vspace*{2cm}

\noindent {本书分享写作FreeSWITCH相关图书过程中总结的一些排版经验，也使用了类似《FreeSWITCH文集》的封面。}

\bigskip
\vfill
\noindent {\bf \thetitle}
\begin{adjustwidth}{-2.3mm}{}
\begin{tabular}{cl}
  \hline
  {\bf 作\qquad 者} & \theauthor\\
  {\bf 封面设计    } & \theauthor\\
  {\bf 校\qquad 对} & \theauthor\\
  {\bf 排\qquad 版} & \theauthor\\
  {\bf 责任编辑} & \theauthor\\
  {\bf 开\qquad 本} & \printlen[0][mm]{\paperwidth} × \printlen[0][mm]{\paperheight}\\
  {\bf 印\qquad 张} & 7.5\\
  {\bf 印\qquad 数} & 7\\
  {\bf 版\qquad 数} & 2019年7月第1版\quad 2019年7月第1次发布\\
  {\bf 电子邮箱}   &  freeswitch@dujinfang.com \\
  \hline
\end{tabular}
\end{adjustwidth}
\vfill
\begin{center}
  {\bf \thepublisher}
\end{center}
```
