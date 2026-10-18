---
name: latex-pdf
description: 在用户明确选择 LaTeX，或任务确需公式、参考文献等 LaTeX 排版能力时，创建、修复和检查 .tex 与 PDF。涵盖引擎、包兼容、环境诊断和实际页面验收；普通文档、幻灯片或一般 PDF 导出不自动改用 LaTeX。
---

# latex-pdf — 专业 LaTeX PDF 排版指南

> 目标不是"能编译"，而是读者拿起 PDF 就觉得专业。
> 交付以内容与实际页面为准；编译成功只证明编译完成，不能替代视觉验收。

## 目录
1. [核心理念](#核心理念)
2. [引擎选择](#引擎选择)
3. [编译策略](#编译策略)
4. [可读性排版原则](#可读性排版原则)
5. [工作流](#工作流)
6. [坑速查](#坑速查)

---

## 核心理念

排版遵循两个检查目标，不依赖另一个技能才能运行：

**① 排版服务于阅读** — 每个排版决策都回答"这帮读者更好地理解了吗"。
如果删掉一个设置后阅读体验不变，那它不需要存在。

**② 克制即专业** — 删掉所有不传递信息的视觉元素。
装饰性线条、底纹、彩色框——大部分该删。专业的排版"看起来毫不费力"，
而业余的排版往往"看起来很努力但很乱"。

详细的可读性原则映射见 [readability-principles](references/readability-principles.md)。

---

## 引擎选择

选错引擎是最常见的错误，尤其是中文内容用 pdflatex。

```
有中文/日文/韩文？
├─ 是 → xelatex（+ ctex 包）
│        （lualatex 也行，但编译更慢）
└─ 否 → 需要系统字体？
         ├─ 是 → xelatex 或 lualatex（+ fontspec）
         └─ 否 → pdflatex（最快、最兼容）
```

新建 CJK 文档优先 XeLaTeX 或 LuaLaTeX，并核对实际字体支持。已有可用的 pdfLaTeX/CJK 模板不应无故替换；`fandol` 不适用于普通 pdfLaTeX 路径。

| 引擎 | 优势 | 劣势 | 适用场景 |
|------|------|------|---------|
| `pdflatex` | 最快、最稳定、生态最广 | 不支持 Unicode 原生、不能用系统字体 | 纯英文文档 |
| `xelatex` | 原生 Unicode、系统字体、CJK 友好 | 较慢 | **中文文档默认选择** |
| `lualatex` | 最强大的字体处理、可嵌入 Lua | 最慢 | 需要高级排版功能 |

---

## 编译策略

### 先检查来源与执行边界

编译前静态检查 `.tex`、被引入的 `.sty`/`.cls`、构建配置及附件路径，留意文件读写、外部命令和 Lua 等执行能力。静态检查不等于安全证明。对不可信项目，使用无私有文件、无网络且限制写入、运行时间和资源的隔离环境；没有合适隔离时停止编译并报告，不在个人环境试跑。

默认禁用 shell-escape，不为了 `minted` 或图形外部化自动放开。运行 latexmk 时用 `-norc` 避免自动加载系统、用户或项目 rc；其他构建脚本和外部辅助程序另行审阅。安装、联网取包或修改环境须在已有授权内；未覆盖时先取得批准。

### 复用适合的编译链

已有项目沿用适用的构建方式；需要自动处理多遍编译与参考文献时可用 `latexmk`。以下示例只针对已检查的输入，在允许的工作目录运行：

```bash
# xelatex 文档（中文默认）
latexmk -norc -xelatex -latexoption=-no-shell-escape -interaction=nonstopmode -halt-on-error main.tex

# pdflatex 文档
latexmk -norc -pdf -latexoption=-no-shell-escape -interaction=nonstopmode -halt-on-error main.tex

# 清理辅助文件
latexmk -norc -c
```

**参数说明**：
- `-interaction=nonstopmode`：遇错不暂停等待输入（脚本环境必需）
- `-halt-on-error`：第一个错误就停止，方便定位问题

### biber（参考文献）

需要参考文献时，核对 latexmk 计划调用的 biber/BibTeX 与输入，允许后再运行；不要把自动检测当作额外执行权限。

---

## 可读性排版原则

以下是核心原则摘要，详细映射和代码示例见 [readability-principles](references/readability-principles.md)。

### 页面几何

目标每行 **50-75 字符**（66 为理想值，TeX 默认恰好）。

```latex
\usepackage{geometry}
\geometry{a4paper, margin=2.5cm}
% 中文每字符约为英文 2 倍宽，35 中文字/行 ≈ 70 英文字符/行
```

### 表格

常规数据表优先 `booktabs` 的无竖线样式；用户、期刊或机构模板另有要求时保留其规范：

```latex
\usepackage{booktabs}
\begin{tabular}{lrr}
    \toprule
    指标 & 2024 & 2025 \\
    \midrule
    营收 & 120 & 150 \\
    \bottomrule
\end{tabular}
```

booktabs 设计前提就是无竖线——有竖线时横线间距会断裂，这不是 bug 是 feature。

### 间距系统

段落分隔二选一，**不要混用**：

```latex
% 方案 A：首行缩进（学术文档、ctex 默认）
\setlength{\parindent}{2em}

% 方案 B：段间距（技术文档、报告）
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5\baselineskip}
```

### 字体

正文用衬线（阅读舒适），代码用等宽。xelatex/lualatex 用 fontspec 设置系统字体：

```latex
\usepackage{fontspec}
\setmainfont{TeX Gyre Termes}[Ligatures=TeX]
\setmonofont{TeX Gyre Cursor}
```

### microtype

几乎免费的质量提升——字距微调让正文更整齐：

```latex
\usepackage{microtype}
% 注意：xelatex 下只有 protrusion（无 font expansion），但仍值得加载
```

### 孤行/寡行

防止段落首行或尾行单独出现在页面边界：

```latex
\widowpenalty=10000
\clubpenalty=10000
```

### 代码高亮

默认用 `listings`（无外部依赖）。`minted` 质量更高但需要 Python + Pygments/latexminted：

```latex
\usepackage{listings}
\usepackage{xcolor}

\lstset{
    basicstyle=\ttfamily\small,
    keywordstyle=\color{blue!70!black},
    commentstyle=\color{gray},
    stringstyle=\color{green!50!black},
    numbers=left,
    numberstyle=\tiny\color{gray},
    frame=none,
    breaklines=true,
    showstringspaces=false,
}
```

---

## 工作流

面向第一次使用此工作流的人。

### Step 0: 环境检测

仅在需要本机编译且现有工具信息不足时检测。先读取 [检测脚本](scripts/check_latex_env.sh)，确认其调用的是可信 PATH 程序且符合现有权限；它只报告，不安装或修改设置。

从本次实际读取的 `SKILL.md` 的绝对父目录解析 `skill_root`，不要假设当前工作目录是技能目录，再运行：

```bash
bash "$skill_root/scripts/check_latex_env.sh"
```

缺失组件与探测失败分开报告。只安装任务实际需要且已获授权的依赖；无授权时给出缺口或已有替代。详细步骤按需读 [环境检测指南](references/environment-check.md)。

### Step 1: 理解需求

确认：
- **文档类型**：论文 / 报告 / 简历 / 幻灯片 / 通用
- **语言**：中文 / 英文 / 混排
- **读者**：学术 / 商业 / 技术 / 大众
- **特殊需求**：参考文献 / 代码块 / 数学公式 / 数据图表

### Step 2: 引擎选择

按上面的引擎选择决策树确定。中文 → xelatex 是最常见选择。

### Step 3: 生成 .tex

应用可读性排版原则，遵循 [package-guide](references/package-guide.md) 的标准加载顺序模板。

### Step 4: 编译

```bash
latexmk -norc -xelatex -latexoption=-no-shell-escape -interaction=nonstopmode -halt-on-error main.tex
```

### Step 5: 检查日志

打开 `main.log`，搜索 `Warning` 和 `Overfull`/`Underfull`：

- **Overfull hbox** → 定位溢出的文本、公式或列宽，检查实际页面并局部修复；不以全局 `\sloppy` 掩盖问题
- **Underfull hbox** → 行太松，通常无害
- **Font shape warning** → 字体形状不可用，检查 fontspec 设置
- **Undefined references** → 需要再编译一遍（latexmk 应已自动处理）

修复影响交付的警告，例如缺字、未解析引用和可见溢出；无害或受模板约束的警告说明理由，不强求所有 warning 为零。

### Step 6: 实际页面检查与交付

渲染或打开实际 PDF，检查页数、缺字、裁切、表格/公式/代码、链接、书签及相关无障碍要求；按需检查字体嵌入与可复制文字。修复后重新编译并复查受影响页面。无法渲染时明确标记“视觉未验证”，不把编译成功写成页面验收通过。

输出实际生成并核对的文件：
1. **PDF** — 最终交付物
2. **.tex 源文件与所需本地资源** — 保留可复现的入口、实际命令、编译结果和未验证项。

`evals/evals.json` 是评估用数据，不是运行指令；仅在测试本技能时读取。

---

## 坑速查

遇到问题时，按类型查阅：

| 问题类型 | 查阅文件 | 常见症状 |
|---------|---------|---------|
| 编译错误 | [common-pitfalls](references/common-pitfalls.md) §编译错误 Top 10 | `Undefined control sequence`、`Missing $`、卡住 |
| 编码/字符 | [common-pitfalls](references/common-pitfalls.md) §编码与字符 | 非 ASCII 报错、智能引号、中文标点间距 |
| 浮动体 | [common-pitfalls](references/common-pitfalls.md) §浮动体 | 图表跑到文档末尾 |
| 表格 | [common-pitfalls](references/common-pitfalls.md) §表格 | 列宽溢出、跨页 |
| 字体 | [common-pitfalls](references/common-pitfalls.md) §字体 | 系统字体找不到、CJK 不生效 |
| 包冲突 | [package-guide](references/package-guide.md) §包冲突矩阵 | Option clash、功能异常 |
| 加载顺序 | [package-guide](references/package-guide.md) §加载顺序规则 | 书签错乱、链接断裂 |
| 排版质量 | [readability-principles](references/readability-principles.md) | 文档看起来"业余" |
| 环境问题 | [environment-check](references/environment-check.md) | 命令找不到、权限错误 |
| ctex 字体 | [environment-check](references/environment-check.md) §常见环境问题 §6 | `fontset 'fandol' is unavailable` |

### 快速诊断清单

编译失败时按此顺序排查：

1. ✅ 用了正确的引擎？（中文 → xelatex）
2. ✅ 用了 `latexmk`？（自动处理多遍编译和 biber）
3. ✅ 用了 `-interaction=nonstopmode`？（不会卡在交互模式）
4. ✅ 包加载顺序符合当前文档类及包的实际约束？（通常 hyperref 靠后，cleveref 随后）
5. ✅ 所有 `\begin{...}` 都有对应的 `\end{...}`？
6. ✅ 所有 `{` 都有对应的 `}`？
7. ✅ 图片路径正确？（`\graphicspath` 设置搜索路径）
8. ✅ 包都装了？（`kpsewhich <pkg>.sty` 检查）
9. ✅ 中文文档用了 ctex 且指定了正确的 `fontset`？
10. ✅ 查看日志末尾——LaTeX 的错误信息通常指向真正的问题行
