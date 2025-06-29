# 写在最后 {- #last}

到此，我们该写一个后记了。如果你查看源文件，你可以看到从这里开始的相关的章节名字后面有`{-}`标记，它告诉 LaTex 按章节排版但不再生成章节号。

本书所有源代码都可以在 Github 上找到：<https://github.com/seven1240/latex>。

用 LaTex 排版，你几乎可以排出任何你想要的效果。但是，我们在本书中只使用了基本的 LaTex 的模板，在表格、图文混排方面还有很多不尽人意。不过，我们的目标并不是做一个完美的排版，因为那样需要在正文中插入很多跟内容不相关格式代码，就背离了我们想使用 Markdown 把文章写的简单清新的初衷了。所以，我们只是尽力而为，做一个『足够好看』的电子书即可。

如果你的书真的要出版，出版社会帮你排版的。

LaTex 的学习曲线也是很陡的，而且在 LaTex 中处理中文，就需要更多的技巧。所幸，现在中文都统一的 UTF-8 编码了，所有一定保证所有源文件都保存成 UTF-8 的。如前言中所述，本书不是希望教你成为一个排版专家，这些模板已经写好了，直接拿去用就可以了。当然，如果你真是个排版专家，也欢迎提到 Github 上提`PR`帮我们做得更好。

我们还有以下问题没有解决：

- 在正文中自由切换字体比较困难，如临时变成楷体、仿宋等[^fonts-support]。
- 表格，我想默认设成 100% 宽度，如：

| 第一列 | 第二列                |
| ------ | --------------------- |
| 这是   | 一张表格              |
| 内容   | 太短了不好看          |
| 不知   | 有没有办法宽度 100% ? |

[^fonts-support]: 这个现在已经可以支持了，需要`cjk`宏包，但是这个包依赖占用的磁盘空间比较大，没有包含到 Docker 镜象中。

# 作者简介 {- #author}

**杜金房**：（网名：Seven Du），《FreeSWITCH 权威指南》[^fsdg]、《Kamailio 实战》、《深入理解 FFmpeg》作者、FreeSWITCH 中文社区[^fscn]创始人，FreeSWITCH 开源项目[^freeswitch]核心 Committer，开源爱好者。北京信悦通科技和烟台小樱桃科技[^xyt]创始人。RTE 社区主理人。腾讯云 TVP。

