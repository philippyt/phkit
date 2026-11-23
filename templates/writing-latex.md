# AGENTS.md

extends global `AGENTS.md`.

## project

[document type, audience, and core argument or report scope]

## workflow

you are writing a technical document in LaTeX.

before writing any section, confirm:
- what the section needs to establish
- what evidence or results it references
- what the reader should conclude after reading it

write section by section. stop after each section and wait for feedback before continuing.

verify compilation with `latexmk -pdf main.tex` (or the project's configured LaTeX build command) and check for undefined references, missing citations, and overfull hbox warnings.

## writing style

these rules are absolute. do not deviate.

### sentence structure
- one claim per sentence.
- short sentences. if a sentence has two clauses joined by a conjunction, split it into two sentences.
- no em dashes. if you want to use one, rewrite the sentence.
- no throat-clearing. never open a section with "in this section we..." or "it is worth noting that...". start with the claim.

### evidence and claims
- every assertion references its source in the same sentence: "as presented in \cref{fig:...}" / "as shown in \cref{tab:...}" / "as described in \cref{sec:...}". never assert without a pointer.
- numbers over adjectives. do not write "significantly higher"; write the actual delta. do not write "strong performance"; write the metric value.
- scope claims tightly. if something was tested on one dataset, state that. do not generalise beyond the evidence.

### tradeoffs
- state tradeoffs as facts, not arguments. two sentences: the numbers, then the decision. no rhetorical justification.
- example: "manhattan distance achieved 86.49% accuracy but required 66.83s runtime versus 2.61s for euclidean. euclidean was selected."

### what to avoid
- no causal connectives (`therefore`, `thus`, `hence`) unless the causal mechanism is measured.
- no `however` followed by hedging.
- no unmeasured adjectives (`good`, `strong`, `notable`, `interesting`, `important`) unless followed by a number.
- no passive constructions that hide agency when the agent matters.
- no filler transition sentences between sections.
- no "in conclusion" or "to summarise" to open a conclusion.

### limitations
- state limitations neutrally and precisely where they arise, not defensively in a separate section at the end.
- name the constraint and its consequence. no apologising.

### footnotes
- definitional asides go in footnotes, not parentheticals in the main text.
- footnotes clarify; they do not hedge main claims.

### figure captions
- captions restate the key finding, not just what is displayed.
  - bad: "confusion matrix of the DNN."
  - good: "confusion matrix of the DNN. shirt had the highest misclassification rate, frequently confused with t-shirt/top."

### table captions
- descriptive, including conditions.
  - bad: "model results."
  - good: "classification accuracy and runtime for knn with pca-reduced features at varying component counts."
- caption goes above the table, `\label{}` immediately after `\caption{}`.

## latex conventions

### preamble

```latex
\usepackage{graphicx}
\usepackage{float}
\usepackage{caption}
\usepackage{subcaption}
\usepackage{array}
\usepackage{microtype}
\usepackage{hyperref}
\usepackage{cleveref}
\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{siunitx}
\graphicspath{{figures/}}
```

### figures

always use `[H]` placement. never let results figures float.

```latex
\begin{figure}[H]
    \centering
    \includegraphics[width=0.8\textwidth]{filename}
    \caption{Caption restating the key finding.}
    \label{fig:label}
\end{figure}
```

side-by-side figures:

```latex
\begin{figure}[H]
    \centering
    \begin{subfigure}{0.48\textwidth}
        \includegraphics[width=\textwidth]{fig_left}
        \caption{Left label.}
    \end{subfigure}
    \hfill
    \begin{subfigure}{0.48\textwidth}
        \includegraphics[width=\textwidth]{fig_right}
        \caption{Right label.}
    \end{subfigure}
    \caption{Overall caption restating the key finding.}
    \label{fig:label}
\end{figure}
```

### tables

IEEE style: `\hline` (not `booktabs`), no vertical lines, caption above. `l` for text, `r` for numbers, `c` sparingly.

```latex
\begin{table}[H]
\centering
\caption{Descriptive caption including conditions.}
\label{tab:label}
\begin{tabular}{l l r}
\hline
Column one & Column two & Value \\
\hline
row & data & 0.00 \\
\hline
\end{tabular}
\end{table}
```

### inline math and references

- italicise single-letter variables (`$k$`, `$n$`, `$S$`, `$W$`). never write variable names as plain text inline.
- use `\cref{}` instead of `Figure~\ref{}`.

### file organisation

```text
project/
├── main.tex
├── figures/
├── sections/
│   ├── intro.tex
│   ├── method.tex
│   └── ...
└── refs.bib
```

use `\input{sections/intro}` in `main.tex`. keep sections in separate files.
