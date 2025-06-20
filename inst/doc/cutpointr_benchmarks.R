## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(fig.width = 6, fig.height = 5, fig.align = "center")
options(rmarkdown.html_vignette.check_title = FALSE)
load("vignettedata/vignettedata.Rdata")

## ----eval = FALSE-------------------------------------------------------------
# # Return cutpoint that maximizes the sum of sensitivity and specificiy
# # ROCR package
# rocr_sensspec <- function(x, class) {
#     pred <- ROCR::prediction(x, class)
#     perf <- ROCR::performance(pred, "sens", "spec")
#     sens <- slot(perf, "y.values")[[1]]
#     spec <- slot(perf, "x.values")[[1]]
#     cut <- slot(perf, "alpha.values")[[1]]
#     cut[which.max(sens + spec)]
# }
# 
# # pROC package
# proc_sensspec <- function(x, class) {
#     r <- pROC::roc(class, x, algorithm = 2, levels = c(0, 1), direction = "<")
#     pROC::coords(r, "best", ret="threshold", transpose = FALSE)[1]
# }

## ----eval = FALSE, echo = FALSE-----------------------------------------------
# library(OptimalCutpoints)
# library(ThresholdROC)
# library(dplyr)
# n <- 100
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# x_pos <- dat$x[dat$y == 1]
# x_neg <- dat$x[dat$y == 0]
# bench_100 <- microbenchmark::microbenchmark(
#     cutpointr(dat, x, y, pos_class = 1, neg_class = 0,
#               direction = ">=", metric = youden, break_ties = mean),
#     rocr_sensspec(dat$x, dat$y),
#     proc_sensspec(dat$x, dat$y),
#     optimal.cutpoints(X = "x", status = "y", tag.healthy = 0, methods = "Youden",
#                       data = dat),
#     thres2(k1 = x_neg, k2 = x_pos, rho = 0.5,
#            method = "empirical", ci = FALSE),
#     times = 100, unit = "ms"
# )
# 
# n <- 1000
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# x_pos <- dat$x[dat$y == 1]
# x_neg <- dat$x[dat$y == 0]
# bench_1000 <- microbenchmark::microbenchmark(
#     cutpointr(dat, x, y, pos_class = 1, neg_class = 0,
#               direction = ">=", metric = youden, break_ties = mean),
#     rocr_sensspec(dat$x, dat$y),
#     proc_sensspec(dat$x, dat$y),
#     optimal.cutpoints(X = "x", status = "y", tag.healthy = 0, methods = "Youden",
#                       data = dat),
#     thres2(k1 = x_neg, k2 = x_pos, rho = 0.5,
#            method = "empirical", ci = FALSE),
#     times = 100, unit = "ms"
# )
# 
# n <- 10000
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# x_pos <- dat$x[dat$y == 1]
# x_neg <- dat$x[dat$y == 0]
# bench_10000 <- microbenchmark::microbenchmark(
#     cutpointr(dat, x, y, pos_class = 1, neg_class = 0,
#               direction = ">=", metric = youden, break_ties = mean, silent = TRUE),
#     rocr_sensspec(dat$x, dat$y),
#     optimal.cutpoints(X = "x", status = "y", tag.healthy = 0, methods = "Youden",
#                       data = dat),
#     proc_sensspec(dat$x, dat$y),
#     thres2(k1 = x_neg, k2 = x_pos, rho = 0.5,
#            method = "empirical", ci = FALSE),
#     times = 100
# )
# 
# n <- 1e5
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# bench_1e5 <- microbenchmark::microbenchmark(
#     cutpointr(dat, x, y, pos_class = 1, neg_class = 0,
#               direction = ">=", metric = youden, break_ties = mean),
#     rocr_sensspec(dat$x, dat$y),
#     proc_sensspec(dat$x, dat$y),
#     times = 100, unit = "ms"
# )
# 
# n <- 1e6
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# bench_1e6 <- microbenchmark::microbenchmark(
#     cutpointr(dat, x, y, pos_class = 1, neg_class = 0,
#               direction = ">=", metric = youden, break_ties = mean),
#     rocr_sensspec(dat$x, dat$y),
#     proc_sensspec(dat$x, dat$y),
#     times = 30, unit = "ms"
# )
# 
# n <- 1e7
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# bench_1e7 <- microbenchmark::microbenchmark(
#     cutpointr(dat, x, y, pos_class = 1, neg_class = 0,
#               direction = ">=", metric = youden, break_ties = mean),
#     rocr_sensspec(dat$x, dat$y),
#     proc_sensspec(dat$x, dat$y),
#     times = 30, unit = "ms"
# )
# 
# results <- rbind(
#     data.frame(time = summary(bench_100)$median,
#                Solution = summary(bench_100)$expr,
#                n = 100),
#     data.frame(time = summary(bench_1000)$median,
#                Solution = summary(bench_1000)$expr,
#                n = 1000),
#     data.frame(time = summary(bench_10000)$median,
#                Solution = summary(bench_10000)$expr,
#                n = 10000),
#     data.frame(time = summary(bench_1e5)$median,
#                Solution = summary(bench_1e5)$expr,
#                n = 1e5),
#     data.frame(time = summary(bench_1e6)$median,
#                Solution = summary(bench_1e6)$expr,
#                n = 1e6),
#     data.frame(time = summary(bench_1e7)$median,
#                Solution = summary(bench_1e7)$expr,
#                n = 1e7)
# )
# results$Solution <- as.character(results$Solution)
# results$Solution[grep(pattern = "cutpointr", x = results$Solution)] <- "cutpointr"
# results$Solution[grep(pattern = "rocr", x = results$Solution)] <- "ROCR"
# results$Solution[grep(pattern = "optimal", x = results$Solution)] <- "OptimalCutpoints"
# results$Solution[grep(pattern = "proc", x = results$Solution)] <- "pROC"
# results$Solution[grep(pattern = "thres", x = results$Solution)] <- "ThresholdROC"
# 
# results$task <- "Cutpoint Estimation"

