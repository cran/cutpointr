
sens_spec <- function(tp, fp, tn, fn) {
    sens <- tp / (tp + fn)
    spec <- tn / (tn + fp)
    res <- cbind(sens, spec)
    colnames(res) <- c("sensitivity", "specificity")
    return(res)
}

sesp_from_oc <- function(roc_curve, oc, direction, opt_ind = NULL) {
    if (is.null(opt_ind)) {
        opt_ind <- purrr::map_dbl(oc[[1]], function(x) {
            get_opt_ind(roc_curve = roc_curve, oc = x, direction = direction)
        })
    }
    sens_spec(tp = roc_curve$tp[opt_ind], fp = roc_curve$fp[opt_ind],
              tn = roc_curve$tn[opt_ind], fn = roc_curve$fn[opt_ind])
}

accuracy_from_oc <- function(roc_curve, oc, direction, opt_ind = NULL) {
    if (is.null(opt_ind)) {
        opt_ind <- purrr::map_dbl(oc[[1]], function(x) {
            get_opt_ind(roc_curve = roc_curve, oc = x, direction = direction)
        })
        opt_ind <- get_opt_ind(roc_curve = roc_curve, oc = oc, direction = direction)
    }
    accuracy(tp = roc_curve$tp[opt_ind], fp = roc_curve$fp[opt_ind],
             tn = roc_curve$tn[opt_ind], fn = roc_curve$fn[opt_ind])
}

kappa_from_oc <- function(roc_curve, oc, direction, opt_ind = NULL) {
    if (is.null(opt_ind)) {
        opt_ind <- purrr::map_dbl(oc[[1]], function(x) {
            get_opt_ind(roc_curve = roc_curve, oc = x, direction = direction)
        })
        opt_ind <- get_opt_ind(roc_curve = roc_curve, oc = oc, direction = direction)
    }
    cohens_kappa(tp = roc_curve$tp[opt_ind], fp = roc_curve$fp[opt_ind],
              tn = roc_curve$tn[opt_ind], fn = roc_curve$fn[opt_ind])
}

#' Calculate AUC from a roc_cutpointr or cutpointr object
#'
#' Calculate the area under the ROC curve using the trapezoidal rule.
#'
#' @param x Data frame resulting from the roc() or cutpointr() function.
#' @source Forked from the AUC package
#' @return Numeric vector of AUC values
#' @name auc
#' @export
auc <- function(x) {
    UseMethod("auc", x)
}

#' @rdname auc
#' @export
auc.roc_cutpointr <- function(x) {
    tpr <- x$tpr
    fpr <- x$fpr
    l_tpr <- length(tpr)
    l_fpr <- length(fpr)
    stopifnot(l_tpr == l_fpr)
    tpr <- cbind(tpr[2:l_tpr], tpr[1:(l_tpr - 1)])
    fpr <- cbind(fpr[2:l_fpr], fpr[1:(l_fpr - 1)])
    sum(0.5 * abs(fpr[, 1] - fpr[, 2]) * (tpr[, 1] + tpr[, 2]))
}

#' @rdname auc
#' @export
auc.cutpointr <- function(x) {
    x$AUC
}

#' Extract the cutpoints from a ROC curve generated by cutpointr
#'
#' This is a utility function for extracting the cutpoints from a \code{roc_cutpointr}
#' object. Mainly useful in conjunction with the \code{plot_cutpointr} function if
#' cutpoints are to be plotted on the x-axis.
#'
#' @name cutpoint
#' @param x A roc_cutpointr object.
#' @param ... Further arguments.
#' @examples
#' oc <- cutpointr(suicide, dsi, suicide, gender)
#' plot_cutpointr(oc, cutpoint, accuracy)
#'
#' @family metric functions
#' @export
cutpoint <- function(x, ...) {
    x[["x.sorted"]]
}
#' @rdname cutpoint
#' @export
cutpoints <- function(x, ...) {
    x[["x.sorted"]]
}

#' Calculate accuracy
#'
#' Calculate accuracy from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' accuracy = (tp + tn) / (tp + fp + tn + fn)
#' @param tp (numeric) number of true positives.
#' @param fp (numeric) number of false positives.
#' @param tn (numeric) number of true negatives.
#' @param fn (numeric) number of false negatives.
#' @param ... for capturing additional arguments passed by method.
#' @examples
#' accuracy(10, 5, 20, 10)
#' accuracy(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
accuracy <- function(tp, fp, tn, fn, ...) {
    Accuracy <- cbind((tp + tn) / (tp + fp + tn + fn))
    colnames(Accuracy) <- "accuracy"
    return(Accuracy)
}

