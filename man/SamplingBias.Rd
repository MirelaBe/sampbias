\name{SamplingBias}
\alias{SamplingBias}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Evaluating Sampling Bias in Species Distribution Data
}
\description{
The major function of the package, calculating the bias effect of sampling bias due to geographic structures, such as the vicinity to cities, airports, rivers and roads. Results are projected to space, and can be compared numerically.
}
\usage{
SamplingBias(x, gaz = NULL, res = 1, buffer = NULL, convexhull = F, terrestrial = T,
             binsize = NULL, biasdist = c(0, 10000), ncores = 1, plotextra = F,
             plotextrafile = "samp_bias_extra_plots.pdf", verbose = T)
}

\arguments{
  \item{x}{
an object of the class \code{data.frame}, with one species occurrence record per line, and at least three columns, named \sQuote{species}, \sQuote{decimallongitude}, and \sQuote{decimallatitude}.
}
  \item{gaz}{
a list of geographic gazetteers as \code{SpatialPointDataFrame} or \code{SpatialLinesDataFrame}.  If NULL, a set of default gazetteers, representing large scale occurrence of airports, cities, rivers and roads is used.  See Details.
}
  \item{res}{
numerical.  The raster resolution for the distance calculation to the geographic features and the data visualization, in decimal degrees. The default is to one degree, but higher resolution will be desirable for most analyses. Res together with the extent of the input data determine computation time and memory requirements.
}
  \item{buffer}{
 numerical.  The size of the geographic buffer around the extent of \code{ras} for the distance calculations in degrees, to account for geographic structures neighbouring the study area (such as a road right outside the study area). Should be a multiple of res.  Default is to res. See Details.
}
  \item{convexhull}{
logical.  If TRUE, the empirical distribution (and the output maps) is restricted to cells within a convex hull polygon around \code{x}. If FALSE a rectangle around \code{x} is used.  Default = FALSE.
}
  \item{terrestrial}{
logical.  If TRUE, the empirical distribution (and the output maps) are restricted to terrestrial areas.  Uses the \code{\link{landmass}} to define what is terrestrial.  Default = TRUE.
}
  \item{binsize}{
numerical.  Indicating the distance bin size (in meters!) for approximating the empirical and observed sample distributions. Should be slightly larger than res (which is in degrees). Default = res * 100000 * 1.1.
}
  \item{biasdist}{
numerical.  A vector indicating the distance at which the average bias should be calculated for the output table (in meters). Can also be a single number.  See details.  Default = c(0, 10000).
}
  \item{ncores}{
numerical.  The number of cores used for parallel computing. Must be lower than the available number of cores. Not finally implemented in version 0.1.0.
}
  \item{plotextra}{
logical. logical. If TRUE, creates a .pdf file with plots of the statistical distance distributions and bias effects
}
  \item{plotextrafile}{
character.  The full path where the extra plot should be saved.
}
  \item{verbose}{
logical.  If TRUE, progress is reported.  Default = TRUE.
}
}
\details{
The default gazetteers delivered with the package are simplified from http://www.naturalearthdata.com/downloads/. They include major features, and for small scale analyses custom gazetteers should be used.

For computational convenience, the gazetteers are cropped to the extent of the point occurrence data sets. To account for the fact, that, relevant structures might lay directly outside this extent, but still influencing the distribution of samples in the study area, the buffer option, gives the area, around the extent that should be included in the distance calculation.

The \code{biasdist} options defines at which distance the bias effect should be recorded. These values are comparable between different biasing factors and give an estimate of bias severity. For instance, if \code{biasdist} = c(0, 10000), the \code{biastable} will indicate the bias effect at distances 0 and 10000 meters from all sources of bias. The bias effect is the fraction of samples expected to be missed at a given distance relative to distance 0.  A high bias effect means a high fraction of missed records. The fractions are comparable between sources of bias and different datasets and the bias at any given distance can thus inform on the relative severity of a biasing source.

Visit \link{https://github.com/azizka/sampbias/wiki} for more information on distance calculation and the math behind sampbias.

}
\value{
An object of the S3-class \sQuote{sampbias}, which is a list including the following objects:
\item{summa}{A list of summary statistics for the sampbias analyses, including the total number of occurrence points in \code{x}, the total number of species in \code{x}, the extent of the output rasters as well as the settings for \code{res}, \code{binsize}, and \code{convexhull} used in the analyses.}
\item{occurrences}{a \code{raster} indicating occurrence records per grid cell, with resolution res.}
\item{species}{a \code{raster} with indicating the number of species per grid cell, with resolution res.}
\item{biasmaps}{a list of \code{rasters}, with the same length as gaz. Each element is the spatial projection of the bias effect for a sources of bias in \code{gaz}. The last raster in the list is the average over all bias sources.}
\item{biastable}{a \code{data.frame}, with the estimated bias effect for each bias source in \code{gaz}, at the distances specified by \code{biasdist}.}
}

\note{
Check https://github.com/azizka/sampbias/wiki for a tutorial on sampbias.
}


\seealso{
\code{\link{summary.sampbias}}
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

\keyword{ maths }
\keyword{ spatial }