## ----echo = FALSE-------------------------------------------------------------
# These are the original results on our system
# dput(results)
results <- structure(list(time = c(4.5018015, 1.812802, 0.662101, 2.2887015, 
1.194301, 4.839401, 2.1764015, 0.981001, 45.0568005, 36.2398515, 
8.5662515, 5.667101, 2538.612001, 4.031701, 2503.8012505, 45.384501, 
43.118751, 37.150151, 465.003201, 607.023851, 583.0950005, 5467.332801, 
7850.2587, 7339.356101), Solution = c("cutpointr", "ROCR", "pROC", 
"OptimalCutpoints", "ThresholdROC", "cutpointr", "ROCR", "pROC", 
"OptimalCutpoints", "ThresholdROC", "cutpointr", "ROCR", "OptimalCutpoints", 
"pROC", "ThresholdROC", "cutpointr", "ROCR", "pROC", "cutpointr", 
"ROCR", "pROC", "cutpointr", "ROCR", "pROC"), n = c(100, 100, 
100, 100, 100, 1000, 1000, 1000, 1000, 1000, 10000, 10000, 10000, 
10000, 10000, 1e+05, 1e+05, 1e+05, 1e+06, 1e+06, 1e+06, 1e+07, 
1e+07, 1e+07), task = c("Cutpoint Estimation", "Cutpoint Estimation", 
"Cutpoint Estimation", "Cutpoint Estimation", "Cutpoint Estimation", 
"Cutpoint Estimation", "Cutpoint Estimation", "Cutpoint Estimation", 
"Cutpoint Estimation", "Cutpoint Estimation", "Cutpoint Estimation", 
"Cutpoint Estimation", "Cutpoint Estimation", "Cutpoint Estimation", 
"Cutpoint Estimation", "Cutpoint Estimation", "Cutpoint Estimation", 
"Cutpoint Estimation", "Cutpoint Estimation", "Cutpoint Estimation", 
"Cutpoint Estimation", "Cutpoint Estimation", "Cutpoint Estimation", 
"Cutpoint Estimation")), row.names = c(NA, -24L), class = "data.frame")

## ----eval = FALSE-------------------------------------------------------------
# # ROCR package
# rocr_roc <- function(x, class) {
#     pred <- ROCR::prediction(x, class)
#     perf <- ROCR::performance(pred, "sens", "spec")
#     return(NULL)
# }
# 
# # pROC package
# proc_roc <- function(x, class) {
#     r <- pROC::roc(class, x, algorithm = 2, levels = c(0, 1), direction = "<")
#     return(NULL)
# }

