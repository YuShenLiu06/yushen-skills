# LaTeX 常见坑

> 每条按"症状 → 原因 → 解决"格式，覆盖最高频的 LaTeX 问题。

## 目录
1. [编码与字符](#编码与字符)
2. [编译错误 Top 10](#编译错误-top-10)
3. [浮动体](#浮动体)
4. [表格](#表格)
5. [数学](#数学)
6. [字体](#字体)
7. [交叉引用](#交叉引用)
8. [PDF 输出问题](#pdf-输出问题)

---

## 编码与字符

### 非 ASCII 字符在 pdflatex 下报错

**症状**：`! Package inputenc Error: Unicode character (U+xxxx) not set up for use with LaTeX.`

**原因**：pdfLaTeX 的字符支持取决于字体与映射。当前 LaTeX 默认 UTF-8 输入，不等于任意中文或 Unicode 符号都能直接排版；按实际字符和项目配置诊断。

**解决**：
```latex
% 方案 A：换 xelatex（推荐，一劳永逸）
% 编译命令改为 xelatex 即可

% 方案 B：坚持 pdflatex，声明编码
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
```

### 智能引号

**症状**：从 Word/网页复制的文本中 `""` `''` 显示为乱码或不正确。

**解决**：
```latex
% 在 LaTeX 中始终用以下写法
``word''    % 右双引号
`word'      % 右单引号

% 从外部复制时先清理智能引号
```

### 中文标点间距

**症状**：中文标点（，。、）前后有多余空格，或英文与中文混排时间距不均匀。

**解决**：
```latex
% ctex 包已自动处理中文标点间距
\usepackage[fontset=mac]{ctex}  % macOS

% xeCJK 可微调
\usepackage{xeCJK}
\setCJKmainfont{Songti SC}
\xeCJKsetup{CJKecglue={\hskip 0.15em plus 0.05em minus 0.05em}}  % 中英间距
```

---

## 编译错误 Top 10

### 1. Undefined control sequence

**症状**：`! Undefined control sequence. \somemacro`

**原因**：使用了未定义的命令——通常是包没加载、或拼写错误。

**解决**：
```latex
% 检查包是否加载
\usepackage{amsmath}  % 如果用了 \align 等

% 检查拼写：是 \textbf 不是 \texbf
```

### 2. Missing $ inserted

**症状**：`! Missing $ inserted.`

**原因**：在文本模式中使用了数学符号（如 `_`、`^`、`\alpha`）。

**解决**：
```latex
% ❌ 错误
The variable x_1 is important.

% ✅ 正确
The variable $x_1$ is important.
```

### 3. File not found

**症状**：`! LaTeX Error: File 'xxx' not found.`

**原因**：`\input` 或 `\includegraphics` 的文件路径不对。

**解决**：
```latex
% 使用相对路径，确保路径正确
\includegraphics{figures/diagram}  % 扩展名可省略

% 或指定图形搜索路径
\graphicspath{{figures/}{images/}}
```

### 4. Runaway argument

**症状**：`! Runaway argument? ...`

**原因**：括号或环境未正确闭合——通常漏了 `}` 或 `\end{...}`。

**解决**：检查报错位置附近的括号匹配。用编辑器的括号匹配功能排查。

### 5. 卡在交互模式

**症状**：编译停在 `?` 提示符，等待用户输入。

**原因**：遇到错误时 LaTeX 进入交互模式。

**解决**：
```bash
# 始终用 nonstopmode 编译
latexmk -norc -xelatex -latexoption=-no-shell-escape -interaction=nonstopmode -halt-on-error main.tex
# 或
xelatex -no-shell-escape -interaction=nonstopmode -halt-on-error main.tex
```

### 6. Option clash for package

**症状**：`! LaTeX Error: Option clash for package xxx`

**原因**：同一个包被加载了两次，且选项不同。

**解决**：
```latex
% 检查是否在多处 \usepackage 了同一个包
% 例如 documentclass 已经加载了某包，又在导言区重复加载

% 解决：统一选项，或删去重复加载
```

### 7. Too many }'s

**症状**：`! Too many }'s.`

**原因**：右括号 `}` 多于左括号 `{`。

**解决**：检查括号匹配。特别注意命令的可选参数 `[]` 和必选参数 `{}` 的嵌套。

### 8. Missing \begin{document}

**症状**：`! LaTeX Error: Missing \begin{document}.`

**原因**：导言区（`\begin{document}` 之前）中出现了正文内容。

**解决**：确保 `\begin{document}` 之前只有设置命令（`\usepackage`、`\setlength` 等），没有正文文字。

### 9. Float too large

**症状**：`! LaTeX Error: Float too large for page.`

**原因**：图片或表格的尺寸超过了页面。

**解决**：
```latex
% 缩小图片
\includegraphics[width=0.8\textwidth]{figure}

% 表格用 \resizebox
\resizebox{\textwidth}{!}{%
    \begin{tabular}{...}
    ...
    \end{tabular}%
}

% 或用 [p] 放置选项让它独占一页
\begin{figure}[p]
```

### 10. Dimension too large

**症状**：`! TeX capacity exceeded, sorry [input stack size=5000].` 或 `! Dimension too large.`

**原因**：通常是 pgfplots/tikz 的数据量过大，或无限循环。

**解决**：
```latex
% pgfplots: 限制数据点数量
\addplot+[mark=none, samples=200] {sin(x)};

% 外部化可能执行额外程序；只有隔离和执行授权均明确时才考虑
\usepgfplotslibrary{external}
\tikzexternalize
```

---

## 浮动体

### 图表跑到文档末尾

**症状**：图片或表格堆积在文档最后几页。

**原因**：LaTeX 浮动体算法认为当前位置放不下，不断推迟。

**解决**：
```latex
% 1. 用宽松的放置选项
\begin{figure}[htbp]  % here, top, bottom, page

% 2. 在章节末尾强制清空浮动队列
\clearpage    % 清空所有浮动体并开始新页
\FloatBarrier % 需 \usepackage{placeins}，浮动体不超过此点

% 3. 调整浮动体参数
\renewcommand{\topfraction}{0.9}    % 页面顶部最多 90% 放浮动体
\renewcommand{\bottomfraction}{0.9}
\renewcommand{\textfraction}{0.07}  % 每页至少 7% 正文
\setcounter{totalnumber}{3}         % 每页最多 3 个浮动体
```

### subfigure 弃用

**症状**：使用 `subfigure` 包时警告或错误。

**解决**：`subfigure` 已废弃，改用 `subcaption`：

```latex
\usepackage{subcaption}

\begin{figure}
    \begin{subfigure}{0.5\textwidth}
        \includegraphics{fig1}
        \caption{子图 A}
    \end{subfigure}
    \begin{subfigure}{0.5\textwidth}
        \includegraphics{fig2}
        \caption{子图 B}
    \end{subfigure}
    \caption{总标题}
\end{figure}
```

---

## 表格

### 列宽溢出

**症状**：表格超出页面右边界。

**解决**：
```latex
% 方案 A：tabularx 自动调整列宽
\usepackage{tabularx}
\begin{tabularx}{\textwidth}{l X}  % X 列自动伸缩
    标题 & 长文本内容自动换行...
\end{tabularx}

% 方案 B：固定列宽
\begin{tabular}{p{3cm} p{8cm}}

% 方案 C：整体缩放
\resizebox{\textwidth}{!}{%
    \begin{tabular}{...}
    ...
    \end{tabular}%
}
```

### 跨页表格

**症状**：长表格在页面底部被截断。

**解决**：
```latex
\usepackage{longtable}
\begin{longtable}{lrr}
    \toprule
    \textbf{指标} & \textbf{2024} & \textbf{2025} \\
    \midrule
    \endfirsthead  % 第一页表头

    \multicolumn{3}{l}{\small\itshape 接上页...} \\
    \toprule
    \textbf{指标} & \textbf{2024} & \textbf{2025} \\
    \midrule
    \endhead  % 后续页表头

    数据行 & ... & ... \\
    \bottomrule
\end{longtable}
```

---

## 数学

### 行内公式间距不对

**症状**：行内公式和周围文字间距过紧或过松。

**解决**：
```latex
% 用 $...$ 而非 $$...$$（后者已过时）
The value is $x = 42$.

% 复杂公式用行间
\begin{equation}
    f(x) = \int_0^x g(t) \, \mathrm{d}t
    \label{eq:fundamental}
\end{equation}

% \, 是细空格，用于微分符号前
```

### 多行公式对齐

```latex
\begin{align}
    a &= b + c \label{eq:1} \\
    d &= e + f \label{eq:2}
\end{align}

% 不想编号某行用 \notag 或 \nonumber
% 全部不编号用 align*
```

---

## 字体

### 系统字体找不到

**症状**：`! fontspec error: "font-not-found"`

**解决**：
```bash
# 1. 确认字体确实存在
fc-list | grep -i "字体名"

# 2. 字体名要用 family name，不是文件名
# ❌ \setmainfont{times.ttf}
# ✅ \setmainfont{Times New Roman}

# 3. 如果存在但找不到，刷新缓存
fc-cache -fv
```

### CJK 字体不生效

**解决**：
```latex
% ctex 的 fontset 自动选择可能不准——手动指定
\usepackage[fontset=mac]{ctex}      % macOS
\usepackage[fontset=windows]{ctex}  % Windows

% 或用 xeCJK 手动设置
\usepackage{xeCJK}
\setCJKmainfont{Songti SC}          % 也可用 PingFang SC
\setCJKsansfont{PingFang SC}
\setCJKmonofont{STKaiti}
```

---

## 交叉引用

### 引用显示为 ??

**症状**：`\ref{fig:example}` 输出 `??`。

**原因**：需要编译两遍才能解析交叉引用。

**解决**：
```bash
# 用 latexmk 自动处理（推荐）
latexmk -norc -xelatex -latexoption=-no-shell-escape -interaction=nonstopmode -halt-on-error main.tex

# 或手动多编译几遍
# 若不用 latexmk：按实际引用需求逐次运行已审阅的引擎/后端，默认 -no-shell-escape
```

### cleveref 不生效

**症状**：用了 `\cref` 但输出格式不正确。

**原因**：`cleveref` 必须在 `hyperref` **之后**加载。

```latex
\usepackage{hyperref}    % 先加载
\usepackage{cleveref}    % 后加载（cleveref 需要修补 hyperref 的输出）
```

---

## PDF 输出问题

### 书签（PDF outline）乱码

**症状**：PDF 阅读器中的书签显示为乱码，但正文正常。

**原因**：中文书签需要特殊处理。

**解决**：
```latex
% ctex 已自动处理，但确保用 xelatex 编译
\usepackage[fontset=mac]{ctex}

% 如果仍有问题，手动设置 bookmark 编码
\usepackage{bookmark}  % 替代 hyperref 默认的书签功能
```

### PDF 文件过大

**解决**：
```bash
# 用 Ghostscript 压缩
gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook \
   -o output.pdf input.pdf

# 或在 LaTeX 中控制图片质量
% 用 PDF 矢量图替代 PNG 位图
% pgfplots/tikz 原生编译比包含外部 PDF 更小
```