#' Calculate the Youden-Index
#'
#' Calculate the Youden-Index (J-Index) from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' sensitivity = tp / (tp + fn) \cr
#' specificity = tn / (tn + fp) \cr
#' youden_index = sensitivity + specificity - 1 \cr
#' @inheritParams accuracy
#' @examples
#' youden(10, 5, 20, 10)
#' youden(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
youden <- function(tp, fp, tn, fn, ...) {
    sesp <- sens_spec(tp, fp, tn, fn)
    youden <- cbind(rowSums(sesp) - 1)
    colnames(youden) <- "youden"
    return(youden)
}

#' Calculate sensitivity
#'
#' Calculate sensitivity from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' sensitivity = tp / (tp + fn) \cr
#' @inheritParams accuracy
#' @examples
#' sensitivity(10, 5, 20, 10)
#' sensitivity(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
sensitivity <- function(tp, fn, ...) {
    sens <- tp / (tp + fn)
    sens <- matrix(sens, ncol = 1)
    colnames(sens) <- "sensitivity"
    return(sens)
}


#' Calculate specificity
#'
#' Calculate specificity from true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' specificity = tn / (tn + fp) \cr
#' @inheritParams accuracy
#' @examples
#' specificity(10, 5, 20, 10)
#' specificity(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
specificity <- function(fp, tn, ...) {
    spec <- tn / (tn + fp)
    spec <- matrix(spec, ncol = 1)
    colnames(spec) <- "specificity"
    return(spec)
}


