"""Shared seaborn/matplotlib style and color palette for project plots.

Importing this module applies the project-wide paper figure style. The palette
is generic; individual projects decide how colors map to experimental
conditions.
"""

import matplotlib
import numpy as np
import seaborn as sns

FIGSIZE_SCALE = 1.1
FONT_SCALE = 1.7

sns.set_style("white")
sns.set_context("paper", font_scale=FONT_SCALE)
matplotlib.rcParams.update({
    "pgf.texsystem": "pdflatex",
    "pgf.rcfonts": False,
    "font.family": "serif",
    "font.serif": ["Times", "Times New Roman"],
    "text.usetex": True,
    "text.latex.preamble": r"\usepackage{newtxtext,newtxmath}",
    "axes.linewidth": 0.5,
    "axes.facecolor": "white",
    "figure.facecolor": "white",
    "savefig.facecolor": "white",
    "savefig.transparent": False,
    "xtick.major.width": 0.5,
    "ytick.major.width": 0.5,
})

BLUE = "#37A5BE"
GREEN = "#26A671"
ORANGE = "#F27200"
PURPLE = "#9B6BCC"
RED = "#D94F4F"
GRAY = "#888888"

ERROR_KW = {"ecolor": "#333333", "elinewidth": 0.9, "capsize": 2.5, "capthick": 0.9}
LINE_KW = {"linewidth": 2.0}


def figsize(size):
    """Scale a (width, height) tuple by FIGSIZE_SCALE."""
    width, height = size
    return (width * FIGSIZE_SCALE, height * FIGSIZE_SCALE)


def model_label(name):
    """Make a model name LaTeX-safe."""
    return name.replace("_", r"\_")


RATE_FMT = r"{rate:.1f}\%"
AXIS_FONTSIZE = 27
YLABEL_FONTSIZE = 29
BAR_LABEL_FONTSIZE = 14
LEGEND_FONTSIZE = 27
LABELPAD = 4

LEGEND_KW = {
    "framealpha": 0,
    "handlelength": 1,
    "handleheight": 1,
    "borderpad": 0.4,
    "labelspacing": 0.3,
    "handletextpad": 0.4,
    "columnspacing": 1.0,
}


def bar_figsize(n_models, height=5.5):
    """Return the standard size for a model-grouped bar chart."""
    return figsize((max(7, n_models * 1.9 + 1), height))


def single_bar_figsize(n_models, height=5.5):
    """Return the standard size for a single-condition bar chart."""
    return figsize((max(5.0, n_models * 1.2 + 1), height))


def style_line_axes(ax, *, xlabel, ylabel, xticks=None):
    """Apply the unified white-background paper style to a line-chart axis."""
    ax.set_xlabel(xlabel, fontsize=YLABEL_FONTSIZE, labelpad=LABELPAD)
    ax.set_ylabel(ylabel, fontsize=YLABEL_FONTSIZE, labelpad=LABELPAD)
    if xticks is not None:
        ax.set_xticks(xticks)
    ax.tick_params(axis="both", which="major", labelsize=AXIS_FONTSIZE)
    ax.patch.set_facecolor("white")
    ax.patch.set_alpha(1)
    ax.xaxis.grid(True, linestyle="--", alpha=0.5)
    ax.yaxis.grid(True, linestyle="--", alpha=0.5)
    sns.despine(ax=ax)


def bar_layout(n_specs):
    """Return (slot, bar width, offsets) for a grouped bar chart."""
    slot = 0.8 / n_specs
    bar_width = slot * 0.8
    offsets = np.linspace(-0.4 + slot / 2, 0.4 - slot / 2, n_specs)
    return slot, bar_width, offsets


def style_bar_axes(
    ax,
    *,
    ylabel,
    models,
    ymax,
    ymax_scale=1.45,
    cap_at_105=False,
    bold_xticks=False,
    legend=True,
    legend_loc="upper right",
    legend_ncol=2,
    legend_y=1.12,
    xtick_rotation=30,
    xtick_pad=None,
    font_scale=1.0,
):
    """Apply the unified axis preset to a grouped bar chart."""
    ax.set_xticks(np.arange(len(models)))
    axis_fontsize = AXIS_FONTSIZE * font_scale
    ylabel_fontsize = YLABEL_FONTSIZE * font_scale
    legend_fontsize = LEGEND_FONTSIZE * font_scale
    label = (lambda model: rf"\textbf{{{model}}}") if bold_xticks else (lambda model: model)
    horizontal_alignment = "right" if xtick_rotation else "center"
    ax.set_xticklabels(
        [label(model) for model in models],
        fontsize=axis_fontsize,
        rotation=xtick_rotation,
        ha=horizontal_alignment,
    )
    ax.set_ylabel(ylabel, fontsize=ylabel_fontsize, labelpad=LABELPAD)
    ceiling = ymax * ymax_scale if ymax else 50
    ax.set_ylim(0, min(ceiling, 105) if cap_at_105 else ceiling)
    ax.grid(True, linestyle="--", alpha=0.7, axis="y")
    ax.tick_params(axis="both", which="major", labelsize=axis_fontsize)
    if xtick_pad is not None:
        ax.tick_params(axis="x", which="major", pad=xtick_pad)
    ax.patch.set_facecolor("white")
    ax.patch.set_alpha(1)
    if legend:
        ax.legend(
            fontsize=legend_fontsize,
            loc=legend_loc,
            ncol=legend_ncol,
            bbox_to_anchor=(1.0, legend_y),
            **LEGEND_KW,
        )


def annotate_bars(
    ax,
    bars,
    values,
    *,
    yerr=None,
    fmt=RATE_FMT,
    label_pad=0.3,
    fontsize=BAR_LABEL_FONTSIZE,
):
    """Annotate bar heights, offsetting labels above error bars."""
    for index, (bar, value) in enumerate(zip(bars, values)):
        error = yerr[1][index] if yerr is not None else 0.0
        ax.text(
            bar.get_x() + bar.get_width() / 2,
            bar.get_height() + error + label_pad,
            fmt.format(rate=value),
            ha="center",
            va="bottom",
            fontsize=fontsize,
        )


def single_bar_chart(
    ax,
    models,
    rates,
    *,
    ylabel,
    color=ORANGE,
    yerr=None,
    ymax_scale=1.3,
    cap_at_105=False,
    fmt=RATE_FMT,
    label_pad=0.3,
    bar_w=0.5,
    bold_xticks=True,
):
    """Draw a one-bar-per-model chart with the unified style."""
    x = np.arange(len(models))
    error_kw = ERROR_KW if yerr is not None else {}
    bars = ax.bar(x, rates, width=bar_w, color=color, yerr=yerr, error_kw=error_kw)
    annotate_bars(ax, bars, rates, yerr=yerr, fmt=fmt, label_pad=label_pad)
    if yerr is not None and len(rates):
        ymax = max(rate + error for rate, error in zip(rates, yerr[1]))
    else:
        ymax = max(rates) if rates else 0
    style_bar_axes(
        ax,
        ylabel=ylabel,
        models=models,
        ymax=ymax,
        ymax_scale=ymax_scale,
        cap_at_105=cap_at_105,
        legend=False,
        bold_xticks=bold_xticks,
    )
