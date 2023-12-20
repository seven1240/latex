# Pandoc 安装与使用 {#pandoc}

我一般都使用 Pandoc 将 Markdown 文件生成 PDF 与 HTML。这里简单记录一下我的安装和使用经验，供参考。

## 安装 Pandoc

一般来说，安装 Pandoc 可以直接按官方的方法安装：<https://pandoc.org/installing.html>。

## 安装 Latex

如果你只是生成`docx`和 HTML 格式的文件，则不需要安装 Latex，但如果需要生成 PDF，就需要。

安装 Latex 比较麻烦，而且占用很大的空间（完成安装要 3 ～ 5G）一般有如下两种安装方式：

- MacTEX：完整安装，参见 <https://www.tug.org/mactex/>
- BasicTex：小型安装，参见： <https://www.tug.org/mactex/morepackages.html>
- TinyTex：另一个小型安装方法，参见：<https://yihui.org/tinytex/>

如果你不想让 Latex“污染”本地的系统，又熟悉 Docker，最好使用后面的 Docker 运行 Pandoc 和 Latex，不过，Docker 要稍慢一些。

### 在 macOS 上安装 Pandoc 和 Latex

在 macOS 上安装 Pandoc 非常简单，只需要执行如下命令即可：

```bash
brew install pandoc
```

安装 Latex：

```
brew install --cask basictex
```

安装后会影响环境变量，打开一个新 Shell 检查如下命令是否可以正常执行：

```bash
latex -v
xelatex -v
pdflatex -v
```

如果还有问题，可以找到`basictex`的安装的 Package，双击重新安装，安装包的名称因时间不同，笔者的路径如下：

```
/opt/homebrew/Caskroom/basictex/2022.0314/mactex-basictex-20220314.pkg
```

使用如下命令找到的（注意，旧版的 Homebrew 会将软件安装在`/usr/local/`而不是`/opt/`）：

```
brew list basictex
find /opt -name mactex-basictex-20220314.pkg
```

如果你使用本书的 Latex 模板，则需要下载一些对应的中文字符，这些字体大部分可以在下面的网址中找到。为了方便使用这些字体，我本地维护了一个 Makefile 和一个`.cache`目录，通过`make cache`就能下载这些字体。

```makefile
.cache:
	mkdir .cache
cache: .cache
	cd .cache && \
	cp ../sources.list* . && \
	cp ../install-bin-unix.sh . && \
	curl -L -o NotoSansCJK-Bold.ttc https://github.com/seven1240/font/raw/master/noto/NotoSansCJK-Bold.ttc/NotoSansCJK-Bold.ttc && \
	curl -L -o NotoSansCJK-DemiLight.ttc https://github.com/seven1240/font/raw/master/noto/NotoSansCJK-DemiLight.ttc/NotoSansCJK-DemiLight.ttc && \
	curl -L -o NotoSerifCJK-Regular.ttc https://github.com/seven1240/font/raw/master/noto/NotoSerifCJK-Regular.ttc/NotoSerifCJK-Regular.ttc && \
	curl -L -o NotoSansMonoCJKsc-Regular.otf https://github.com/seven1240/font/raw/master/noto/NotoSansMonoCJKsc/NotoSansMonoCJKsc-Regular.otf && \
	curl -L -o SourceCodePro-Regular.ttf https://raw.githubusercontent.com/adobe-fonts/source-code-pro/release/TTF/SourceCodePro-Regular.ttf && \
	curl -L -o SourceCodePro-It.ttf https://raw.githubusercontent.com/adobe-fonts/source-code-pro/release/TTF/SourceCodePro-It.ttf && \
	curl -L -o adobekaitistd-regular.otf https://github.com/seven1240/font/raw/master/adobe/adobekaitistd-regular.otf && \
	curl -L -o adobefangsongstd-regular.otf https://github.com/seven1240/font/raw/master/adobe/adobefangsongstd-regular.otf && \
	curl -L https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-amd64.tar.gz --output pandoc-2.19.2-linux-amd64.tar.gz && \
	curl -L https://github.com/jgm/pandoc/releases/download/2.19.2/pandoc-2.19.2-linux-arm64.tar.gz --output pandoc-2.19.2-linux-arm64.tar.gz

cache-google:
	cd .cache && \
	curl -L -o NotoSansMonoCJKsc-Regular.otf https://github.com/googlefonts/noto-cjk/raw/main/Sans/Mono/NotoSansMonoCJKsc-Regular.otf && \
	curl -L -o NotoSansMonoCJKsc-Bold.otf https://github.com/googlefonts/noto-cjk/raw/main/Sans/Mono/NotoSansMonoCJKsc-Bold.otf

cache-sara:
	cd .cache && \
	curl -L -o sarasa-mono-sc-nerd-bold.ttf https://github.com/laishulu/Sarasa-Mono-SC-Nerd/raw/master/sarasa-mono-sc-nerd-bold.ttf && \
	curl -L -o sarasa-mono-sc-nerd-regular.ttf https://github.com/laishulu/Sarasa-Mono-SC-Nerd/raw/master/sarasa-mono-sc-nerd-regular.ttf
```