#' Metrics that are constrained by another metric
#'
#' For example, calculate sensitivity where
#' a lower bound (minimal desired value) for specificty can be defined. All returned
#' metric values for cutpoints that lead to values of the constraining metric
#' below the specified minimum will be zero.
#' The inputs must be vectors of equal length.
#' @examples
#' ## Maximum sensitivity when Positive Predictive Value (PPV) is at least 75%
#' library(dplyr)
#' library(purrr)
#' library(cutpointr)
#' cp <- cutpointr(data = suicide, x = dsi, class = suicide,
#' method = maximize_metric,
#' metric = sens_constrain,
#' constrain_metric = ppv,
#' min_constrain = 0.75)
#' ## All metric values (m) where PPV < 0.75 are zero
#' plot_metric(cp)
#' cp$roc_curve
#' ## We can confirm that PPV is indeed >= 0.75
#' cp %>%
#'     add_metric(list(ppv))
#' ## We can also do so for the complete ROC curve(s)
#' cp %>%
#'     pull(roc_curve) %>%
#'     map(~ add_metric(., list(sensitivity, ppv)))
#'
#' ## Use the metric_constrain function for a combination of any two metrics
#' ## Estimate optimal cutpoint for precision given a recall of at least 70%
#' cp <- cutpointr(data = suicide, x = dsi, class = suicide,
#'                 subgroup = gender,
#'                 method = maximize_metric,
#'                 metric = metric_constrain,
#'                 main_metric = precision,
#'                 suffix = "_constrained",
#'                 constrain_metric = recall,
#'                 min_constrain = 0.70)
#' ## All metric values (m) where recall < 0.7 are zero
#' plot_metric(cp)
#' ## We can confirm that recall is indeed >= 0.70 and that precision_constrain
#' ## is identical to precision for the estimated cutpoint
#' cp %>%
#'     add_metric(list(recall, precision))
#' ## We can also do so for the complete ROC curve(s)
#' cp %>%
#'     pull(roc_curve) %>%
#'     map(~ add_metric(., list(recall, precision)))
#' @inheritParams accuracy
#' @family metric functions
#' @param constrain_metric Metric for constraint.
#' @param min_constrain Minimum desired value of constrain_metric.
#' @param main_metric Metric to be optimized.
#' @param suffix Character string to be added to the name of main_metric.
#' @name metric_constrain
#' @export
metric_constrain <- function(tp, fp, tn, fn,
                             main_metric = sensitivity,
                             constrain_metric = specificity,
                             min_constrain = 0.5, suffix = "_constrain", ...) {
    metric_constrain <- main_metric(tp = tp, fp = fp, tn = tn, fn = fn)
    metric_constrain <- sanitize_metric(m = metric_constrain,
                                        n = nrow(metric_constrain),
                                        m_name = "metric_constrain")
    constraint <- constrain_metric(tp = tp, fp = fp, tn = tn, fn = fn)
    constraint <- as.numeric(unlist(constraint))
    failed_constr <- constraint < min_constrain
    metric_constrain[failed_constr, ] <- 0
    if (all(failed_constr)) {
        warning("No cutpoint was found that satisfies the constraint.")
    }
    colnames(metric_constrain) <- paste0(colnames(metric_constrain), suffix)
    return(metric_constrain)
}
#' @rdname metric_constrain
#' @export
sens_constrain <- function(tp, fp, tn, fn, constrain_metric = specificity,
                           min_constrain = 0.5, ...) {
    metric_constrain <- sensitivity(tp = tp, fn = fn)
    constraint <- constrain_metric(tp = tp, fp = fp, tn = tn, fn = fn)
    constraint <- as.numeric(unlist(constraint))
    failed_constr <- constraint < min_constrain
    if (all(failed_constr)) {
        warning("No cutpoint was found that satisfies the constraint.")
    }
    metric_constrain[failed_constr, ] <- 0
    colnames(metric_constrain) <- "sens_constrain"
    return(metric_constrain)
}
#' @rdname metric_constrain
#' @export
spec_constrain <- function(tp, fp, tn, fn, constrain_metric = sensitivity,
                           min_constrain = 0.5, ...) {
    metric_constrain <- specificity(fp = fp, tn = tn)
    constraint <- constrain_metric(tp = tp, fp = fp, tn = tn, fn = fn)
    constraint <- as.numeric(unlist(constraint))
    failed_constr <- constraint < min_constrain
    if (all(failed_constr)) {
        warning("No cutpoint was found that satisfies the constraint.")
    }
    metric_constrain[failed_constr, ] <- 0
    colnames(metric_constrain) <- "spec_constrain"
    return(metric_constrain)
}
#' @rdname metric_constrain
#' @export
acc_constrain <- function(tp, fp, tn, fn, constrain_metric = sensitivity,
                           min_constrain = 0.5, ...) {
    metric_constrain <- accuracy(tp = tp, tn = tn, fp = fp, fn = fn)
    constraint <- constrain_metric(tp = tp, fp = fp, tn = tn, fn = fn)
    constraint <- as.numeric(unlist(constraint))
    failed_constr <- constraint < min_constrain
    if (all(failed_constr)) {
        warning("No cutpoint was found that satisfies the constraint.")
    }
    metric_constrain[failed_constr, ] <- 0
    colnames(metric_constrain) <- "acc_constrain"
    return(metric_constrain)
}


#' Calculate the sum of sensitivity and specificity
#'
#' Calculate the sum of sensitivity and specificity from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' sensitivity = tp / (tp + fn) \cr
#' specificity = tn / (tn + fp) \cr
#' sum_sens_spec = sensitivity + specificity \cr
#' @inheritParams accuracy
#' @examples
#' sum_sens_spec(10, 5, 20, 10)
#' sum_sens_spec(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
sum_sens_spec <- function(tp, fp, tn, fn, ...) {
    sesp <- sens_spec(tp, fp, tn, fn)
    sesp <- cbind(rowSums(sesp))
    colnames(sesp) <- "sum_sens_spec"
    return(sesp)
}


#' Calculate the product of sensitivity and specificity
#'
#' Calculate the product of sensitivity and specificity from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' sensitivity = tp / (tp + fn) \cr
#' specificity = tn / (tn + fp) \cr
#' prod_sens_spec = sensitivity * specificity \cr
#' @inheritParams accuracy
#' @examples
#' prod_sens_spec(10, 5, 20, 10)
#' prod_sens_spec(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
prod_sens_spec <- function(tp, fp, tn, fn, ...) {
    sesp <- sens_spec(tp, fp, tn, fn)
    sesp <- cbind(sesp[, 1] * sesp[, 2])
    colnames(sesp) <- "prod_sens_spec"
    return(sesp)
}

