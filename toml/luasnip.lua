local ls = require("luasnip")
local s = ls.snippet

local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node

local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt
local extras = require("luasnip.extras")
local m = extras.m
local l = extras.l
local rep = extras.rep
local postfix = require("luasnip.extras.postfix").postfix

ls.add_snippets("python", {
    ls.parser.parse_snippet("pf", "print(f\"{$1}\")$0"),
    ls.parser.parse_snippet("pdb", "__import__(\"pdb\").set_trace()"),
    ls.parser.parse_snippet("todo", "# TODO: "),
    ls.parser.parse_snippet("pltimport", "import matplotlib.pyplot as plt"),
    ls.parser.parse_snippet("ifmain", "if __name__ == \"__main__\":"),
    ls.parser.parse_snippet({ trig = "plot_instantly", name = "plot_instantly" },
        [[
from matplotlib.pyplot import plot,hist,imshow,scatter,show,savefig,legend,clf,figure,close
import matplotlib.pyplot as plt
imshow($1)
show()
$0
]]
    ),
    ls.parser.parse_snippet({ trig = "argument_parser", name = "argument_parser" },
        [[
import argparse
p = argparse.ArgumentParser()
p.add_argument('${1:foo}')
args = p.parse_args()
]]
    ),
})

ls.add_snippets("html", {
    ls.parser.parse_snippet("rb", "<ruby>$1<rp> (</rp><rt>$2</rt><rp>) </rp></ruby>$0")
})

ls.add_snippets("markdown", {
    ls.parser.parse_snippet("rb", "<ruby>$1<rp> (</rp><rt>$2</rt><rp>) </rp></ruby>$0"),
    ls.parser.parse_snippet("str", "<strong>$1</strong>$0"),
    ls.parser.parse_snippet("acd", [[
<details>
<summary>
$1
</summary>

$2

</details>
$0
]])
})
ls.add_snippets("tex", {
    ls.parser.parse_snippet("bf", "\\textbf{$1}"),
    ls.parser.parse_snippet("it", "\\textit{$1}"),
    ls.parser.parse_snippet("sc", "\\textsc{$1}"),
    ls.parser.parse_snippet("sf", "\\textsf{$1}"),
    ls.parser.parse_snippet("tt", "\\texttt{$1}"),
    ls.parser.parse_snippet("em", "\\emph{$1}"),
    ls.parser.parse_snippet({trig=",,", snippetType="autosnippet"}, "$$1$"),
    ls.parser.parse_snippet("jbase",
        [[
\documentclass[12pt,a4paper,titlepage]{jlreq}
% some packages
% \usepackage{graphicx}
% \usepackage{amsmath}
% \usepackage{amssymb}
% \usepackage{todonotes}
% \usepackage{siunitx}
% \usepackage{bm}
% \usepackage{booktabs}
% \usepackage{capt-of}
% 
% \usepackage{/home/snakamura/ghq/github.com/woodyZootopia/latex-macros/macros-maths}
% \usepackage[
%     backend=biber,
%     style=numeric,
%     sortlocale=en_US,
%     url=true, 
%     doi=true,
%     eprint=false
% ]{biblatex}
% \addbibresource{citations.bib}
% \usepackage{luatexja-ruby}

\title{${1:レポート}}
\author{${2}}
%
\begin{document}
\maketitle

\setcounter{tocdepth}{5}
% \tableofcontents

${0:Hello, world!}

% \printbibliography
\end{document}
]]
    ),
    ls.parser.parse_snippet("fig",
    [[
\begin{figure}[b]
    \centering
    \includegraphics[width=\linewidth]{${1:path}}
    \caption{${2:caption}}
	\label{fig:${5:${1/[\W]+/_/g}}}
\end{figure}$0
    ]]
    ),
    ls.parser.parse_snippet("preview",
    [[
\documentclass{jlreq}
\usepackage[active,tightpage]{preview}
% some packages
% \usepackage{graphicx}
% \usepackage{amsmath}
% \usepackage{amssymb}
% \usepackage{todonotes}
% \usepackage{siunitx}
% \usepackage{bm}
% \usepackage{booktabs}
% \usepackage{capt-of}

\begin{document}
\begin{preview}
    ${0}
\end{preview}
\end{document}
    ]]
    )
})
