# 写在最后 {-}

到此，我们该写一个后记了。如果你查看源文件，你可以看到从这里开始的相关的章节名字后面有`{-}`标记，它告诉LaTex按章节排版但不再生成章节号。

本书所有源代码都可以在Github上找到：<https://github.com/seven1240/latex>。

用LaTex排版，你几乎可以排出任何你想要的效果。但是，我们在本书中只使用了基本的LaTex的模板，在表格、图文混排方面还有很多不尽人意。不过，我们的目标并不是做一个完美的排版，因为那样需要在正文中插入很多跟内容不相关格式代码，就背离了我们想使用Markdown把文章写的简单清新的初衷了。所以，我们只是尽力而为，做一个『足够好看』的电子书即可。

如果你的书真的要出版，出版社会帮你排版的。

LaTex的学习曲线也是很陡的，而且在LaTex中处理中文，就需要更多的技巧。所幸，现在中文都统一的UTF-8编码了，所有一定保证所有源文件都保存成UTF-8的。如前言中所述，本书不是希望教你成为一个排版专家，这些模板已经写好了，直接拿去用就可以了。当然，如果你真是个排版专家，也欢迎提到Github上提`PR`帮我们做得更好。

我们还有以下问题没有解决：

* 在正文中自由切换字体比较困难，如临时变成楷体、仿宋等。
* 表格，我想默认设成100%宽度。


这是 | 一张表格
----|------------
内容 | 太短了不好看
不知 | 有没有办法宽度100%


# 作者简介 {-}

**杜金房**：（网名：Seven Du），《FreeSWITCH权威指南》[^fsdg]、《Kamailio实战》作者、FreeSWITCH中文社区[^fscn]创始人，FreeSWITCH开源项目[^freeswitch]核心Committer，开源爱好者。北京信悦通科技和烟台小樱桃科技[^xyt]创始人。腾讯云TVP。

[^fsdg]: <http://book.dujinfang.com>，2014年出版。
[^fscn]: <http://www.freeswitch.org.cn>
[^freeswitch]: <https://freeswitch.com>
[^xyt]: <http://x-y-t.cn>

# 版权声明 {-}

本书版权归作者所有，保留所有权利。本书相关的模板代码采用创作共用CC-BY-SA[^cc]发布。

[^cc]: [https://zh.wikipedia.org/wiki/Wikipedia:CC_BY-SA_3.0协议文本>](https://zh.wikipedia.org/wiki/Wikipedia:CC_BY-SA_3.0%E5%8D%8F%E8%AE%AE%E6%96%87%E6%9C%AC)

# 广告 {-}

## 关于广告的广告 {-}

请允许我在本书中发布广告。承接其它广告。广告合作联系邮箱：info@x-y-t.cn 。

## XSwitch {-}

**XSwitch是一个高度可定制的音视频通信平台** <https://xswitch.cn>

XSwitch是一个SSaaS（Soft-Switch as a Service）平台，可以用来：

* 打电话
* 电话会议
* 视频会议
* 呼叫中心
* 录音录像
* 其它音视频互通等

支持私有化部署。

## 技术支持 {-}

烟台小樱桃网络科技有限公司提供商业FreeSWITCH、OpenSIPS及Kamailio技术支持。

* 网址：<http://x-y-t.cn>
* 邮箱：info@x-y-t.cn

下面是我们的微信公众号。为了能将两张图片排在一行上，直接使用了Latex代码。另外两张图片尺寸不同，所以两栏的宽度不是`0.5:0.5`，而是`0.56:0.44`，其中`\linewidth`为行宽。图片只能在PDF中显示，在Word文档中无法生成。

\begin{figure}
\begin{subfigure}{.56\linewidth}
  \centering
  \Oldincludegraphics[width=.99\linewidth]{img/xyt1.jpg}
  \caption{小樱桃科技 微信公众号}
\end{subfigure}
\begin{subfigure}{.44\linewidth}
  \centering
  \Oldincludegraphics[width=.99\linewidth]{img/qr-wechat.png}
  \caption{FreeSWITCH-CN 微信公众号}
\end{subfigure}
\end{figure}

上述图片的Latex代码如下：

```tex
\begin{figure}
\begin{subfigure}{.56\linewidth}
  \centering
  \Oldincludegraphics[width=.99\linewidth]{img/xyt1.jpg}
  \caption{小樱桃科技 微信公众号}
\end{subfigure}
\begin{subfigure}{.44\linewidth}
  \centering
  \Oldincludegraphics[width=.99\linewidth]{img/qr-wechat.png}
  \caption{FreeSWITCH-CN 微信公众号}
\end{subfigure}
\end{figure}
```

## FreeSWITCH相关图书 {-}

* 《FreeSWITCH文集》收集了一些FreeSWITCH文章，相比其它FreeSWITCH书来说，技术内容比较少，便于非技术人员快速了解FreeSWITCH。
* 《FreeSWITCH互联互通》主要收集了一些互联互通的例子。书中有些例子来自《FreeSWITCH权威指南》。
* 《FreeSWITCH实例解析》收集了一些如何使用FreeSWITCH的实际例子，方便读者参考。书中有些内容来自《FreeSWITCH权威指南》。
* 《FreeSWITCH实战》是《FreeSWITCH权威指南》的前身，不再更新，但该书有其历史意义。
* 《FreeSWITCH WIRESHARK》是一本介绍如果用Wireshark分析SIP/RTP数据包的书。
* 《FreeSWITCH源代码分析》，讲源代码。
* 《FreeSWITCH权威指南》是正式出版的纸质书和电子书，2014年出版。
* 《Kamailio实战》是作者新写的又一本新书，2022年出版。

以上所有图书均可以在 <http://book.dujinfang.com> 查看最新信息及购买。FreeSWITCH VIP知识星球里面也有部分电子书。

## 知识星球 {-}

杜老师维护着两个知识星球，一个免费版，一个收费版。可以使用如下链接或通过微信扫描二维码加入。

* FreeSWITCH：<https://t.zsxq.com/RBi6Ee2>
* FreeSWITCH VIP：<https://t.zsxq.com/2zb6qBE>

![知识星球](img/zsxq.jpg)

# {-}

THIS PAGE INTENTIONALLY LEFT BLANK.
