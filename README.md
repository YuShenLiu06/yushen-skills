# yushen-skills

按 YuShen 的工作习惯整理的多领域 skill 集合：复用已有能力，让用户沿最短路径完成完整目标，以真实证据交付。

| Skill | 用途 |
| --- | --- |
| [yushen-code-quality-review](skills/yushen-code-quality-review/SKILL.md) | CR：检查功能证据、死代码、重复实现和可复用方案；外部替代方案只提建议。 |
| [yushen-security-review](skills/yushen-security-review/SKILL.md) | 独立检查权限、资源隔离、不可信输入、数据与恢复边界。 |
| [yushen-pr-cycle](skills/yushen-pr-cycle/SKILL.md) | 从需求确认到并行开发、自证、最多三轮审查、组合验证和本人验收。 |
| [yushen-product-ux](skills/yushen-product-ux/SKILL.md) | 缩短首次使用到日常操作的完整目标路径；高复用、统一入口和样式、相邻操作、稳定布局与合理默认值。 |
| [yushen-release-acceptance](skills/yushen-release-acceptance/SKILL.md) | 从真实下载、安装、启动到核心目标验收最终产物，明确平台差异、测试层级与预览限制。 |

将需要的 skill 目录放到工具支持的技能目录（例如项目的 `.agents/skills/`），保留其 `references/`。不支持自动发现时，明确要求助手读取对应 `SKILL.md`；仅放置文件或写一个链接不等于已加载。无需一次加载全部技能。

复制或分发时一并携带本仓库的 `LICENSE` 和 `THIRD_PARTY_NOTICES.txt`。技能仅约定流程，不授予工具、费用、合并或部署权限。

自有内容采用 [MIT](LICENSE)。外部借鉴、实际源文件和整理边界见 [致谢](ACKNOWLEDGEMENTS.md)，第三方完整版权与许可见 [THIRD_PARTY_NOTICES.txt](THIRD_PARTY_NOTICES.txt)。不将通用学习技能或第三方方法宣称为 YuShen 原创。
