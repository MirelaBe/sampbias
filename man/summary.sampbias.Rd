\name{summary.sampbias}
\alias{summary.sampbias}

\title{
Summary Method for Class sampbias
}
\description{
Summary method for objects of the class \code{sampbias}.
}
\usage{
\method{summary}{sampbias}(object, ...)
}

\arguments{
  \item{object}{
An object of the class \code{sampbias}
}
  \item{\dots}{
Additional arguments passed to summary.
}
}

\value{
Summary printed to screen.
}

\seealso{
\code{\link{SamplingBias}}
\code{\link{is.sampbias}}
\code{\link{plot.sampbias}}
}
\examples{
#simulate data
occ <- data.frame(species = rep(sample(x = LETTERS, size = 5), times = 10),
                  decimallongitude = runif(n = 50, min = -5, max = 5),
                  decimallatitude = runif(n = 50, min = -4, max = 4))


#create point gazetteer
pts <- data.frame(long = runif(n = 5, min = -5, max = 5),
                  lat = runif(n = 5, min = -4, max = 4),
                  dat = rep("A", 5))
pts <- SpatialPointsDataFrame(coords = pts[,1:2], data = data.frame(pts[,3]))

lin <- data.frame(long = seq(-5, 5, by = 1),
                  lat = rep(2, times = 11))
lin <- SpatialLinesDataFrame(sl = SpatialLines(list(Lines(Line(lin), ID="B1"))),
                             data = data.frame("B", row.names = "B1"))

gaz <- list(lines.strucutre = lin, point.structure = pts)

out <- SamplingBias(x = occ, gaz = gaz, terrestrial = FALSE)
summary(out)
}

\keyword{ methods }