#' Calculate the absolute difference of sensitivity and specificity
#'
#' Calculate the absolute difference of sensitivity and specificity
#' from true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr
#' \cr
#' sensitivity = tp / (tp + fn) \cr
#' specificity = tn / (tn + fp) \cr
#' abs_d_sens_spec = |sensitivity - specificity| \cr
#' @inheritParams accuracy
#' @examples
#' abs_d_sens_spec(10, 5, 20, 10)
#' abs_d_sens_spec(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
abs_d_sens_spec <- function(tp, fp, tn, fn, ...) {
    sesp <- sens_spec(tp, fp, tn, fn)
    abs_d_sesp <- abs(sesp[, 1] - sesp[, 2])
    abs_d_sesp <- matrix(abs_d_sesp, ncol = 1)
    colnames(abs_d_sesp) <- "abs_d_sens_spec"
    return(abs_d_sesp)
}

#' Calculate the distance between points on the ROC curve and (0,1)
#'
#' Calculate the distance on the ROC space between points on the ROC curve
#' and the point of perfect discrimination
#' from true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. To be used with
#' \code{method = minimize_metric}. \cr
#' \cr
#' sensitivity = tp / (tp + fn) \cr
#' specificity = tn / (tn + fp) \cr
#' roc01 = sqrt((1 - sensitivity)^2 + (1 - specificity)^2) \cr
#' @inheritParams accuracy
#' @examples
#' roc01(10, 5, 20, 10)
#' roc01(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' oc <- cutpointr(suicide, dsi, suicide,
#'   method = minimize_metric, metric = roc01)
#' plot_roc(oc)
#' @family metric functions
#' @export
roc01 <- function(tp, fp, tn, fn, ...) {
    sesp <- sens_spec(tp, fp, tn, fn)
    distance <- sqrt((1 - sesp[, 1])^2 + (1 - sesp[, 2])^2)
    distance <- matrix(distance, ncol = 1)
    colnames(distance) <- "roc01"
    return(distance)
}

#' Calculate precision
#'
#' Calculate precision (equal to the positive predictive value)
#' from true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' precision = tp / (tp + fp) \cr
#' @inheritParams accuracy
#' @examples
#' precision(10, 5, 20, 10)
#' precision(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
precision <- function(tp, fp, tn, fn, ...) {
    prec <- ppv(tp = tp, fp = fp, tn = tn, fn = fn)
    colnames(prec) <- "precision"
    return(prec)
}

#' Calculate recall
#'
#' Calculate recall (equal to sensitivity) from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' recall = tp / (tp + fn) \cr
#' @inheritParams accuracy
#' @examples
#' recall(10, 5, 20, 10)
#' recall(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
recall <- function(tp, fp, tn, fn, ...) {
    rec <- sensitivity(tp = tp, fp = fp, tn = tn, fn = fn)
    colnames(rec) <- "recall"
    return(rec)
}

#' Calculate the positive predictive value
#'
#' Calculate the positive predictive value (PPV) from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' ppv = tp / (tp + fp) \cr
#' @inheritParams accuracy
#' @examples
#' ppv(10, 5, 20, 10)
#' ppv(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
ppv <- function(tp, fp, tn, fn, ...) {
    ppv <- tp / (tp + fp)
    ppv <- matrix(ppv, ncol = 1)
    colnames(ppv) <- "ppv"
    return(ppv)
}


#' Calculate the negative predictive value
#'
#' Calculate the negative predictive value (NPV)
#' from true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' npv = tn / (tn + fn) \cr
#' @inheritParams accuracy
#' @examples
#' npv(10, 5, 20, 10)
#' npv(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
npv <- function(tp, fp, tn, fn, ...) {
    npv <- tn / (tn + fn)
    npv <- matrix(npv, ncol = 1)
    colnames(npv) <- "npv"
    return(npv)
}

#' Calculate the absolute difference of positive and negative predictive value
#'
#' Calculate the absolute difference of positive predictive value (PPV) and
#' negative predictive value (NPV) from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' ppv = tp / (tp + fp) \cr
#' npv = tn / (tn + fn) \cr
#' abs\_d\_ppv\_npv = |ppv - npv| \cr
#' @inheritParams accuracy
#' @examples
#' abs_d_ppv_npv(10, 5, 20, 10)
#' abs_d_ppv_npv(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
abs_d_ppv_npv <- function(tp, fp, tn, fn, ...) {
    ppv <- tp / (tp + fp)
    npv <- tn / (tn + fn)
    abs_d_ppvnpv <- abs(ppv - npv)
    abs_d_ppvnpv <- matrix(abs_d_ppvnpv, ncol = 1)
    colnames(abs_d_ppvnpv) <- "abs_d_ppv_npv"
    return(abs_d_ppvnpv)
}