字体下载后，找到相应的字体文件（注意`.cache`在 macOS 上默认是个隐藏目录，可以`ls -l`查看，或`open .cache`打开），双击相应的字体文件即可以安装字体。

**注意**：在 2023 年初的 macOS 版本中（我的是 13.1 (22C65)），不知道是 macOS 本身的问题还是字体的问题，有些 Noto Sans 字体会相互覆盖，这时候就不要双击安装，把字体文件直接拖到`～/Library/Fonts`目录下即可（可通过 Font Book 菜单上的【文件】⇒【在 Finder 中打开】）。

安装完字体后，可以使用`fc-list`查看是否安装成功。如：

```bash
fc-list
fc-list | grep Noto
```

Latex 和字体安装成功后，还需要安装宏包。具体的宏包名称可以在`make`的时候看到，如果缺少对应的宏包就会出错，这时可以使用`tlmgr`安装。如：

```bash
tlmgr install longtable
sudo tlmgr install longtable # 有时候需要使用sudo
```

### 在 Linux 上安装 Pandoc 和 Latex

如果你使用 Debian 或 Ubuntu，可以参考如下命令：

```bash
apt-get update && apt-get install -y \
  --no-install-recommends --no-install-suggests \
  graphviz mscgen ttf-mscorefonts-installer pandoc \
  libgmp10 texlive-xetex lmodern texlive-fonts-recommended wget fontconfig \
  make ca-certificates locales xz-utils \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
  && mkdir /root/texmf && cd /root/texmf && tlmgr init-usertree \
  && tlmgr install zhspacing \
  && tlmgr install changepage \
  && tlmgr install ulem \
  && tlmgr install soul
```

如果你需要最新版本的 Pandoc，可以直接下载 Tar 包解压安装，如：

```bash
tar xvzf pandoc-3.0.1-linux-amd64.tar.gz--strip-components 1 -C /usr/local
```

### 在 Windowsh 安装 Pandoc 和 Latex

笔者没有使用 Windows 系统，请参照上面官方链接中的方法安装。如果你有好的经验和建议，也欢迎告诉我。

如果你没有经验或不想折腾，那建议使用 Docker，参见<https://docs.xswitch.cn/xpedia/docker/>。

## 使用 Docker

Pandoc 安装和使用很简单，但是如果要生成 PDF 就需要安装 Latex，而 Latex 非常庞大，而且安装比较麻烦，因此，我制作了一个 Docker 镜像，集成了大多数我用到的工具，方便大家也方便我自己使用。

你在本书的 Makefile 中应该可以看到如下内容：

```makefile
docker:
	docker run --rm -it -v `PWD`:/team ccr.ccs.tencentyun.com/free/pandoc:tiny-3.0.1 bash
```

基本的使用方法是执行`make docker`，它会将当前目录挂载到镜像中的`/team`目录中，然后进入 Docker 容器的命令行，你可以在容器中执行任何命令，如`make`，`make docx`等。

上述镜像在腾讯云上。此外，我还制作使用过其他不同版本的镜像，具体如下：

- `multiarch`：arm64 及 amd64 镜像，基于 Ubuntu Jammy
- `m1`：arm64 镜像，基于 Ubuntu Jammy
- `tiny`：arm64 及 amd64，基于 Debian Bookworm 及<https://yihui.org/tinytex/>，镜像最小。
- `latest`：arm64 及 amd64，基于 Debian Bookworm
- `3.0.1`：pandoc 3.0.1
- `tiny-3.0.1`：pandoc 3.0.1

```
$ docker image ls ccr.ccs.tencentyun.com/free/pandoc
REPOSITORY                           TAG         IMAGE ID      SIZE
ccr.ccs.tencentyun.com/free/pandoc   3.0.1       3e18c37be4e3  1.1GB
ccr.ccs.tencentyun.com/free/pandoc   tiny-3.0.1  8cc1f2bb499b  829MB
ccr.ccs.tencentyun.com/free/pandoc   tiny        bebbeee87788  719MB
ccr.ccs.tencentyun.com/free/pandoc   latest      3036623e1d31  913MB
ccr.ccs.tencentyun.com/free/pandoc   m1          81902b42b585  849MB
ccr.ccs.tencentyun.com/free/pandoc   multiarch   ac93363c5ab3  739MB
```

上述内容是在 2023 年初的情况，本文档不保证实时更新，仅供参考。
