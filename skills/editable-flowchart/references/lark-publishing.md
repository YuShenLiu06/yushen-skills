# 飞书/Lark 发布（仅明确要求时）

本参考不适用于默认本地交付。以下命令与格式来自原件，属于按当前 CLI 帮助核对的操作示例，未代表在所有版本或真实账户实测。

## 发布门槛

- 先确认用户确实要求飞书，以及创建新文档还是更新已明确指定的对象；已有明确指令可沿用，不重复询问。
- 创建前核对目标位置/文档、执行身份及可见范围；不能确认或工具无法控制所需可见范围时，停止外部写入并说明。
- CLI 安装、持久配置、新增 OAuth 权限和文档/白板写入分别按授权处理，不藏在默认步骤中。缺少权限不使用其他身份绕过。
- 发布前检查本地源文件与实际渲染；保留源 SVG。上传后用实际回执、远端预览和 raw 节点检查结果，不以“上传成功”推断全部可编辑。
- 覆盖、删除或重建已有对象须有明确目标与对应授权；结果未知时先核对，避免重复创建。

## 原件保留的发布步骤

### 3. Check Lark CLI and authorization

Run health/auth checks without exposing credentials:

```bash
lark-cli --version
lark-cli doctor
lark-cli auth status --json
```

If configuration or authorization is missing/expired, report the specific gap. Do not automatically run `config init --new` or start OAuth. First obtain permission for the configuration change and any new persistent scopes; reuse an already-authorized, sufficient identity when available. After permission, inspect the current CLI help and official installed Lark auth workflow, request only the scopes actually needed, and let the user actively complete the official browser authorization. Never accept consent on their behalf, substitute bot identity, or ask them to paste a token.

Summarize identity validity and scope sufficiency without printing raw auth output, app secrets, tokens, device codes, or temporary auth logs. Authentication in progress is not authorization completed. Check the actual result after the user finishes; stop if the result is refused, expired, or unknown.

### 4. Create a document containing an SVG whiteboard

Read the command/reference first:

```bash
lark-cli docs +create --help
lark-cli skills read lark-doc/references/lark-doc-create-workflow.md
lark-cli skills read lark-whiteboard/references/lark-whiteboard-update.md
```

In a temporary working directory, copy the SVG to a short relative filename and create a DocxXML file that embeds it:

```xml
<p>××技术路线图（可编辑白板）</p>
<whiteboard type="svg" path="@./roadmap.svg"></whiteboard>
```

Use relative `@file` paths from the command’s current directory; Lark CLI rejects unsafe absolute file paths. Then create the document as the authorized user:

```bash
lark-cli docs +create --as user \
  --title "××技术路线图" \
  --content @./doc.xml
```

Save the returned document URL and whiteboard block token, but never save or report credentials. Do not use `--overwrite` on an existing board unless the user explicitly requested replacement and the target was identified.

### 5. Export and verify the remote board

Read export help, then export a preview with the matching extension (the preview endpoint commonly returns JPG):

```bash
lark-cli whiteboard +export --help
lark-cli whiteboard +export --as user \
  --whiteboard-token <board-token> \
  --output-type preview --output ./board_preview.jpg
lark-cli whiteboard +export --as user \
  --whiteboard-token <board-token> \
  --output-type raw > ./board_raw.json
```

Inspect the preview against the local screenshot. Parse the raw JSON and count node types. Report counts for at least `text_shape`, `composite_shape`, `connector`, and `image` when present. Text/shapes/connectors are evidence of editability; `image` nodes indicate SVG features that the parser rasterized. Do not describe image-backed arrows or decorative elements as individually recolorable/editable.

### 6. Deliver an evidence-based result

Return:

1. the Feishu document URL;
2. local SVG and screenshot paths;
3. remote preview path;
4. editability evidence (raw node counts and what those types mean);
5. visual verification result;
6. limitations, failed steps, or user action still required.

Only say “完成” when the local render and remote preview have both been checked. If a step failed, say exactly which step failed and do not imply that the document exists.

## Common failure modes

| Failure | Correct response |
|---|---|
| Auth/config missing | Stop before writes; explain the gap and obtain the relevant configuration/OAuth authorization before starting the official flow. |
| SVG uploaded as a single image | Treat as not meeting the editable requirement; use `<whiteboard type="svg">` and inspect raw nodes. |
| Preview export says extension mismatch | Use the response MIME extension (usually `.jpg`) or omit the extension. |
| Some SVG elements become images | Preserve the result, report the image count and affected class of elements; do not overclaim. |
| Local screenshot looks good but remote board is wrong | Diagnose and propose the smallest authorized correction; do not silently recreate a document or overwrite a board. Re-export after an authorized fix. |
| User asks to overwrite an existing board | Confirm the exact target and replacement intent before destructive update. |

## Quick checklist

- [ ] Content extracted and exact labels preserved
- [ ] SVG is self-contained and text remains `<text>`
- [ ] Chrome screenshot inspected before upload
- [ ] `doctor`/`auth status` checked
- [ ] User completed configuration and minimum scopes
- [ ] SVG embedded as a whiteboard, not PNG-only
- [ ] Remote preview and raw nodes exported
- [ ] Editable/image node counts reported
- [ ] No secrets or temporary auth artifacts in deliverables

## 可选研究路线风格

仅当用户明确选择原件的研究路线风格时，可组合薄蓝外框、圆角蓝标题、浅色目标条、分组面板、阶段条和正交连线；原件中的奶油色、粉色、藏蓝色、红箭头与中文衬线字是可选样式，不是流程图或飞书的通用要求。优先用户参考图、可读性和无障碍语义。

## 栅格化限制

`image` 节点只能证明该部分是图像，不能声称文字、箭头或装饰元素可独立改色。即使存在 `text_shape`、`composite_shape`、`connector`，也只报告已检查的元素类型与范围；保留混合结果时明确哪些部分仍需重新生成。