#' Calculate the sum of positive and negative predictive value
#'
#' Calculate the sum of positive predictive value (PPV) and
#' negative predictive value (NPV) from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' ppv = tp / (tp + fp) \cr
#' npv = tn / (tn + fn) \cr
#' sum_ppv_npv = ppv + npv \cr
#' @inheritParams accuracy
#' @examples
#' sum_ppv_npv(10, 5, 20, 10)
#' sum_ppv_npv(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
sum_ppv_npv <- function(tp, fp, tn, fn, ...) {
    ppv <- tp / (tp + fp)
    npv <- tn / (tn + fn)
    sum_ppvnpv <- ppv + npv
    sum_ppvnpv <- matrix(sum_ppvnpv, ncol = 1)
    colnames(sum_ppvnpv) <- "sum_ppv_npv"
    return(sum_ppvnpv)
}

#' Calculate the product of positive and negative predictive value
#'
#' Calculate the product of positive predictive value (PPV) and
#' negative predictive value (NPV) from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' ppv = tp / (tp + fp) \cr
#' npv = tn / (tn + fn) \cr
#' prod_ppv_npv = ppv * npv \cr
#' @inheritParams accuracy
#' @examples
#' prod_ppv_npv(10, 5, 20, 10)
#' prod_ppv_npv(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
prod_ppv_npv <- function(tp, fp, tn, fn, ...) {
    ppv <- tp / (tp + fp)
    npv <- tn / (tn + fn)
    prod_ppvnpv <- ppv * npv
    prod_ppvnpv <- matrix(prod_ppvnpv, ncol = 1)
    colnames(prod_ppvnpv) <- "prod_ppv_npv"
    return(prod_ppvnpv)
}


#' Calculate the false omission and false discovery rate
#'
#' Calculate the false omission rate or false discovery rate
#' from true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' false_omission_rate = fn / (tn + fn) = 1 - npv
#' false_discovery_rate = fp / (tp + fp) = 1 - ppv
#' @inheritParams accuracy
#' @examples
#' false_omission_rate(10, 5, 20, 10)
#' false_omission_rate(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @name false_omission_rate
#' @family metric functions
#' @export
false_omission_rate <- function(tp, fp, tn, fn, ...) {
    fomr <- fn / (tn + fn)
    fomr <- matrix(fomr, ncol = 1)
    colnames(fomr) <- "false_omission_rate"
    return(fomr)
}
#' @rdname false_omission_rate
#' @export
false_discovery_rate <- function(tp, fp, tn, fn, ...) {
    fdr <- fp / (tp + fp)
    fdr <- matrix(fdr, ncol = 1)
    colnames(fdr) <- "false_discovery_rate"
    return(fdr)
}


#' Calculate true / false positive / negative rate
#'
#' Calculate the true positive rate (tpr, equal to sensitivity and recall),
#' the false positive rate (fpr, equal to fall-out),
#' the true negative rate (tnr, equal to specificity),
#' or the false negative rate (fnr) from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' tpr = tp / (tp + fn) \cr
#' fpr = fp / (fp + tn) \cr
#' tnr = tn / (tn + fp) \cr
#' fnr = fn / (fn + tp) \cr
#' @inheritParams accuracy
#' @name tpr
#' @examples
#' tpr(10, 5, 20, 10)
#' tpr(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
tpr <- function(tp, fn, ...) {
    tprate <- sensitivity(tp = tp, fn = fn)
    colnames(tprate) <- "tpr"
    return(tprate)
}
#' @rdname tpr
#' @export
fpr <- function(fp, tn, ...) {
    fprate <- matrix(fp / (fp + tn), ncol = 1)
    colnames(fprate) <- "fpr"
    return(fprate)
}
#' @rdname tpr
#' @export
tnr <- function(fp, tn, ...) {
    tnrate <- specificity(tn = tn, fp = fp)
    colnames(tnrate) <- "tnr"
    return(tnrate)
}
#' @rdname tpr
#' @export
fnr <- function(tp, fn, ...) {
    fnrate <- matrix(fn / (fn + tp), ncol = 1)
    colnames(fnrate) <- "fnr"
    return(fnrate)
}


