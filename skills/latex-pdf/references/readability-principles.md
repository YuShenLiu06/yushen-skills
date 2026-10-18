# 可读性排版原则

> 以下为可按文档类型调整的排版起点，不要求加载其他技能。
> 目标：让生成的 PDF 不仅"能编译"，而是读者一眼觉得专业。

## 目录
1. [排版公理](#排版公理)
2. [Tufte: Data-Ink Ratio → 表格去装饰](#tufte-data-ink-ratio)
3. [信息密度控制](#认知负荷)
4. [Progressive Disclosure → 分层结构](#progressive-disclosure)
5. [反 Chartjunk → 去除排版装饰](#反-chartjunk)
6. [一致性 > 创意](#一致性)
7. [孤行/寡行处理](#孤行寡行处理)
8. [微排版优化](#微排版优化)
9. [行长与页边距](#行长与页边距)
10. [段落视觉边界](#段落视觉边界)

---

## 排版公理

用两个检查目标判断排版：

| 公理 | 排版映射 | 判断标准 |
|------|---------|---------|
| **① 排版服务于阅读** | 每个排版决策回答"这帮读者更好地理解了吗" | 如果删掉这个设置，阅读体验不变 → 不需要 |
| **② 克制即专业** | 删掉所有不传递信息的视觉元素 | 装饰性线条、底纹、彩色框 → 大部分该删 |

---

## Tufte: Data-Ink Ratio

> "Above all else show the data." — Edward Tufte

核心思想：每一滴"墨水"都应该传递信息，装饰性墨水是噪音。

### 表格

**常规数据表优先 `booktabs` 无竖线样式；遵守用户或机构已有格式：**

```latex
% ✅ 专业
\usepackage{booktabs}
\begin{tabular}{lrr}
    \toprule
    指标 & 2024 & 2025 \\
    \midrule
    营收 & 120 & 150 \\
    利润 & 30  & 45  \\
    \bottomrule
\end{tabular}

% ❌ 业余
\begin{tabular}{|l|r|r|} \hline
    指标 & 2024 & 2025 \\ \hline
    营收 & 120 & 150 \\ \hline
```

booktabs 的设计前提就是无竖线——有竖线时 `\toprule`/`\midrule` 的间距会不连续。
这不是 bug，是 booktabs 在告诉你"别用竖线"。

**行间距用 `\addlinespace`，不用空行或 `\hline`：**

```latex
\midrule
营收 & 120 & 150 \\
利润 & 30  & 45  \\
\addlinespace    % 组间间距，比空行更精确
增长率 & 25\% & 50\% \\
\bottomrule
```

### 图表

- 删除 chartjunk：3D 柱状图、渐变色填充、多余网格线
- `\pgfplotsset{every axis/.append style={line width=0.8pt}}` — 线条统一
- 网格线用 `grid=major, grid style={dashed, gray!30}` — 微妙但可读

---

## 认知负荷

> 根据读者任务和实际页面控制密度；不把“7±2”当作通用认知容量定律或验收线。

### 行宽控制

英文行长可从约 50–75 字符试排，再按字体、字号、语言与页面检验；不是固定理想值，中文不能直接按英文字符数验收。

```latex
\usepackage{geometry}
% A4 纸，2.5cm 边距 → 约 70 字符/行（中文约 35 字/行）
\geometry{a4paper, margin=2.5cm}
% 或精确控制
\geometry{a4paper, textwidth=15cm, textheight=24cm}
```

**注意**：中文每字符宽度约为英文的 2 倍，中文 35 字/行 ≈ 英文 70 字符/行。

### 列表项数

- ≤7 项：列表合适
- 8-15 项：考虑分组或用表格
- 较长列表：考虑分组或拆分，不为项数删除必要信息

```latex
% 用 enumitem 精确控制列表间距
\usepackage{enumitem}
\setlist{nosep, leftmargin=1.5em}  % 紧凑模式
```

### 表格列数

- ≤6 列：可正常扫描
- 7-10 列：考虑转置或用 `\resizebox`
- >10 列：考虑拆分为多表或用附录

---

## Progressive Disclosure

> 最重要的信息在前，细节在后。读者按需深入。

### TOC 深度

```latex
\setcounter{tocdepth}{2}  % 目录只显示到 subsection，更深层级不显示
```

### 附录

```latex
\appendix  % 之后的内容编号变为 A, B, C...
\section{详细数据表}  % 次要内容放附录
```

### 摘要在前

```latex
\begin{abstract}
    % 200-300 字总结，读者决定是否继续读的关键
\end{abstract}
```

---

## 反 Chartjunk

> "Less is more." 去除所有不传递信息的视觉装饰。

### 颜色

颜色应该有语义意义，不是装饰：

```latex
% ✅ 语义色
\usepackage{xcolor}
\definecolor{linkblue}{HTML}{0066CC}
\definecolor{warnred}{HTML}{CC3300}
\hypersetup{colorlinks=true, urlcolor=linkblue, linkcolor=linkblue}

% 提示框仅在必要时使用
\usepackage{tcolorbox}
\begin{tcolorbox}[colback=yellow!10, colframe=orange!50, title=注意]
    仅用于真正的警告/重要信息。
\end{tcolorbox}

% ❌ 装饰色（避免）
\textcolor{purple}{每个关键词都上色}  % 噪音，不是信息
```

### 页眉页脚

保持简洁——`fancyhdr` 不要塞太多：

```latex
\usepackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\nouppercase{\leftmark}}  % 章节名
\fancyhead[R]{\thepage}                   % 页码
\renewcommand{\headrulewidth}{0.4pt}      % 细线就够

% ❌ 避免
% \fancyhead[C]{公司Logo}
% \fancyhead[L]{作者}
% \fancyhead[R]{日期}
% \fancyfoot[L]{版本号}
% \fancyfoot[C]{版权信息}
% \fancyfoot[R]{页码}
```

### 边框

```latex
% ❌ 避免
\fbox{不要给正文加框}

% 仅用于真正的强调
\usepackage{tcolorbox}
\begin{tcolorbox}
    正确用法：隔离重要信息
\end{tcolorbox}
```

---

## 一致性

> 专业感来自一致性，不是创意。字体、间距、编号的统一比任何单一技巧都重要。

### 字体族统一

```latex
\usepackage{fontspec}  % 仅 xelatex/lualatex
\setmainfont{TeX Gyre Termes}[      % 正文衬线
    Ligatures=TeX,
]
\setsansfont{TeX Gyre Heros}[       % 标题无衬线
    Ligatures=TeX,
]
\setmonofont{TeX Gyre Cursor}       % 代码等宽
```

### 图表标题格式

```latex
\usepackage{caption}
\captionsetup{
    font=small,
    labelfont=bf,
    labelsep=period,    % "Figure 1." 而非 "Figure 1:"
    justification=raggedright,
    skip=8pt,
}
```

### 引用格式统一

```latex
\usepackage{cleveref}  % 必须在 hyperref 之后
% 自动处理 \cref{fig:example} → "Figure 1"
% 比 \ref{fig:example} → "1" 更专业
```

---

## 孤行寡行处理

**孤行 (widow)**：段落最后一行出现在下一页顶部。
**寡行 (orphan)**：段落第一行留在上一页底部。

两者都影响阅读体验和专业感。

```latex
% 在导言区设置
\widowpenalty=10000   % 禁止 widow（段落尾行在下一页）
\clubpenalty=10000    % 禁止 orphan（段落首行在上一页）
\displaywidowpenalty=10000  % 对 display math 同样生效

% 备选方案：使用专门包
% \usepackage{nowidow}
```

**注意**：penalty=10000 是强力设置，可能导致大段空白。如果出现不合理的空白，
可以用 `\enlargethispage{2\baselineskip}` 在特定页面微调。

---

## 微排版优化

### microtype — 几乎免费的质量提升

```latex
\usepackage{microtype}
```

- **字符突出 (protrusion)**：标点等微突出到页边距，视觉上更整齐
  - 支持：pdfTeX ✅、LuaTeX ✅、XeTeX ✅
- **字体扩展 (expansion)**：微调字符宽度改善行间距
  - 支持：pdfTeX ✅、LuaTeX ✅、**XeTeX ❌**
- **结论**：xelatex 下仍有 protrusion 效果，值得加载
- **注意**：在 verbatim 环境中应禁用：
  ```latex
  \usepackage{etoolbox}
  \AtBeginEnvironment{verbatim}{\microtypesetup{activate=false}}
  ```

### 行距

```latex
\linespread{1.1}  % 默认 1.0 偏紧，1.1-1.3 更适合长文阅读
% 或更精确
\usepackage{setspace}
\setstretch{1.15}
```

### 段间距

LaTeX 默认用首行缩进区分段落，但中文文档常改用段间距：

```latex
% 方案 A：首行缩进（LaTeX 默认，学术文档推荐）
% 中文 ctex 默认缩进 2 字符，无需额外设置

% 方案 B：段间距（现代风格，技术文档推荐）
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5\baselineskip}

% ⚠️ 二选一，不要混用！
```

---

## 行长与页边距

### 快速设置参考

| 纸张 | 用途 | 推荐 margin | 约合字符/行 |
|------|------|------------|------------|
| A4 | 学术论文 | 2.5cm | ~70 (EN) / ~35 (ZH) |
| A4 | 技术报告 | 2.0-2.5cm | ~75 (EN) |
| A4 | 简历 | 1.5-2.0cm | ~85 (EN) |
| Letter | 美式文档 | 1in (2.54cm) | ~72 (EN) |

### 中文文档特殊考虑

中文每字符约为英文 2 倍宽，所以：
- 中文 35 字/行 ≈ 英文 70 字符/行
- `ctex` 默认设置已考虑这一点，通常不需要额外调整

```latex
% 中文文档典型设置
\documentclass[11pt, a4paper]{ctexart}
\usepackage{geometry}
\geometry{margin=2.5cm}
% ctexart 已优化中文间距和断行，无需手动调
```

---

## 段落视觉边界

段落是阅读的基本单元。读者靠视觉边界区分"新主题开始"和"同一主题延续"。

### 不要混用两种段落分隔方式

```latex
% 方案 A：首行缩进（学术文档、书籍）
% ctex 默认 2 字符缩进，标准 latex 默认 15pt
\setlength{\parindent}{2em}

% 方案 B：段间距（技术文档、报告、简历）
\setlength{\parindent}{0pt}
\setlength{\parskip}{0.5\baselineskip}

% 缩进和段间距通常择一作为主要分隔信号；模板已有组合时按实际页面判断
```

### 首段不缩进

如果用首行缩进，`section`/`subsection` 后的第一段不应缩进：

```latex
\usepackage{indentfirst}  % 但如果你想要首段也缩进，用这个
% 默认行为是 section 后首段不缩进（更专业）
```
