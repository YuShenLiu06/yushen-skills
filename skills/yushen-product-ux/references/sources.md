# 依据与边界

2026-10-16 核对原始页面或官方仓库文件。以下是评论、设计启发和实践建议，不证明“点击越少越好”是普适定律。

| 来源 | 能导出的设计决定 | 边界 |
|---|---|---|
| [Tim Harford：Explain it to me like I’m ten](https://timharford.com/2026/08/explain-it-to-me-like-im-ten/) | 用经验或能力受限的情境暴露专家忽略的门槛 | 作者评论和案例；不把用户当作无能力的人，也不是最低点击数研究 |
| [NN/G：Recognition and Recall](https://www.nngroup.com/articles/recognition-and-recall/) | 显示可识别的信息，少让用户回忆技术细节 | 界面可用性建议，不要求信息全铺开，也不否定学习任务中的主动回忆 |
| [W3C WAI：Make Each Step Clear](https://www.w3.org/WAI/WCAG2/supplemental/patterns/o1p04-clear-steps/) | 显示已完成、当前、待做步骤和重要选择，便于中断后接续 | 补充无障碍建议；单用这一条不能声称符合全部 WCAG |
| [NN/G：User Control and Freedom](https://www.nngroup.com/articles/user-control-and-freedom/) | 给退出、返回及适当撤销，降低误操作成本 | 外部不可逆操作仍需事前防护，取消等待不等于撤销动作 |

用户明确要求最短完整目标路径。操作数、决策数、等待与恢复成本是本技能对该要求的验收细化，不是上述文章原话。

## 筛选新证据

- 先核对原始出处、实际论点、适用条件和反例，区分用户取舍、作者观点、经验建议与研究证据。
- 每项资料说明会改变哪个设计决定；没有具体用途就不收录。不收无出处金句、堆概念或不可验证的“法则”。
- Star 只帮助发现候选，不代表质量或普适效果；集合仓库关注度也不等于单个技能使用量。AI 写作本身不判真伪，可追溯证据和有效论证才是标准。

## 开源实现参考

只借鉴与当前问题有关的结构，不导入或执行项目；不复制随时间变化的 Star 数或未逐项复核的许可证声明。

| 官方项目／文件 | 可参考的部分与边界 |
|---|---|
| [Impeccable](https://github.com/pbakaus/impeccable) | 识别受众、目的、已有产品上下文，按任务审查；不因追求视觉风格增加负担 |
| [UI UX Pro Max](https://github.com/nextlevelbuilder/ui-ux-pro-max-skill) | 设计系统与实现检查的候选参考；先核对具体规则，不把推荐直接当成用户需求 |
| [Anthropic frontend-design](https://github.com/anthropics/skills/blob/main/skills/frontend-design/SKILL.md) | 用用户理解的词命名、清楚的动作与错误指引；视觉方向服从实际任务 |
| [Vercel Web Interface Guidelines](https://github.com/vercel-labs/web-interface-guidelines/blob/main/command.md) | 键盘、焦点、输入、异步状态和破坏性动作的实现检查；采用具体规则前再读当时版本 |

这些参考不能取代完整任务验证，也不新增工具调用权限。新增学习理论仍需用户审核认可。
