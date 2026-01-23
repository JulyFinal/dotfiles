* Dependency manager: uv
* Linter / formatter: ruff
* 使用 pydantic-settings 进行配置管理， 配置文件为 .env
* Data validation: pydantic>=2
* Task runner: poethepoet (format, check, metrics, etc.)
* Testing: pytest
* 需要数据库的时候 如果不是大型工程 应该优先使用 peewee, 否则应该考虑 sqlalchemy
* lsp 使用 ty


# streamlit 高位替代
https://github.com/violit-dev/violit


https://adplist.substack.com/p/why-you-should-steal-design # 设计相关 自然过度


# python

https://github.com/reflex-dev/reflex # foward & backend in one with python
https://github.com/linsuiyuan/litedis # redis like , but pure python


# skills

https://www.ui-skills.com/


# claude code dev 
https://www.zhihu.com/question/1914086301076029991

通过一位技术博主长达数月的深度抓包分析，揭开了 Claude Code 体验如此「丝滑上头」的秘密。真正的魔力不在于堆砌复杂框架，而在于极致的「可调试性」与「简单设计」。

单一循环的威力：Claude Code 99% 的场景只用一个主循环，最多带一个分支，这看似简单，却让调试难度直线下降。它就像自动驾驶，给模型一个清晰的约束框架，然后让它自己「大展身手」，避免了多智能体系统那种「害怕破坏而不敢改动」的脆弱性。

「小模型」的大智慧：超过 50% 的重要调用都交给了更便宜的「小模型」Claude-3.5-Haiku，用来读文件、解析网页、总结对话，甚至每次按键都会调用。这背后是成本降低 70-80% 的精明算盘，把算力花在刀刃上。

引导模型的「土方法」：想让 AI 听话干活，最有效的提示词技巧有时朴实得惊人——直接在指令里大喊「PLEASE THIS IS IMPORTANT」。这就是与 AI 协作的一个反直觉真相：清晰的指令和强烈的情绪信号，往往比复杂的算法绑定更管用。

所以说，Claude Code 的成功，是「架构简洁」与「提示词详尽」的完美结合。它用一份长达 2800 词的系统提示和 9400 词的工具定义，为模型构建了清晰的「行动剧本」，证明了在 AI 时代，「保持简单」本身就是一种高级的复杂能力。



# RAG

https://blog.gopenai.com/beyond-one-size-fits-all-rag-why-different-knowledge-sources-need-different-retrieval-strategies-355f4fe7897e?gi=9b3f575db630

本文主要围绕构建生产级 RAG 系统展开，作者分享自身构建 AI 产品时，因对不同知识源采用相同处理方式导致失败，进而重建检索系统的经验。首先阐述 RAG 概念，它像开卷考试，能让系统基于检索文档回答问题，但大语言模型（LLM）存在幻觉问题，RAG 也并非能完全解决。RAG 历经几代演变，作者采用模块化 RAG 并针对不同知识源制定特定策略。接着介绍三个知识源面临的问题及解决方案：知识库文本分块后会丢失上下文，通过上下文检索、智能分块和混合搜索解决；平台内容推荐需全文档相关性，采用 LLM 摘要和重排序策略；合规性判断需关键词精确与语义理解，通过混合搜索、LLM 判断和 Redis 缓存三层方法实现。此外，还介绍了包括基于事实、索引引用等五层反幻觉策略。最后提及构建过程中遇到纯向量搜索遗漏关键词等挑战。