#' Calculate the positive or negative likelihood ratio
#'
#' Calculate the positive or negative likelihood ratio
#' from true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' plr = tpr / fpr \cr
#' nlr = fnr / tnr \cr
#' @name plr
#' @inheritParams accuracy
#' @examples
#' plr(10, 5, 20, 10)
#' plr(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
plr <- function(tp, fp, tn, fn, ...) {
    plr <- tpr(tp = tp, fp = tp, tn = tn, fn = fn) /
        fpr(tp = tp, fp = fp, tn = tn, fn = fn)
    plr <- matrix(plr, ncol = 1)
    colnames(plr) <- "plr"
    return(plr)
}
#' @rdname plr
#' @export
nlr <- function(tp, fp, tn, fn, ...) {
    nlr <- fnr(tp = tp, fp = tp, tn = tn, fn = fn) /
        tnr(tp = tp, fp = fp, tn = tn, fn = fn)
    nlr <- matrix(nlr, ncol = 1)
    colnames(nlr) <- "nlr"
    return(nlr)
}


#' Extract number true / false positives / negatives
#'
#' Extract the number of true positives (tp), false positives (fp),
#' true negatives (tn), or false negatives (fn).
#' The inputs must be vectors of equal length. Mainly useful for \code{plot_cutpointr}.
#' @name tp
#' @inheritParams accuracy
#' @examples
#' tp(10, 5, 20, 10)
#' tp(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' fp(10, 5, 20, 10)
#' tn(10, 5, 20, 10)
#' fn(10, 5, 20, 10)
#' @family metric functions
#' @export
tp <- function(tp, ...) {
    res <- matrix(tp, ncol = 1)
    colnames(res) <- "tp"
    return(res)
}
#' @rdname tp
#' @export
tn <- function(tn, ...) {
    res <- matrix(tn, ncol = 1)
    colnames(res) <- "tn"
    return(res)
}
#' @rdname tp
#' @export
fp <- function(fp, ...) {
    res <- matrix(fp, ncol = 1)
    colnames(res) <- "fp"
    return(res)
}
#' @rdname tp
#' @export
fn <- function(fn, ...) {
    res <- matrix(fn, ncol = 1)
    colnames(res) <- "fn"
    return(res)
}


#' Calculate Cohen's Kappa
#'
#' Calculate the Kappa metric from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' mrg_a = ((tp + fn) * (tp + fp)) / (tp + fn + fp + tn) \cr
#' mrg_b = ((fp + tn) * (fn + tn)) / (tp + fn + fp + tn) \cr
#' expec_agree = (mrg_a + mrg_b) / (tp + fn + fp + tn) \cr
#' obs_agree = (tp + tn) / (tp + fn + fp + tn) \cr
#' cohens_kappa = (obs_agree - expec_agree) / (1 - expec_agree) \cr
#' @inheritParams accuracy
#' @examples
#' cohens_kappa(10, 5, 20, 10)
#' cohens_kappa(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @return A numeric matrix with the column name "cohens_kappa".
#' @family metric functions
#' @export
cohens_kappa <- function(tp, fp, tn, fn, ...) {
    mrg_a <- ((tp + fn) * (tp + fp)) / (tp + fn + fp + tn)
    mrg_b <- ((fp + tn) * (fn + tn)) / (tp + fn + fp + tn)
    EA     <- (mrg_a + mrg_b) / (tp + fn + fp + tn)
    OA     <- (tp + tn) / (tp + fn + fp + tn)
    res <- matrix((OA - EA) / (1 - EA), ncol = 1)
    colnames(res) <- "cohens_kappa"
    return(res)
}

#' Calculate the odds ratio
#'
#' Calculate the (diagnostic) odds ratio from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' odds_ratio = (tp / fp) / (fn / tn) \cr
#' @inheritParams accuracy
#' @examples
#' odds_ratio(10, 5, 20, 10)
#' odds_ratio(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
odds_ratio <- function(tp, fp, tn, fn, ...) {
    or <- (tp / fp) / (fn / tn)
    or <- matrix(or, ncol = 1)
    colnames(or) <- "odds_ratio"
    return(or)
}

#' Calculate the risk ratio (relative risk)
#'
#' Calculate the risk ratio (or relative risk) from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' risk_ratio = (tp / (tp + fn)) / (fp / (fp + tn)) \cr
#' @inheritParams accuracy
#' @examples
#' risk_ratio(10, 5, 20, 10)
#' risk_ratio(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
risk_ratio <- function(tp, fp, tn, fn, ...) {
    rr <- (tp / (tp + fn)) / (fp / (fp + tn))
    rr <- matrix(rr, ncol = 1)
    colnames(rr) <- "risk_ratio"
    return(rr)
}

