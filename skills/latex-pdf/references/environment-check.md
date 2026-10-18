# 环境检测指南（独立模块）

> 本文件独立于主 SKILL.md，专门指导如何检测目标机器的 LaTeX 编译环境。
> **面向通用用户**：不假设环境完备，覆盖"完全没装"到"部分安装"全光谱。

## 目录
1. [一键检测脚本](#一键检测脚本)
2. [手动检测命令](#手动检测命令)
3. [缺失组件安装指引](#缺失组件安装指引)
4. [常见环境问题](#常见环境问题)

---

## 一键检测脚本

先读取 [检测脚本](../scripts/check_latex_env.sh)，核对它调用的 PATH 程序与现有执行权限；只有实际需要环境诊断时才运行。脚本只报告，不自动安装或修改配置。

```bash
# skill_md 取本次技能加载返回的实际 SKILL.md 绝对路径
skill_md="/实际安装目录/latex-pdf/SKILL.md"
skill_root="$(dirname "$skill_md")"
bash "$skill_root/scripts/check_latex_env.sh"
```

脚本输出结构化报告，包含：
- 操作系统识别
- TeX 发行版检测（TeX Live / MiKTeX / MacTeX）
- 引擎可用性（pdflatex / xelatex / lualatex / latexmk）
- 关键包的批量检测（未发现与探测失败分别报告）
- CJK 字体检测
- minted 依赖检测（pygmentize / latexminted）
- shell-escape 设置
- 供后续判断的缺失项与限制

脚本不是所有任务的前置步骤。使用已有编译器或托管工具信息足够时，直接继续对应流程。工具存在也不代表项目已能编译。

---

## 手动检测命令

脚本不可用或需要逐项检查时，用以下命令。

### TeX 发行版

```bash
# TeX Live / MacTeX
tlmgr --version    # 存在 → TeX Live 或 MacTeX

# MiKTeX
mpm --version      # 存在 → MiKTeX

# 都没有
echo "需要安装 TeX 发行版"
```

### 引擎

```bash
for engine in pdflatex xelatex lualatex latexmk; do
    if command -v "$engine" &>/dev/null; then
        echo "✅ $engine"
    else
        echo "❌ $engine"
    fi
done
```

### 关键包

```bash
# 单个包
kpsewhich ctex.sty      # 有路径 → 已安装

# 批量检查
for pkg in ctex fontspec geometry hyperref booktabs listings microtype; do
    kpsewhich "${pkg}.sty" &>/dev/null && echo "✅ $pkg" || echo "❌ $pkg"
done
```

### CJK 字体

```bash
# Linux / macOS（需要 fontconfig）
fc-list :lang=zh family | sort -u

# Windows（PowerShell）
Get-ChildItem "C:\Windows\Fonts" -Filter "*sim*","*msyh*","*kai*","*ming*"
```

### minted 依赖

```bash
# minted v3+ (TeX Live 2024+)
which latexminted       # minted v3 专用可执行文件

# minted v2 及以下
which pygmentize        # Pygments Python 包

# 两个都没有 → minted 不可用，改用 listings
```

### shell-escape 设置

```bash
# TeX Live
kpsewhich -var-value shell_escape
# t/y = 完全启用
# p   = 受限模式（仅白名单命令，包含 latexminted）
# f/n = 禁用

# MiKTeX 同样默认禁用外部命令；不要为解决编译问题自动启用 write18
```

### biber（biblatex 后端）

```bash
which biber
biber --version
# 以下安装示例仍需已有授权；如果缺失且确实需要 biblatex：
# TeX Live: tlmgr install biber
# MiKTeX: 通常自带
```

---

## 缺失组件安装指引

以下为按需选择的示例，不是自动执行授权。先确认任务实际需要、下载来源、安装范围和已有授权；涉及 `sudo`、持久 PATH/配置、字体或包安装而未获授权时，取得明确批准后再做。权限错误不自动升级到管理员安装。版本和下载大小会变化，核对当前官方说明；本指南不保证表中的历史估算仍准确。

### 完整安装（从零开始）

| 平台 | 命令 | 大小 | 说明 |
|------|------|------|------|
| macOS | `brew install --cask mactex` | ~4GB | 完整 TeX Live，推荐 |
| macOS | `brew install --cask basictex` | ~100MB | 最小安装，后续按需 `tlmgr install` |
| Ubuntu/Debian | `sudo apt install texlive-full` | ~5GB | 完整安装 |
| Fedora | `sudo dnf install texlive-scheme-full` | ~5GB | 完整安装 |
| Arch | `sudo pacman -S texlive` | ~2GB | 较完整 |
| Windows | 下载 [MiKTeX](https://miktex.org/download) | 可变 | 按需安装，对新手友好 |
| Windows | 下载 [TeX Live](https://tug.org/texlive/) | ~4GB | 完整安装 |

### 安装单个包

```bash
# TeX Live / MacTeX
tlmgr install <package-name>

# 如果权限不足（用户安装）
tlmgr --usermode install <package-name>

# MiKTeX
mpm --install=<package-name>
# 或在 MiKTeX Console 中搜索安装
```

### 安装 Python 依赖（minted）

```bash
# minted v3+ (推荐)
pip3 install latexminted

# 或传统 Pygments
pip3 install Pygments

# 需要修改持久 PATH 时另行核实授权；不自动执行 sudo tlmgr path add
```

### 安装 CJK 字体

**macOS**：系统自带 PingFang SC、STSong、STKaiti 等，通常不需要额外安装。

**Linux**：
```bash
# Ubuntu/Debian
sudo apt install fonts-noto-cjk fonts-wqy-zenhei

# Fedora
sudo dnf install google-noto-sans-cjk-fonts
```

**Windows**：系统自带 SimSun、SimHei、Microsoft YaHei。

---

## 常见环境问题

### 1. PATH 未包含 TeX bin

**症状**：终端能找到 `pdflatex`，但 GUI 应用（VS Code、TeXstudio）报 "command not found"。

**原因**：macOS 的 TeX 安装在 `/Library/TeX/texbin`，GUI 应用的 PATH 可能不包含它。

**解决**：
```bash
# 确认 TeX bin 路径
echo $(dirname $(which pdflatex))

# 在 IDE 设置中手动指定 TeX 可执行文件路径
# VS Code + LaTeX Workshop: 设置 "latex-workshop.latex.tools" 中的路径
# TeXstudio: Preferences → Commands → 手动填路径
```

### 2. tlmgr 权限问题

**症状**：`tlmgr install` 报权限错误。

**解决**：
```bash
# 方案 A：用户模式安装（不需要 root）
tlmgr --usermode init-usertree
tlmgr --usermode install <package>

# 方案 B：系统级安装（需要 root）
sudo tlmgr install <package>
```

### 3. MiKTeX 自动安装卡住

**症状**：MiKTeX 首次编译时尝试自动安装缺失包，但非交互模式下卡住或超时。

**解决**：
- 在隔离编译中禁用自动联网取包，先报告缺失项。
- 已获安装授权时，只预装任务所需的包；不要默认开启持久自动安装。

### 4. fc-list 命令不存在

**症状**：在 Linux 上运行字体检测报错。

**原因**：缺少 `fontconfig` 包。

**解决**：
```bash
sudo apt install fontconfig  # Debian/Ubuntu
sudo dnf install fontconfig  # Fedora
```

### 5. xelatex 找不到系统字体

**症状**：`! fontspec error: "font-not-found"`，但 `fc-list` 能列出该字体。

**原因**：xelatex 的字体缓存未更新。

**解决**：
```bash
# 刷新字体缓存
luaotfload-tool --update       # lualatex 的字体缓存
fc-cache -fv                   # 系统字体缓存
# 或直接重启 xelatex
```

### 6. 中文编译报 fontset 错误

**症状**：`Critical Package ctex Error: CTeX fontset 'fandol' is unavailable`

**原因**：
- `fandol` 字体集**不支持 pdflatex**（必须用 xelatex/lualatex）
- 或系统缺少 `fontset=` 指定的字体

**解决**：
```latex
% 方案 A：换引擎（推荐）
% 用 xelatex 编译，而非 pdflatex

% 方案 B：手动指定 fontset
\usepackage[fontset=mac]{ctex}      % macOS
\usepackage[fontset=windows]{ctex}  % Windows
\usepackage[fontset=ubuntu]{ctex}   % Ubuntu Linux
\usepackage[fontset=fandol]{ctex}   % 跨平台，但需 xelatex

% 方案 C：完全不依赖系统字体
\usepackage[fontset=fandol, engine=xelatex]{ctex}
```