## ----eval = FALSE, echo = FALSE-----------------------------------------------
# n <- 100
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# bench_100 <- microbenchmark::microbenchmark(
#     cutpointr::roc(dat, "x", "y", pos_class = 1,
#                    neg_class = 0, direction = ">="),
#     rocr_roc(dat$x, dat$y),
#     proc_roc(dat$x, dat$y),
#     times = 100, unit = "ms"
# )
# n <- 1000
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# bench_1000 <- microbenchmark::microbenchmark(
#     cutpointr::roc(dat, "x", "y", pos_class = 1, neg_class = 0,
#                    direction = ">="),
#     rocr_roc(dat$x, dat$y),
#     proc_roc(dat$x, dat$y),
#     times = 100, unit = "ms"
# )
# n <- 10000
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# bench_10000 <- microbenchmark::microbenchmark(
#     cutpointr::roc(dat, "x", "y", pos_class = 1, neg_class = 0,
#                    direction = ">="),
#     rocr_roc(dat$x, dat$y),
#     proc_roc(dat$x, dat$y),
#     times = 100, unit = "ms"
# )
# n <- 1e5
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# bench_1e5 <- microbenchmark::microbenchmark(
#     cutpointr::roc(dat, "x", "y", pos_class = 1, neg_class = 0,
#                    direction = ">="),
#     rocr_roc(dat$x, dat$y),
#     proc_roc(dat$x, dat$y),
#     times = 100, unit = "ms"
# )
# n <- 1e6
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# bench_1e6 <- microbenchmark::microbenchmark(
#     cutpointr::roc(dat, "x", "y", pos_class = 1, neg_class = 0,
#                    direction = ">="),
#     rocr_roc(dat$x, dat$y),
#     proc_roc(dat$x, dat$y),
#     times = 30, unit = "ms"
# )
# n <- 1e7
# set.seed(123)
# dat <- data.frame(x = rnorm(n), y = sample(c(0:1), size = n, replace = TRUE))
# bench_1e7 <- microbenchmark::microbenchmark(
#     cutpointr::roc(dat, "x", "y", pos_class = 1, neg_class = 0,
#                    direction = ">="),
#     rocr_roc(dat$x, dat$y),
#     proc_roc(dat$x, dat$y),
#     times = 30, unit = "ms"
# )
# 
# results_roc <- rbind(
#     data.frame(time = summary(bench_100)$median,
#                Solution = summary(bench_100)$expr,
#                n = 100),
#     data.frame(time = summary(bench_1000)$median,
#                Solution = summary(bench_1000)$expr,
#                n = 1000),
#     data.frame(time = summary(bench_10000)$median,
#                Solution = summary(bench_10000)$expr,
#                n = 10000),
#     data.frame(time = summary(bench_1e5)$median,
#                Solution = summary(bench_1e5)$expr,
#                n = 1e5),
#     data.frame(time = summary(bench_1e6)$median,
#                Solution = summary(bench_1e6)$expr,
#                n = 1e6),
#     data.frame(time = summary(bench_1e7)$median,
#                Solution = summary(bench_1e7)$expr,
#                n = 1e7)
# )
# results_roc$Solution <- as.character(results_roc$Solution)
# results_roc$Solution[grep(pattern = "cutpointr", x = results_roc$Solution)] <- "cutpointr"
# results_roc$Solution[grep(pattern = "rocr", x = results_roc$Solution)] <- "ROCR"
# results_roc$Solution[grep(pattern = "proc", x = results_roc$Solution)] <- "pROC"
# results_roc$task <- "ROC curve calculation"

## ----echo = FALSE-------------------------------------------------------------
# Our results
results_roc <- structure(list(time = c(0.7973505, 1.732651, 0.447701, 0.859301, 
2.0358515, 0.694802, 1.878151, 5.662151, 3.6580505, 11.099251, 
42.8208515, 35.3293005, 159.8100505, 612.471901, 610.4337005, 
2032.693551, 7806.3854515, 7081.897251), Solution = c("cutpointr", 
"ROCR", "pROC", "cutpointr", "ROCR", "pROC", "cutpointr", "ROCR", 
"pROC", "cutpointr", "ROCR", "pROC", "cutpointr", "ROCR", "pROC", 
"cutpointr", "ROCR", "pROC"), n = c(100, 100, 100, 1000, 1000, 
1000, 10000, 10000, 10000, 1e+05, 1e+05, 1e+05, 1e+06, 1e+06, 
1e+06, 1e+07, 1e+07, 1e+07), task = c("ROC curve calculation", 
"ROC curve calculation", "ROC curve calculation", "ROC curve calculation", 
"ROC curve calculation", "ROC curve calculation", "ROC curve calculation", 
"ROC curve calculation", "ROC curve calculation", "ROC curve calculation", 
"ROC curve calculation", "ROC curve calculation", "ROC curve calculation", 
"ROC curve calculation", "ROC curve calculation", "ROC curve calculation", 
"ROC curve calculation", "ROC curve calculation")), row.names = c(NA, 
-18L), class = "data.frame")

## ----echo = FALSE-------------------------------------------------------------
library(ggplot2)
results_all <- dplyr::bind_rows(results, results_roc)

ggplot(results_all, aes(x = n, y = time, col = Solution, shape = Solution)) +
  geom_point(size = 3) + geom_line() +
  scale_y_log10(breaks = c(0.5, 1, 2, 3, 5, 10, 25, 100, 250, 1000, 5000, 1e4, 15000)) +
  scale_x_log10(breaks = c(100, 1000, 1e4, 1e5, 1e6, 1e7)) +
  ylab("Median Time (milliseconds, log scale)") + xlab("Sample Size (log scale)") +
  theme_bw() +
  theme(legend.position = "bottom", 
        legend.key.width = unit(0.8, "cm"), 
        panel.spacing = unit(1, "lines")) +
  facet_grid(~task)

## ----echo = FALSE-------------------------------------------------------------
library(tidyr)
res_table <- tidyr::spread(results_all, Solution, time)
res_table <- dplyr::arrange(res_table, task)
knitr::kable(res_table)