#' Calculate the p-value of a chi-squared test
#'
#' Calculate the p-value of a chi-squared test from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length.
#' @inheritParams accuracy
#' @examples
#' p_chisquared(10, 5, 20, 10)
#' p_chisquared(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
p_chisquared <- function(tp, fp, tn, fn, ...) {
    samplesize <- tp + fp + tn + fn
    chisq <- (samplesize * ((tp * tn - fp * fn) ** 2)) /
        ((tp + fp) * (fn + tn) * (tp + fn) * (fp + tn))
    pval <- stats::pchisq(chisq, 1, lower.tail = F)
    pval <- matrix(pval, ncol = 1)
    colnames(pval) <- "p_chisquared"
    return(pval)
}

#' Calculate the misclassification cost
#'
#' Calculate the misclassification cost from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' misclassification_cost = cost_fp * fp + cost_fn * fn \cr
#' @inheritParams accuracy
#' @param cost_fp (numeric) the cost of a false positive
#' @param cost_fn (numeric) the cost of a false negative
#' @examples
#' misclassification_cost(10, 5, 20, 10, cost_fp = 1, cost_fn = 5)
#' misclassification_cost(c(10, 8), c(5, 7), c(20, 12), c(10, 18),
#'                        cost_fp = 1, cost_fn = 5)
#' @family metric functions
#' @export
misclassification_cost <- function(tp, fp, tn, fn, cost_fp = 1, cost_fn = 1, ...) {
    misclassification_cost <- cost_fp * fp + cost_fn * fn
    misclassification_cost <- matrix(misclassification_cost, ncol = 1)
    colnames(misclassification_cost) <- "misclassification_cost"
    return(misclassification_cost)
}

#' Calculate the total utility
#'
#' Calculate the total utility from
#' true positives, false positives, true negatives and false negatives. \cr \cr
#' total_utility = utility_tp * tp + utility_tn * tn - cost_fp * fp - cost_fn * fn \cr \cr
#' The inputs must be vectors of equal length.
#' @inheritParams accuracy
#' @param utility_tp (numeric) the utility of a true positive
#' @param utility_tn (numeric) the utility of a true negative
#' @param cost_fp (numeric) the cost of a false positive
#' @param cost_fn (numeric) the cost of a false negative
#' @examples
#' total_utility(10, 5, 20, 10, utility_tp = 3, utility_tn = 3, cost_fp = 1, cost_fn = 5)
#' total_utility(c(10, 8), c(5, 7), c(20, 12), c(10, 18),
#'               utility_tp = 3, utility_tn = 3, cost_fp = 1, cost_fn = 5)
#' @family metric functions
#' @export
total_utility <- function(tp, fp, tn, fn,
                          utility_tp = 1, utility_tn = 1,
                          cost_fp = 1, cost_fn = 1, ...) {
    utility <- utility_tp * tp + utility_tn * tn - cost_fp * fp - cost_fn * fn
    utility <- matrix(utility, ncol = 1)
    colnames(utility) <- "total_utility"
    return(utility)
}

#' Calculate the F1-score
#'
#' Calculate the F1-score from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' F1_score = (2 * tp) / (2 * tp + fp + fn) \cr
#' @inheritParams accuracy
#' @examples
#' F1_score(10, 5, 20, 10)
#' F1_score(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
F1_score <- function(tp, fp, tn, fn, ...) {
    f <- (2 * tp) / (2 * tp + fp + fn)
    f <- matrix(f, ncol = 1)
    colnames(f) <- "F1_score"
    return(f)
}

#' Calculate the Jaccard Index
#'
#' Calculate the Jaccard Index from
#' true positives, false positives, true negatives and false negatives.
#' The inputs must be vectors of equal length. \cr \cr
#' Jaccard = (tp) / (tp + fp + fn) \cr
#' @inheritParams accuracy
#' @examples
#' Jaccard(10, 5, 20, 10)
#' Jaccard(c(10, 8), c(5, 7), c(20, 12), c(10, 18))
#' @family metric functions
#' @export
Jaccard <- function(tp, fp, tn, fn, ...) {
    f <- tp / (tp + fp + fn)
    f <- matrix(f, ncol = 1)
    colnames(f) <- "Jaccard"
    return(f)
}
