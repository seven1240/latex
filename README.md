# 前　言 {-}

我出过一本书——《FreeSWITCH权威指南》，也写过很多FreeSWITCH相关的电子书。有读者问我是怎么排版的，不揣鄙陋，愿与大家分享。

我最初写博客都是使用的是Markdown[^markdown]，后来写书也使用Markdown做简单排版。但一到出版社编辑那儿，就必须用Word了。也跟出版社聊过，是否可以用Latex排版，但出版社的答复是养一个Latex排版师太贵了，因此，作者们还是需要使用Word排版。

[^markdown]: <https://en.wikipedia.org/wiki/Markdown>

对于那些写小说或故事的作者，或许用Word排版还是不错的，但是，对于像我这样的技术人员，由于书中有很多代码和图表，用Word排版就比较累，尤其是技术人员好多都在用Mac，与Windows版的Word兼容性还比较差，写起来就更痛苦了。

使用Markdown格式写作，比Word要轻松多了，同时，使用一些辅助工具也能做到比较好的排版。如果万一有一天写出来的书能够正式出版，也希望Word是最后一步，把痛苦留到最后。

Word有一个功能确实不大好替代，那就是『修订』功能，使用它可以让作者和编辑很方便地交互修改文件。但文件传来传去也很烦。不知道一些在线的协作工具如石墨文档等，是否适合这种协作。

当然，其实作者不应该关注排版，而是在保证内容正确的前提下，把章节、强调、引用、代码之类的都标注出来即可，出版社是有专人进行排版的。而做这些标注，Markdown就够了。而且Markdown文件可以很方便地放到Git仓库中。我们不期望出版社所有的编辑也能熟悉Git，但如果真有哪天编辑们也喜欢Git了，那社会就真的进步了。

关于排版，本书主要讲一下相关的模板，以及一些排版原则：

* 支持标准的Markdown，暂不支持各种扩展；
* 使用开源字体；
* 代码应该有单独的格式，用等宽字体，最好支持语法高亮；
* 应该有移动版，目前大多数PDF并不适合在手机上阅读；
* 移动版不应该首行缩进，因为页面太窄，缩进反而影响阅读体验；
* 标准版应该首行缩进；
* 印刷版应该奇偶页不同；
* 提供Word版方便与其它人交流；
* 还可以生成EPUB电子书等其它格式，欢迎提pr。

本书是可以『自举』的，也就是说你可以通过本书的源代码生成本书的PDF。参见：

<https://github.com/seven1240/latex>

最后，本书写作的目的并不是教你成为一个排版专家，相反，希望通过分享我的排版模板，让广大技术人员专注于用自己喜欢的工具写好自己的作品，忘记排版 ;)。

> 杜金房/2019/烟台
