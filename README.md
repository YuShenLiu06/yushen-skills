<h1 align="center">yushen-skills</h1>

<p align="center">
  YuShen 的 5 个 AI 助手技能<br>
  <strong>先复用 · 少绕路 · 用证据交付</strong>
</p>

<p align="center">
  <a href="#选择技能">选择技能</a> ·
  <a href="#快速开始">快速开始</a> ·
  <a href="#许可与来源">许可与来源</a>
</p>

从需求到开发、审查与交付，把工作方法写成可按需读取的 `SKILL.md`，帮助助手围绕完整目标协作。

## 选择技能

| 你要做什么 | 使用技能 |
| --- | --- |
| 死代码、重复实现与复用 | [代码审查](skills/yushen-code-quality-review/SKILL.md) |
| 权限、隔离、数据与恢复 | [安全审查](skills/yushen-security-review/SKILL.md) |
| 开发、自证、审查与验收 | [开发协作](skills/yushen-pr-cycle/SKILL.md) |
| 安装、授权与日常操作 | [产品交互](skills/yushen-product-ux/SKILL.md) |
| 真实下载、安装与产物验收 | [产物验收](skills/yushen-release-acceptance/SKILL.md) |

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

自有内容采用 [MIT](LICENSE)。复制或分发时，请一并携带 `LICENSE` 和 [THIRD_PARTY_NOTICES.txt](THIRD_PARTY_NOTICES.txt)。

实际来源、外部借鉴与整理边界见 [致谢](ACKNOWLEDGEMENTS.md)；不将通用学习技能或第三方方法宣称为 YuShen 原创。