他目前在写一本新书：[《大道至简，给所有人看的编程课》](https://book.dujinfang.com/2023/12/07/dead-simple.html?f=typesetting)。

<https://book.dujinfang.com/2023/12/07/dead-simple.html?f=typesetting>

[^fsdg]: <http://book.dujinfang.com>，2014 年出版。
[^fscn]: <http://www.freeswitch.org.cn>
[^freeswitch]: <https://freeswitch.com>
[^xyt]: <http://x-y-t.cn>

# 版权声明 {- #copyright}

本书版权归作者所有，保留所有权利。本书相关的模板代码采用创作共用 CC-BY-SA[^cc]发布。

[^cc]: [https://zh.wikipedia.org/wiki/Wikipedia:CC_BY-SA_3.0 协议文本>](https://zh.wikipedia.org/wiki/Wikipedia:CC_BY-SA_3.0%E5%8D%8F%E8%AE%AE%E6%96%87%E6%9C%AC)

# 广告 {- #ad}

## 关于广告的广告 {-}

请允许我在本书中发布广告。承接其它广告。广告合作联系邮箱：info@x-y-t.cn 。

## 《大道至简，给所有人看的编程课》 {-}

我写过好几本书，但相对而言，那些书都有些太专业、受众太“窄”了。我一直想写一本能惠及“所有人”的编程书。现在，来了。

[《大道至简，给所有人看的编程课》](https://book.dujinfang.com/2023/12/07/dead-simple.html?f=typesetting)。

<https://book.dujinfang.com/2023/12/07/dead-simple.html?f=typesetting>

## XSwitch {-}

**XSwitch 是一个高度可定制的音视频通信平台** <https://xswitch.cn>

XSwitch 是一个 SSaaS（Soft-Switch as a Service）平台，可以用来：

- 打电话
- 电话会议
- 视频会议
- 呼叫中心
- 录音录像
- 其它音视频互通等

支持私有化部署。

## 技术支持 {- #support}

烟台小樱桃网络科技有限公司提供商业 FreeSWITCH、OpenSIPS 及 Kamailio 技术支持。

- 网址：<http://x-y-t.cn>
- 邮箱：info@x-y-t.cn

下面是我们的微信公众号。为了能将两张图片排在一行上，直接使用了 Latex 代码。另外两张图片尺寸不同，所以两栏的宽度不是`0.5:0.5`，而是`0.55:0.44`（注意两者加起来小于 1，这主要是为了防止移动版图片放不开产生换行），其中`\linewidth`为行宽。图片只能在 PDF 中显示，在 Word 文档和 HTML 中无法生成。

\begin{figure}
\begin{subfigure}{.55\linewidth}
\centering
\Oldincludegraphics[width=.99\linewidth]{img/xyt1.jpg}
\caption{小樱桃科技}
\end{subfigure}
\begin{subfigure}{.44\linewidth}
\centering
\Oldincludegraphics[width=.99\linewidth]{img/qr-wechat.png}
\caption{FreeSWITCH-CN}
\end{subfigure}
\end{figure}

上述图片的 Latex 代码如下：

```tex
\begin{figure}
\begin{subfigure}{.55\linewidth}
  \centering
  \Oldincludegraphics[width=.98\linewidth]{img/xyt1.jpg}
  \caption{小樱桃科技}
\end{subfigure}
\begin{subfigure}{.44\linewidth}
  \centering
  \Oldincludegraphics[width=.98\linewidth]{img/qr-wechat.png}
  \caption{FreeSWITCH-CN}
\end{subfigure}
\end{figure}
```

以下图片仅在 HTML 中显示，代码如下：

<div>
<img src="img/xyt1.jpg" alt="小樱桃科技 微信公众号">
<img src="img/qr-wechat.png" alt="FreeSWITCH-CN微信公众号">
</div>

```html
<div>
  <img src="img/xyt1.jpg" alt="小樱桃科技 微信公众号" />
  <img src="img/qr-wechat.png" alt="FreeSWITCH-CN微信公众号" />
</div>
```

## FreeSWITCH 相关图书 {- #books}

- 《FreeSWITCH 文集》收集了一些 FreeSWITCH 文章，相比其它 FreeSWITCH 书来说，技术内容比较少，便于非技术人员快速了解 FreeSWITCH。
- 《FreeSWITCH 互联互通》主要收集了一些互联互通的例子，书中有些例子来自《FreeSWITCH 权威指南》。
- 《FreeSWITCH 实例解析》收集了一些如何使用 FreeSWITCH 的实际例子，方便读者参考。书中有些内容来自《FreeSWITCH 权威指南》。
- 《FreeSWITCH：VoIP 实战》是《FreeSWITCH 权威指南》的前身，不再更新，但该书是很好的入门书且有其历史意义。
- 《FreeSWITCH WIRESHARK》 是一本介绍如何使用 Wireshark 分析 SIP/RTP 数据包的书。
- 《FreeSWITCH 源代码分析》主要讲解源代码。
- 《FreeSWITCH 权威指南》是正式出版的纸质书和电子书，出版于 2014 年。
- 《[FreeSWITCH 案例大全](http://www.freeswitch.org.cn/books/case-study/)》是一本多人贡献的电子书，收集了很多 FreeSWITCH 实用案例，免费在线阅读。
- 《[FreeSWITCH 参考手册](http://www.freeswitch.org.cn/books/references)》是一本多人贡献的电子书，收集了很多 FreeSWITCH 实用参考，免费在线阅读。
- 《Kamailio 实战》是关于 Kamailio Proxy Server 的书，与 FreeSWITCH 一起学习事半功倍。

以上所有图书均可以在 <http://book.dujinfang.com> 查看最新信息及购买。FreeSWITCH VIP 知识星球里面也有部分电子书。

## 知识星球 {- #zsxq}

杜老师维护着两个知识星球，一个免费版，一个收费版。可以使用如下链接或通过微信扫描二维码加入。

- FreeSWITCH：<https://t.zsxq.com/RBi6Ee2>
- FreeSWITCH VIP：<https://t.zsxq.com/2zb6qBE>

![知识星球](img/zsxq.jpg)

# {-}

THIS PAGE INTENTIONALLY LEFT BLANK.
