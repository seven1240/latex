# 主模板 {#template}

`template.tex`是我们的主模板。之所以我们将封面等模板放到其它的文件里，是因为这样会便于用一套模板做不同的书。

Latex文档的开头叫导言区（Preamble），定义了纸张及其它排版的参数。`if-else`之类的条件判断是Pandoc加上去的，它会根据命令行上输入的参数不同选择不同的设置，比如一般的图书用`report`，而一篇文章则用`article`。你也可以看到，如果有`print`参数生成可以印刷图书的话，那就会加上`twoside,openright`以支持双面打印，以及奇偶而不同之类。

```tex
\documentclass[$if(fontsize)$$fontsize$,$endif$$if(lang)$$lang$,$endif$CJKutf8$if(print)$,twoside,openright$endif$]{$documentclass$}
```

中文支持设定。

```tex
\XeTeXlinebreaklocale "zh"
\XeTeXlinebreakskip = 0pt plus 1pt minus 0.1pt
\hyphenation{FreeSWITCH}
\usepackage{xprintlen} % print paper length in mm
```

根据变量设置纸张大小。

```tex
$if(mobile)$
% \usepackage[showframe=true,papersize={9cm, 16cm}, text={8.4cm, 14cm}]{geometry}
\usepackage[papersize={9cm, 16cm}, text={8.4cm, 14.1cm}]{geometry}
$else$
$if(print)$
\usepackage[papersize={19cm, 23.6cm},text={15cm, 19.6cm}]{geometry}
$else$
\usepackage[top=1in,bottom=1in,left=1.25in,right=1.25in]{geometry}
$endif$
$endif$
```

跟字体相关的设置。我们使用了谷歌的思源CJK（中日韩文）字体[^noto-fonts]。嗯，因为该字体是开源的。如果你使用其它字体嵌入到PDF中，要注意字体的版权问题。

[^noto-fonts]: <https://www.google.com/get/noto/>

`mainfont`是主字体，`monofont`是等宽字体，`romanfont`就是英文相关的代码相关的字体，我们实验性地使用了Adobe的Source Code Pro，因为它有斜体（Italic），注意中文是没有斜体的，我们用楷体或德意黑体[^smiley-sans]代替。所有用到的字体都已经打包到了Docker镜象里，如果你不使用Docker，你需要下载并安装这些字体。可以从它们的官方网站上找找，或者到<https://github.com/seven1240/font>上面找。

[^smiley-sans]: 德意黑体是2022年发布的免费开源字体，本身就是按斜体设计的，参见 <https://github.com/atelier-anchor/smiley-sans> 。

```tex
\usepackage{changepage}
\usepackage{float}
\usepackage{fontspec}
\newcommand\mainfont{Noto Sans CJK SC DemiLight}
\newcommand\boldfont{Noto Sans CJK SC Bold}
\newcommand\itfont{Smiley Sans}
\newcommand\kaifont{Adobe Kaiti Std}
\newcommand\fangsong{Adobe Kaiti Std}
\setmainfont[BoldFont=\boldfont,ItalicFont={\kaifont}]{\mainfont}
\newfontfamily\kai{\kaifont}
\newfontfamily\fs{\fangsong}
\newfontfamily\zhfont[BoldFont=\boldfont,ItalicFont={\kaifont}]{\mainfont}
\newfontfamily\zhpunctfont[BoldFont=\boldfont]{\mainfont}
\setromanfont[Mapping=tex-text,BoldFont=\boldfont,ItalicFont=\itfont]{\mainfont}
\setmonofont{Noto Sans Mono CJK SC}
```

设置中文间距等（最新版的可能不需要了）。

```tex
\usepackage{zhspacing}
\zhspacing
```

`longtable`支持跨页的表格，普通表格不能跨页。

```tex
\usepackage{longtable}
```

首行缩进。如果是手机端，就不缩进，因为手机屏幕比较小，缩进会不好看。

```tex
\usepackage{indentfirst}

$if(mobile)$
\setlength{\parindent}{0em}
$else$
\setlength{\parindent}{2em}
$endif$
```

`fancyvrb`是设置每页的页眉和页脚格式。注意`\leftmark`和`rightmark`是设成奇偶页不同的。

