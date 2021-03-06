% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/01-hdnom-models.R
\name{hdcox.flasso}
\alias{hdcox.flasso}
\title{Fused Lasso Model Selection for High-Dimensional Cox Models}
\usage{
hdcox.flasso(x, y, nfolds = 5L, lambda1 = c(0.001, 0.05, 0.5, 1, 5),
  lambda2 = c(0.001, 0.01, 0.5), maxiter = 25, epsilon = 0.001,
  seed = 1001, trace = FALSE, parallel = FALSE, ...)
}
\arguments{
\item{x}{Data matrix.}

\item{y}{Response matrix made by \code{\link[survival]{Surv}}.}

\item{nfolds}{Fold numbers of cross-validation.}

\item{lambda1}{Vector of lambda1 candidates.
Default is \code{0.001, 0.05, 0.5, 1, 5}.}

\item{lambda2}{Vector of lambda2 candidates.
Default is \code{0.001, 0.01, 0.5}.}

\item{maxiter}{The maximum number of iterations allowed.
Default is \code{25}.}

\item{epsilon}{The convergence criterion.
Default is \code{1e-3}.}

\item{seed}{A random seed for cross-validation fold division.}

\item{trace}{Output the cross-validation parameter tuning
progress or not. Default is \code{FALSE}.}

\item{parallel}{Logical. Enable parallel parameter tuning or not,
default is {FALSE}. To enable parallel tuning, load the
\code{doParallel} package and run \code{registerDoParallel()}
with the number of CPU cores before calling this function.}

\item{...}{other parameters to \code{\link[penalized]{cvl}}
and \code{\link[penalized]{penalized}}.}
}
\description{
Automatic fused lasso model selection for high-dimensional
Cox models, evaluated by cross-validated likelihood.
}
\note{
The cross-validation procedure used in this function is the
\emph{approximated cross-validation} provided by the \code{penalized}
package. Be careful dealing with the results since they might be more
optimistic than a traditional CV procedure. This cross-validation
method is more suitable for datasets with larger number of observations,
and a higher number of cross-validation folds.
}
\examples{
library("survival")
library("rms")

# Load imputed SMART data; only use the first 120 samples
data("smart")
x = as.matrix(smart[, -c(1, 2)])[1:120, ]
time = smart$TEVENT[1:120]
event = smart$EVENT[1:120]
y = Surv(time, event)

# Fit Cox model with fused lasso penalty
fit = hdcox.flasso(x, y,
  lambda1 = c(1, 10), lambda2 = c(0.01),
  nfolds = 3, seed = 11)

# Prepare data for hdnom.nomogram
x.df = as.data.frame(x)
dd = datadist(x.df)
options(datadist = "dd")

# Generate hdnom.nomogram objects and plot nomogram
nom = hdnom.nomogram(
  fit$flasso_model, model.type = "flasso",
  x, time, event, x.df, pred.at = 365 * 2,
  funlabel = "2-Year Overall Survival Probability")

plot(nom)
}
