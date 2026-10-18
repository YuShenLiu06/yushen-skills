# 包选择与包引用坑

> 功能 → 推荐包 → 注意事项 → 已知冲突。

## 目录
1. [包选择速查表](#包选择速查表)
2. [关键包使用指南](#关键包使用指南)
3. [包冲突矩阵](#包冲突矩阵)
4. [加载顺序规则](#加载顺序规则)

---

## 包选择速查表

| 功能 | 推荐包 | 备选 | 关键注意 |
|------|--------|------|---------|
| 中文支持 | `ctex` | `xeCJK` | ctex 自动处理标点间距，推荐首选 |
| 系统字体 | `fontspec` | — | 仅 xelatex/lualatex |
| 页面布局 | `geometry` | — | — |
| 超链接 | `hyperref` | — | 通常靠后，按文档类与相关包核对例外 |
| 图表 | `graphicx` | — | — |
| 数学 | `amsmath` + `amssymb` | — | — |
| 物理单位 | `siunitx` | — | `\SI{9.8}{\meter/\second^2}` |
| 专业表格 | `booktabs` | — | 常规数据表优先无竖线，已有格式规范优先 |
| 宽表格 | `tabularx` | — | 核对列宽与表格脚注限制，不靠换加载顺序保证链接 |
| 跨页表格 | `longtable` | `xltabular` | — |
| 列表 | `enumitem` | — | `\setlist{nosep}` 紧凑模式 |
| 代码高亮 | `listings` | `minted` | listings 无外部依赖，**推荐默认** |
| 彩色框 | `tcolorbox` | `mdframed` | tcolorbox 功能更全 |
| 页眉页脚 | `fancyhdr` | — | — |
| 微排版 | `microtype` | — | 几乎必装 |
| 交叉引用 | `cleveref` | `fancyref` | 在 hyperref **之后** |
| 颜色 | `xcolor` | — | 在 hyperref **之前** |
| 标题格式 | `titlesec` | — | 注意与某些文档类冲突 |
| 图表标题 | `caption` | — | — |
| 子图 | `subcaption` | — | `subfigure` 已废弃 |
| 多语言 | `polyglossia` | `babel` | xelatex/lualatex 用 polyglossia |
| 参考文献 | `biblatex` + `biber` | `natbib` + `bibtex` | biblatex 更现代 |

---

## 关键包使用指南

### ctex — 中文支持

```latex
\usepackage[fontset=mac]{ctex}       % macOS
\usepackage[fontset=windows]{ctex}   % Windows
\usepackage[fontset=ubuntu]{ctex}    % Ubuntu Linux
\usepackage[fontset=fandol]{ctex}    % 跨平台（需 xelatex/lualatex）
```

**坑**：
- `fandol` 字体集**不支持 pdflatex**——必须用 xelatex/lualatex
- 自动探测（不指定 `fontset`）可能在非标准系统上出错——建议手动指定
- 完整可选值：`adobe|fandol|founder|mac|macnew|macold|ubuntu|windows|none`

### hyperref — 超链接与 PDF 元数据

```latex
\usepackage{hyperref}  % 通常靠后；相关包的顺序约束另行核对

\hypersetup{
    colorlinks=true,
    linkcolor=blue!70!black,    % 内部链接
    urlcolor=blue!70!black,     % 外部链接
    citecolor=green!50!black,   % 引用链接
    pdfauthor={作者名},
    pdftitle={文档标题},
}
```

**坑**：
- 通常在大多数包之后加载；具体例外以所用版本与文档类说明为准。
- `cleveref` 等相关包按其约束随后加载。
- 当前 hyperref 手册明确列有 tabularx 内链接脚注限制，不能声称移到 hyperref 后即可修复。

### microtype — 微排版

```latex
\usepackage{microtype}  % 几乎免费的质量提升
```

**引擎兼容性提示**（按安装版本核对，不宣称在所有环境实测）：
- 字符突出 (protrusion)：pdfTeX ✅、LuaTeX ✅、**XeTeX ✅**
- 字体扩展 (expansion)：pdfTeX ✅、LuaTeX ✅、**XeTeX ❌**

**坑**：在 verbatim 环境中应禁用：
```latex
\usepackage{etoolbox}
\AtBeginEnvironment{verbatim}{\microtypesetup{activate=false}}
```

### minted vs listings — 代码高亮

| 特性 | `listings` | `minted` |
|------|-----------|----------|
| 外部依赖 | 无 | Python + Pygments/latexminted |
| 外部执行 | 不需要 | 取决于版本与受限执行配置；默认禁用时优先 listings |
| 语法支持 | ~100+ 语言 | ~600+ 语言（Pygments 支持的） |
| 排版质量 | 好 | 更精细 |
| 编译速度 | 快 | 较慢 |
| 推荐度 | **默认推荐** | 已确认 Python 环境可用时 |

**minted 的执行边界**：新版可能使用受限 shell escape 调用 `latexminted`，这仍是外部程序执行，不能等同于完全禁用 shell escape。只有明确需要、版本兼容和执行/安装授权均已核实时才选用；否则用 `listings`。PATH 中存在助手程序不能证明项目已可用。

### fontspec — 系统字体（仅 xelatex/lualatex）

```latex
\usepackage{fontspec}
\setmainfont{TeX Gyre Termes}[Ligatures=TeX]
\setsansfont{TeX Gyre Heros}[Ligatures=TeX]
\setmonofont{TeX Gyre Cursor}
```

**坑**：
- **不要在 pdflatex 下加载**——会直接报错
- 字体名用 family name（如 `Times New Roman`），不用文件名（如 `times.ttf`）
- `[Ligatures=TeX]` 启用 TeX 标准连字（`---` → em-dash 等）

### geometry — 页面布局

```latex
\usepackage{geometry}
\geometry{a4paper, margin=2.5cm}
% 或精确控制
\geometry{
    a4paper,
    left=2.5cm, right=2.5cm,
    top=3cm, bottom=3cm,
    headheight=14pt,  % fancyhdr 需要
}
```

**坑**：通常在 `hyperref` **之前**加载（例外：使用 `mag≠1000` 时需在 hyperref 之后）。

### pgfplots — 数据图表

```latex
\usepackage{pgfplots}
\pgfplotsset{compat=1.18}  % 固定版本行为，避免升级后图表变形
```

**坑**：
- 编译慢——大量数据点时尤其明显
- 大型图先精简数据或预生成静态图；外部化可能需要额外执行权限，不作为默认编译修复
- `compat` 版本不设置 → 警告；设为 `newest` → 升级后可能变形

### tcolorbox — 彩色框

```latex
\usepackage{tcolorbox}
\tcbuselibrary{skins, breakable}

\begin{tcolorbox}[title=注意, colback=yellow!10, colframe=orange!50]
    重要内容...
\end{tcolorbox}
```

**坑**：
- 跨页内容需要 `\tcbuselibrary{breakable}`
- 可能需要多次编译才能稳定（浮动位置、颜色计算）

---

## 包冲突矩阵

| 冲突 | 症状 | 解决 |
|------|------|------|
| `inputenc`+`fontenc` vs `fontspec` | 编译错误 | 不要混用——xelatex/lualatex 只用 `fontspec`，pdflatex 只用 `inputenc`+`fontenc` |
| `subfigure`（废弃） | 警告或错误 | 改用 `subcaption` |
| `titlesec` + 某些文档类 | 标题格式异常 | 检查文档类文档，可能需要禁用 titlesec |
| `ulem` + `hyperref` | `\uline` 和超链接冲突 | 用 `soul` 包的 `\ul` 替代，或 `\usepackage[normalem]{ulem}` |
| `babel` vs `polyglossia` | 功能重叠 | xelatex/lualatex 用 `polyglossia`；pdflatex 用 `babel` |
| `subfig` vs `subcaption` | 功能重叠 | 统一用 `subcaption`（更现代，与 `caption` 集成更好） |
| `minitoc` 需在 hyperref 后 | minitoc 页码错误 | `\usepackage{hyperref}` 后再 `\usepackage{minitoc}` |

---

## 加载顺序规则

包顺序需要结合实际文档类与版本核对，不把历史经验当成所有组合的已验证规则。

- 通常把 `hyperref` 放在大多数包之后，再按 `cleveref` 等包的要求安排。
- 出现书签、锚点或脚注问题时，先做最小复现并查所用包手册，不盲目移动所有包。
- `tabularx` 内链接脚注存在限制；换加载顺序不保证修复。按需查 [hyperref 当前手册](https://tug.ctan.org/macros/latex/contrib/hyperref/doc/hyperref-doc.html)。

### 导言区起始模板（按实际依赖裁剪）

```latex
% ── 文档类 ──
\documentclass[11pt, a4paper]{ctexart}

% ── 基础设施 ──
\usepackage{geometry}      % 页面布局（在 hyperref 之前）
\usepackage{xcolor}        % 颜色（在 hyperref 之前）
\usepackage{graphicx}      % 图片
\usepackage{amsmath}       % 数学
\usepackage{amssymb}       % 数学符号
\usepackage{booktabs}      % 专业表格
\usepackage{enumitem}      % 列表控制

% ── 字体（xelatex/lualatex）──
\usepackage{fontspec}
% 先确认字体可用再启用；否则保留文档类默认字体
% \setmainfont{TeX Gyre Termes}

% ── 排版优化 ──
\usepackage{microtype}     % 微排版
\usepackage{caption}       % 图表标题
\usepackage{subcaption}    % 子图

% ── 代码 ──
\usepackage{listings}      % 或 minted（需确认环境）

% ── 功能包 ──
\usepackage{tcolorbox}     % 彩色框
\usepackage{fancyhdr}      % 页眉页脚
\usepackage{siunitx}       % 单位

% ── biblatex（如果有参考文献）──
% 只有存在 refs.bib 且确需参考文献时再启用
% \usepackage[backend=biber, style=numeric]{biblatex}
% \addbibresource{refs.bib}

% ── hyperref（倒数第二）──
\usepackage{hyperref}
\hypersetup{colorlinks=true, linkcolor=blue!70!black}

% ── cleveref（必须在 hyperref 之后）──
\usepackage{cleveref}

\begin{document}
```