```tex
\usepackage{fancyvrb}
\DefineVerbatimEnvironment{verbatim}{Verbatim}
{frame=lines,
framerule=0.4pt,
baselinestretch=1,
fontfamily="Source Code Pro",
fontsize=\tiny,
xleftmargin=0pt,
xrightmargin=0pt,
rulecolor=\color{grey},
framesep=3mm,
numbers=left,
samepage=true
}
\fvset{frame=lines,framerule=0.4pt,rulecolor=\color{cyan},framesep=3mm}

\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhead{}
\fancyfoot{}
\fancyhead[LO,LE]{$title$}
\fancyfoot[C]{\small ------ \thepublisher ------}
\fancyfoot[RO, LE]{\thepage}
$if(article)$
$else$
% \fancyhead[LE,RO]{\chaptermark}
$endif$
% \fancyhead[LO,RE]{\sectionmark}
$if(mobile)$
$else$
\fancyhead[RO]{\nouppercase{\leftmark}}
\fancyhead[RE]{\nouppercase{\rightmark}}
\headheight 25pt
\headsep 10pt
$endif$
```

默认章节号是英文的，翻译成中文。

```tex
\renewcommand{\contentsname}{目\quad 录}
\renewcommand\listfigurename{插图目录}
\renewcommand\listtablename{表格目录}
% \renewcommand\refname{参考文献}
\renewcommand\indexname{索引}
\renewcommand\figurename{图}
\renewcommand\tablename{表}
\renewcommand\abstractname{摘要}
\renewcommand\partname{第\,\thepart\,部分}
\renewcommand\appendixname{附录}
\renewcommand\today{\number\year 年\number\month 月\number\day 日}
\providecommand{\CJKnumber}[1]{\ifcase#1\or{一}\or{二}\or{三}\or{四}\or{五}\or{六}\or{七}\or{八}\or{九}\or{十}\or{十一}\or{十二}\or{十三}\or{十四}\or{十五}\or{十六}\or{十七}\or{十八}\or{十九}\or{二十}\or{二十一}\or{二十二}\or{二十三}\or{二十四}\or{二十五}\or{二十六}\or{二十七}\or{二十八}\or{二十九}\or{三十}\fi}

\usepackage{titlesec}
\titleformat{\chapter}{\centering\LARGE\bfseries}{\textbf{第\CJKnumber{\thechapter}章}}{0.5em}{}
$if(article)$
$else$
\renewcommand{\chaptername}{第\CJKnumber{\thechapter}章}
$endif$

\titleformat{\part}{\centering\Huge}{第\,\thepart\,部分}{1em}{}
\renewcommand\partname{第\,\thepart\,部分}
```

这一段设置不知道是否起作用，还是页眉页脚相关的。

```tex
\usepackage{fancyvrb}
\fvset{fontsize=\footnotesize}
% \fvset{xleftmargin=0.8cm}
\fvset{frame=lines,framerule=0.4pt,rulecolor=\color{cyan},framesep=3mm}
% \fvset{commandchars=\\\{\}}
```
Verbatim是代码段的环境。

```tex
\RecustomVerbatimEnvironment{verbatim}{Verbatim}{}
```

设置一些颜色。

```tex
\usepackage[usenames, dvipsnames]{xcolor}
\definecolor{mygray}{gray}{0.9}
\definecolor{darkblue}{rgb}{0.0, 0.0, 0.61}
\definecolor{indigo}{rgb}{0.29, 0.0, 0.51}
\definecolor{navyblue}{rgb}{0.0, 0.0, 0.5}
\definecolor{NAVYBLUE}{rgb}{0.0, 0.0, 0.5}
\definecolor{myyellow}{RGB}{255,255,0}
\definecolor{thegray}{RGB}{60,60,60}
\definecolor{darkblue}{RGB}{0,0,139}
\definecolor{lime}{RGB}{0,255,0}
\definecolor{wireshark}{RGB}{0,153,204}
\definecolor{wireshark1}{RGB}{102,204,255}
\definecolor{BLACK}{rgb}{0.0, 0.0, 0.0}
\definecolor{darkgreen}{RGB}{0,100,0}
```

> 设置引用相关的字体和颜色，比如本段就是一段引用，源文件中以`>`开头，注意到了吗？

```tex
\newfontfamily\quotefont{STKaiti}
\let\quoteOLD\quote
\def\quote{\quoteOLD\color{thegray}\small\quotefont\selectfont}
```

奇偶页不同的设置。

```tex
$if(print)$
\let\tmp\oddsidemargin
\let\oddsidemargin\evensidemargin
\let\evensidemargin\tmp
\reversemarginpar
$endif$
```

