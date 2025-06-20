#' Sensitivity and specificity plot from a cutpointr object
#'
#' Given a \code{cutpointr} object this function plots the sensitivity and specificity
#' curve(s) per subgroup, if the latter is given.
#' @param x A cutpointr object.
#' @param display_cutpoint (logical) Whether or not to display the optimal
#' cutpoint as a dot on the precision recall curve.
#' @param ... Additional arguments (unused).
#' @examples
#' library(cutpointr)
#'
#' ## Optimal cutpoint for dsi
#' data(suicide)
#' opt_cut <- cutpointr(suicide, dsi, suicide)
#' plot_sensitivity_specificity(opt_cut)
#' @family cutpointr plotting functions
#' @export
#' @importFrom purrr %>%
plot_sensitivity_specificity <- function(x, display_cutpoint = TRUE, ...) {
  if (!("cutpointr" %in% class(x))) {
    stop("Only cutpointr objects are supported.")
  }
  args <- list(...)

    if (!(has_column(x, "subgroup"))) {
        dts_pr <- c("roc_curve", "optimal_cutpoint")
    } else {
        dts_pr <- c("roc_curve", "subgroup", "optimal_cutpoint")
    }

  plot_title <- ggplot2::ggtitle("Sensitivity and Specificity Plot")
    for (r in 1:nrow(x)) {
        x$roc_curve[[r]] <- x$roc_curve[[r]] %>%
            dplyr::mutate(Sensitivity = tp / (tp + fn),
                          Specificity = tn / (tn + fp))
    }
    res_unnested <- x %>%
        dplyr::select(tidyselect::all_of(dts_pr)) %>%
        tidyr::unnest("roc_curve")
    res_unnested <- res_unnested[is.finite(res_unnested$x.sorted), ]
    res_unnested <- tidyr::gather(res_unnested, key = "metric", value = "value",
                                  Sensitivity, Specificity)
    if (!(has_column(x, "subgroup"))) {
      pr <- ggplot2::ggplot(res_unnested,
                            ggplot2::aes(x = x.sorted, y = value,
                                         color = metric))
    } else {
      pr <- ggplot2::ggplot(res_unnested,
                            ggplot2::aes(x = x.sorted, y = value,
                                         color = metric, linetype = subgroup))
    }
    pr <- pr +
      ggplot2::geom_line() +
      plot_title +
      ggplot2::xlab("Cutpoint") +
      ggplot2::ylab("Sensitivity and Specificity")
    if (display_cutpoint) {
        if (!(has_column(x, "subgroup"))) {
            res_cutpoints <- x %>%
                dplyr::select("optimal_cutpoint")
            if (is.list(res_cutpoints$optimal_cutpoint)) {
                res_cutpoints <- tidyr::unnest(res_cutpoints)
            }
            pr <- pr +
                ggplot2::geom_vline(data = res_cutpoints,
                                    ggplot2::aes(xintercept = optimal_cutpoint))
        } else {
            res_cutpoints <- x %>%
                dplyr::select("optimal_cutpoint", "subgroup")
            if (is.list(res_cutpoints$optimal_cutpoint)) {
                res_cutpoints <- tidyr::unnest(res_cutpoints)
            }
            pr <- pr +
                ggplot2::geom_vline(data = res_cutpoints,
                                    ggplot2::aes(xintercept = optimal_cutpoint,
                                                 linetype = subgroup))
        }
    }
    return(pr)
}
