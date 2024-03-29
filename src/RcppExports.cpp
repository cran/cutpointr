// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// any_inf
bool any_inf(NumericVector x);
RcppExport SEXP _cutpointr_any_inf(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(any_inf(x));
    return rcpp_result_gen;
END_RCPP
}
// get_rev_dups
LogicalVector get_rev_dups(NumericVector x);
RcppExport SEXP _cutpointr_get_rev_dups(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(get_rev_dups(x));
    return rcpp_result_gen;
END_RCPP
}
// is_equal_cpp_char
LogicalVector is_equal_cpp_char(CharacterVector x, String y);
RcppExport SEXP _cutpointr_is_equal_cpp_char(SEXP xSEXP, SEXP ySEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< CharacterVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< String >::type y(ySEXP);
    rcpp_result_gen = Rcpp::wrap(is_equal_cpp_char(x, y));
    return rcpp_result_gen;
END_RCPP
}
// is_equal_cpp_num
LogicalVector is_equal_cpp_num(NumericVector x, double y);
RcppExport SEXP _cutpointr_is_equal_cpp_num(SEXP xSEXP, SEXP ySEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type y(ySEXP);
    rcpp_result_gen = Rcpp::wrap(is_equal_cpp_num(x, y));
    return rcpp_result_gen;
END_RCPP
}
// one_unique_num
LogicalVector one_unique_num(NumericVector x);
RcppExport SEXP _cutpointr_one_unique_num(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(one_unique_num(x));
    return rcpp_result_gen;
END_RCPP
}
// one_unique_char
LogicalVector one_unique_char(CharacterVector x);
RcppExport SEXP _cutpointr_one_unique_char(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< CharacterVector >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(one_unique_char(x));
    return rcpp_result_gen;
END_RCPP
}
// which_are_num
IntegerVector which_are_num(NumericVector x, double a);
RcppExport SEXP _cutpointr_which_are_num(SEXP xSEXP, SEXP aSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type a(aSEXP);
    rcpp_result_gen = Rcpp::wrap(which_are_num(x, a));
    return rcpp_result_gen;
END_RCPP
}
// which_are_char
IntegerVector which_are_char(CharacterVector x, String a);
RcppExport SEXP _cutpointr_which_are_char(SEXP xSEXP, SEXP aSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< CharacterVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< String >::type a(aSEXP);
    rcpp_result_gen = Rcpp::wrap(which_are_char(x, a));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_cutpointr_any_inf", (DL_FUNC) &_cutpointr_any_inf, 1},
    {"_cutpointr_get_rev_dups", (DL_FUNC) &_cutpointr_get_rev_dups, 1},
    {"_cutpointr_is_equal_cpp_char", (DL_FUNC) &_cutpointr_is_equal_cpp_char, 2},
    {"_cutpointr_is_equal_cpp_num", (DL_FUNC) &_cutpointr_is_equal_cpp_num, 2},
    {"_cutpointr_one_unique_num", (DL_FUNC) &_cutpointr_one_unique_num, 1},
    {"_cutpointr_one_unique_char", (DL_FUNC) &_cutpointr_one_unique_char, 1},
    {"_cutpointr_which_are_num", (DL_FUNC) &_cutpointr_which_are_num, 2},
    {"_cutpointr_which_are_char", (DL_FUNC) &_cutpointr_which_are_char, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_cutpointr(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