还是代码段环境的一些设置。在行内代码和公式的情况下，两侧加入半个字宽的空格，中英文混排时更好看。

```tex
% for inline code
\let\Oldtexttt\texttt
\renewcommand{\texttt}[1]{\Oldtexttt{\,\color{navyblue}#1\color{black}\,}}
\let\Oldeqopen\(
\renewcommand{\(}{\Oldeqopen\,\color{navyblue}}
\let\Oldeqclose\)
\renewcommand{\)}{\Oldeqclose\,}
```

数学公式相关。

```tex
% \usepackage{lmodern}
\usepackage{amssymb,amsmath}
```

这是Pandoc提供的模板的一些默认设置，没改，也没有深入研究。

```tex
\usepackage{ifxetex,ifluatex}
\usepackage{fixltx2e} % provides \textsubscript
% use microtype if available
\IfFileExists{microtype.sty}{\usepackage{microtype}}{}
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  \usepackage[utf8]{inputenc}
$if(euro)$
  \usepackage{eurosym}
$endif$
\else % if luatex or xelatex
  \usepackage{fontspec}
  \ifxetex
    \usepackage{xltxtra,xunicode}
  \fi
  \defaultfontfeatures{Mapping=tex-text,Scale=MatchLowercase}
  \newcommand{\euro}{€}
$if(mainfont)$
    \setmainfont{$mainfont$}
$endif$
$if(sansfont)$
    \setsansfont{$sansfont$}
$endif$
$if(monofont)$
    \setmonofont{$monofont$}
$endif$
$if(mathfont)$
    \setmathfont{$mathfont$}
$endif$
\fi
$if(geometry)$
\usepackage[$for(geometry)$$geometry$$sep$,$endfor$]{geometry}
$endif$
$if(natbib)$
\usepackage{natbib}
\bibliographystyle{plainnat}
$endif$
$if(biblatex)$
\usepackage{biblatex}
$if(biblio-files)$
\bibliography{$biblio-files$}
$endif$
$endif$
```

`listings`也是代码段环境，但我们好像没有用到（或者是以前用到会有什么问题），如果在命令行参数中使用`--listings`就可以启用它。

```tex
$if(listings)$
\usepackage{listings}
\lstset{ % General setup for the package
  language=perl,
  basicstyle=\small\sffamily,
  numbers=left,
  numberstyle=\tiny,
  frame=tb,
  tabsize=4,
  columns=fixed,
  showstringspaces=false,
  showtabs=false,
  keepspaces,
  commentstyle=\color{red},
  keywordstyle=\color{blue},
  backgroundcolor=\color{mygray},
  rulecolor=\color{cyan},
  % fancyvrb=true,
  breaklines=true
}
$endif$

$if(lhs)$
\lstnewenvironment{code}{\lstset{language=Haskell,basicstyle=\small\ttfamily}}{}
$endif$
$if(highlighting-macros)$
$highlighting-macros$
$endif$
$if(verbatim-in-note)$
\usepackage{fancyvrb}
$endif$
$if(fancy-enums)$
% Redefine labelwidth for lists; otherwise, the enumerate package will cause
% markers to extend beyond the left margin.
\makeatletter\AtBeginDocument{%
  \renewcommand{\@listi}
    {\setlength{\labelwidth}{4em}}
}\makeatother
\usepackage{enumerate}
$endif$
```

设置图片格式默认为图片大小，如果超出页面则自动缩放。

```tex
$if(tables)$
\usepackage{ctable}
\usepackage{float} % provides the H option for float placement
$endif$
\let\Oldincludegraphics\includegraphics
$if(graphics)$
\usepackage{graphicx}
% We will generate all images so they have a width \maxwidth. This means
% that they will get their normal width if they fit onto the page, but
% are scaled down if they would overflow the margins.
\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth
\else\Gin@nat@width\fi}
\makeatother
\let\Oldincludegraphics\includegraphics
\renewcommand{\includegraphics}[1]{\Oldincludegraphics[width=\maxwidth]{#1}}
% hack figure to position figure at Here!
\makeatletter
\renewcommand\fps@figure{H}
\makeatletter
$endif$
```

URL相关的处理，以及其它。

