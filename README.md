<h1 align="center">yushen-skills</h1>

<p align="center">
  YuShen 的个人技能收藏与实践集合<br>
  <strong>跨领域收藏 · 持续实践 · 逐步扩展</strong>
</p>

<p align="center">
  <a href="#当前收录">当前收录</a> ·
  <a href="#快速开始">快速开始</a> ·
  <a href="#许可与来源">许可与来源</a>
</p>

这里收集我觉得好用的 AI 助手技能与工作方法，不限领域，持续扩展。可以是自己的实践、适配整理，也可以是注明来源与许可的第三方技能。

## 当前收录

按当前任务选择需要的技能：

| 你要做什么 | 使用技能 |
| --- | --- |
| 死代码、重复实现与复用 | [代码审查](skills/yushen-code-quality-review/README.md) |
| 权限、隔离、数据与恢复 | [安全审查](skills/yushen-security-review/README.md) |
| 开发、自证、审查与验收 | [开发协作](skills/yushen-pr-cycle/README.md) |
| 安装、授权与日常操作 | [产品交互](skills/yushen-product-ux/README.md) |
| 真实下载、安装与产物验收 | [产物验收](skills/yushen-release-acceptance/README.md) |
| 精修文档并保留关键信息 | [文档精修](skills/doc-refine/README.md) |
| 明确需要 LaTeX 的 PDF 排版 | [LaTeX 排版](skills/latex-pdf/README.md) |
| 创建本地可编辑流程图 | [可编辑图](skills/editable-flowchart/README.md) |

说明页供人阅读，实际执行规则在各目录的 `SKILL.md`。

## 快速开始

1. [下载本仓库](https://github.com/YuShenLiu06/yushen-skills/archive/refs/heads/main.zip)，将需要的技能**整个目录**放入工具支持的技能目录，例如项目的 `.agents/skills/`；保留其中的 `references/`。
2. 在任务中明确要求助手读取对应文件，例如：

   ```text
   请读取 .agents/skills/yushen-code-quality-review/SKILL.md，
   审查这次 PR 的代码质量与复用机会。
   ```

无需一次加载全部技能。仅放置文件或写一个链接不等于已加载。

## 使用边界

技能约定工作流程，不授予工具、费用、推送、合并或部署权限。外部替代方案只作建议，是否采纳由用户决定。

## 许可与来源

自有整理内容采用 [MIT](LICENSE)；第三方内容遵循各自实际许可证，不因收录而改标 MIT。

[致谢](ACKNOWLEDGEMENTS.md)记录实际来源、外部借鉴与整理边界，[第三方声明](THIRD_PARTY_NOTICES.txt)保留对应版权与许可。不将通用学习技能或第三方方法宣称为 YuShen 原创。

复制或分发本集合时，请一并携带 `LICENSE` 和 `THIRD_PARTY_NOTICES.txt`，并遵守所用内容的适用许可。
