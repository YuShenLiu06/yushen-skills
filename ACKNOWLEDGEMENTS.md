# 来源与整理边界

本集合按 YuShen 的明确要求整理、适配，不将通用设计原则、第三方方法或通用学习技能声明为用户原创。来源信息集中于此，技能执行无需加载本文件或许可文本。

## 实际使用的源文件

代码质量、开发协调、产品设计与产物验收使用用户经正常登录浏览器取得并转交的自有原件整理，按本次明确授权采用 MIT；不公开其私有来源地址。开发与审查还核对了公开固定版本：[learning-station / c566ff841d4cb228fe08dc38c00cf347a0753af5](https://github.com/YuShenLiu06/learning-station/tree/c566ff841d4cb228fe08dc38c00cf347a0753af5)。该版本根 [LICENSE](https://github.com/YuShenLiu06/learning-station/blob/c566ff841d4cb228fe08dc38c00cf347a0753af5/LICENSE) 为 MIT，版权人为 YuShen。

| 本集合 | 源文件 | 整理内容 |
| --- | --- | --- |
| `yushen-code-quality-review` | 用户自有技能原件及完整第三方声明，并对照公开副本 | 保留复用、证据和量化口径；来源移出技能；补齐本次明确要求的收敛与验收边界。 |
| `yushen-pr-cycle` | 用户自有技能、返工总结、REVIEW 示例原件，以及公开开发规则 | 更新三轮收敛、自证截图、自动审查状态与 SHA 核对、四节 PR 正文和组合测试；移除固定型号与套餐；REVIEW 示例改为通用适配。 |
| `yushen-security-review` | `AGENTS.md` 的安全与数据、`REVIEW.md` 的安全边界与恢复约束 | 提炼为通用只读审查技能，去除课程、练习及项目协议细节；不是发现于原仓库的独立同名技能。 |
| `yushen-product-ux` | 用户自有 `skills/yushen-product-ux/SKILL.md` 和 `references/sources.md` 原件 | 恢复原技能，补入明确要求的复用、单一入口、统一样式、相邻操作、模型选择位置及稳定底边与内部滚动；依据移至本文件，移除默认读取要求和星数。 |
| `yushen-release-acceptance` | 用户自有同名技能原件 | 保留最终版本与哈希、实际下载和安装、测试分层、平台分别验证、预览限制及反例；统一截图的 PR 附件位置。 |

另核对了云端工作区中已获授权的代码质量技能和开发规则；未分发私有项目的源码、规则原文、仓库地址或专有实现约束。许可混合或不明的项目内容未转为 MIT。

## 外部方法与许可

代码质量技能原文件已注明以下方法借鉴；对应完整 MIT 版权与许可原文均保留在 [THIRD_PARTY_NOTICES.txt](THIRD_PARTY_NOTICES.txt)，根 MIT 不替代它们。

- [Addy Osmani / code-review-and-quality](https://github.com/addyosmani/agent-skills/blob/main/skills/code-review-and-quality/SKILL.md)：复用现有能力、多维检查、必要修改与建议分开、测试证据。未采用自动修改或强制清理历史债务等行为。版权为 `Copyright (c) 2025 Addy Osmani`。
- [Thomas Ricouard / review-and-simplify-changes](https://github.com/Dimillian/Skills/blob/main/review-and-simplify-changes/SKILL.md)：复用、质量、效率、清晰度视角，只读审查与去重；未移植自动修复模式或强制四代理并发。版权为 `Copyright (c) 2026 Thomas Ricouard`。

源技能的计数公式、50 token / 10 行初筛阈值与执行细则含助手补充，需实际校准，不是行业合格标准，也不宣称用户独创。方法文档仅作参考：[Rust dead_code](https://doc.rust-lang.org/stable/nightly-rustc/rustc_lint/builtin/static.DEAD_CODE.html)、[Knip 误报处理](https://knip.dev/guides/handling-issues)、[PMD CPD](https://github.com/pmd/pmd/blob/main/docs/pages/pmd/userdocs/cpd/cpd.md)。

安全技能的专项参考仅链接 OWASP 官方文档，未复制或打包其原文；执行时按需查阅，不把这些文档改标 MIT。外部链接可能变化，后续更新需重新核验。

## 产品设计依据与边界

用户自有原件将以下资料视为设计启发，不主张“最少点击”是普适实验定律。本集合没有复制这些第三方资料的原文；来源标题保留为检索线索，未转交的原始链接不臆造。

| 资料 | 采用的逻辑 | 边界 |
| --- | --- | --- |
| Tim Harford：Explain it to me like I’m ten | 为经验不同的人设计，识别专家忽略的门槛。 | 评论与案例，不代表用户缺乏能力。 |
| NN/G：Recognition and Recall | 提供可识别信息，减少技术细节的记忆负担。 | 不要求把所有信息同时铺满界面。 |
| W3C WAI：Make Each Step Clear | 多步流程交代位置、操作与下一步。 | 不能据此宣布符合全部无障碍标准。 |
| NN/G：User Control and Freedom | 提供退出、返回与适当撤销。 | 外部不可逆动作仍需事前防护。 |

完整目标路径是用户明确要求；操作数、决策数、等待与恢复成本是原技能的验收细化，不是上述文章原话。新资料应核对原始出处与反例，区分观点、经验和研究证据；AI 写作本身不判真伪，以可追溯证据和有效论证为准。

原件还参考过 Impeccable、UI UX Pro Max、Anthropic frontend-design 和 Vercel web-design-guidelines 的结构及原则；没有导入、执行或复制这些项目内容，不将其第三方文本改标 MIT，也不沿用未经重新核实的星数。它们只能补充界面检查，不能代替完整任务验证。

## 未包含项

- 除已取得并完成权利及敏感信息核查的原件外，其他备份内容不纳入当前版本；不臆造技能清单或正文。
- `learning-explore`、`learning-review`、`learning-exercises` 等通用学习技能、学习站程序、运行时及第三方代码均未纳入。
- 本地项目中其他第三方技能和所属项目的 AGPL 代码、项目专有规则原文均未纳入，未将它们重新许可为 MIT。
- 私有项目代码、凭据、部署地址、未授权个人信息、内部助手系统指令和隐藏笔记均不属于本集合。

源文件与许可核验日期：2026-10-18。根 [LICENSE](LICENSE) 仅覆盖本集合自有内容；复制或分发技能时应同时携带完整的许可与第三方声明。

## 2026-10-18：文档与流程图技能

用户提供以下三个 ZIP，并明确本批仍按 MIT 公开。实际解包共 11 个文件，未附独立 LICENSE 或必须保留的文件级版权头；不依据文件名推断作者或许可。保留原件的有用检查表、模板、脚本与评估数据，排除 `__MACOSX` 和资源分叉；未收集其他技能。

| 本集合 | 用户提供的原件 | 本次适配 |
| --- | --- | --- |
| `doc-refine` | `doc-refine.zip`（2 文件） | 区分审阅与授权改写；保护行为契约、警告、无障碍、有效示例及链接；句长、被动语态等仅作建议；移除不存在的必需技能依赖。 |
| `latex-pdf` | `latex-pdf.zip`（7 文件） | 收窄到明确的 LaTeX 排版需要；先审阅再按需检测环境；安装按实际授权；不可信输入隔离、默认禁 shell-escape；区分日志、编译与实际页面检查。 |
| `editable-flowchart` | `lark-editable-flowchart-v2.zip`（2 文件） | 从 `lark-editable-flowchart` 改名；默认本地可编辑 SVG，尊重指定格式；原有飞书命令、发布验证与平台样式合并至按需读取的 `references/lark-publishing.md`。 |

原件中的方法背景包括 Strunk & White、Google/Microsoft 写作指南、Diátaxis、Tufte、Write the Docs、John Carroll、Mark Baker，以及句长、记忆与认知负荷方面的经验。它们仅是参考线索，不宣称文章、书籍或通用方法归 YuShen 原创或均采用 MIT；没有把这些外部作品打包分发。原件的数字阈值、认知容量归因和绝对化排版规则不作为行业标准或已验证研究结论沿用。

写作方法可按需查 [Google 文档风格指南](https://developers.google.com/style)、[Microsoft 写作风格指南](https://learn.microsoft.com/en-us/style-guide/welcome/)、[Diátaxis](https://diataxis.fr/) 和 [Write the Docs 原则](https://www.writethedocs.org/guide/writing/docs-principles/)。本次核对了 [hyperref 官方手册](https://tug.ctan.org/macros/latex/contrib/hyperref/doc/hyperref-doc.html) 的加载顺序与 tabularx 链接脚注限制；删除了“换顺序即可修复”的无证据断言。编译选项以当前安装的 latexmk 帮助为依据；[latexmk](https://ctan.org/pkg/latexmk)、[minted](https://ctan.org/pkg/minted) 等外部工具及其手册保留各自许可，本仓库不重新许可它们。

本批静态审阅与合成样例不能证明所有字体、引擎、编辑器或飞书版本兼容；真实外部服务结果以对应任务的实际授权与回执为准。