```tex
\usepackage[hyphens]{url}
\ifxetex
  \usepackage[setpagesize=false, % page size defined by xetex
              unicode=false, % unicode breaks when used with xetex
              xetex]{hyperref}
\else
  \usepackage[unicode=true]{hyperref}
\fi
\hypersetup{breaklinks=true,
            bookmarks=true,
            pdfauthor={$author-meta$},
            pdftitle={$title-meta$},
            colorlinks=true,
            urlcolor=$if(urlcolor)$$urlcolor$$else$blue$endif$,
            linkcolor=$if(linkcolor)$$linkcolor$$else$magenta$endif$,
            pdfborder={0 0 0}}
$if(links-as-notes)$
% Make links footnotes instead of hotlinks:
\renewcommand{\href}[2]{#2\footnote{\url{#1}}}
$endif$
$if(strikeout)$
\usepackage[normalem]{ulem}
% avoid problems with \sout in headers with hyperref:
\pdfstringdefDisableCommands{\renewcommand{\sout}{}}
$endif$
% \setlength{\parindent}{2em}
\setlength{\parskip}{6pt plus 2pt minus 1pt}
\renewcommand{\baselinestretch}{1.4}
\setlength{\emergencystretch}{3em}  % prevent overfull lines
$if(numbersections)$
$else$
\setcounter{secnumdepth}{0}
$endif$
$if(verbatim-in-note)$
\VerbatimFootnotes % allows verbatim text in footnotes
$endif$
$if(lang)$
\ifxetex
  \usepackage{polyglossia}
  \setmainlanguage{$mainlang$}
\else
  \usepackage[$lang$]{babel}
\fi
$endif$
```

代码高亮。

```tex
\usepackage{fvextra}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,commandchars=\\\{\}}
```

其它，将变量变成命令以便在正文中使用。

```tex
\usepackage{afterpage}

\newcommand{\thetitle}{$title$}
\newcommand{\theauthor}{$author$}
\newcommand{\theauthors}{$author$}
\newcommand{\thepublisher}{$publisher$}
```

图片和表格的编号默认显示为`m.n`，改为`m-n`格式。

```tex
\renewcommand {\thetable} {\thechapter{}-\arabic{table}}
\renewcommand {\thefigure} {\thechapter{}-\arabic{figure}}
% \renewcommand {\thelisting} {\thechapter{}-\arabic{listing}}
\renewcommand {\theequation} {\thechapter{}-\arabic{equation}}

% fix --listing missing passthrough https://github.com/laboon/ebook/issues/139
% \newcommand{\passthrough}[1]{\lstset{mathescape=false}\color{red}#1\color{black}\lstset{mathescape=true}}
```

命令行中指定的文件可以插入到这些位置。

```tex
$for(header-includes)$
$header-includes$
$endfor$

$if(title)$
\title{$title$}
$endif$
\author{$for(author)$$author$$sep$ \and $endfor$}
$if(date)$
\date{$date$}
$else$
\date{\today}
$endif$
```

文档开始。`\cover`画封面，还记得`cover.tex`吗？

```tex
\begin{document}
\cover
```

封面后的一页，书名和作者、出版社等。

```tex
\newpage
\thispagestyle{empty}
\pagenumbering{gobble}
\begin{center}
\vspace*{2cm}
$if(mobile)$
  \textbf{\huge \thetitle\\[1em]}
  \textbf{\Large \theauthors}
$else$
  \textbf{\Huge \thetitle\\[1em]}
  \textbf{\LARGE \theauthors}
$endif$
\end{center}

\bigskip
\vfill
\begin{center}
{\color{blue}\textbf\thepublisher}
\end{center}
```

用罗马数字标记页号。

```tex
\pagenumbering{Roman}
```

这里插入前言。

```tex
$for(include-before)$
$include-before$
$endfor$
```

如果有`--toc`，则生成目录。

```tex
$if(toc)$
{
\cleardoublepage
\hypersetup{linkcolor=blue}
\tableofcontents
}
$endif$
```

书的正文开始，将页号改为阿拉伯数字。

```tex
\cleardoublepage
\pagenumbering{arabic}
```

正文，Markdown的内容全部会转换成Latex格式放到这儿。

```tex
$body$
```

后面的参考资料之类的，我们这里没有用到。

```tex
$if(natbib)$
$if(biblio-files)$
$if(biblio-title)$
$if(book-class)$
\renewcommand\bibname{$biblio-title$}
$else$
\renewcommand\refname{$biblio-title$}
$endif$
$endif$
\bibliography{$biblio-files$}
$endif$
$endif$
$if(biblatex)$
\printbibliography$if(biblio-title)$[title=$biblio-title$]$endif$
$endif$

$for(include-after)$
$include-after$
$endfor$

\end{document}
```

好玩不？
