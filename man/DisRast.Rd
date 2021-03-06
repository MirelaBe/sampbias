\name{DisRast}
\alias{DisRast}

\title{
Distance Rasters from a List of Geographic Gazeteers
}
\description{
Creates a list of distances rasters based on a list of geographic gazetteers, as SpatialPoints or SpatialLines objects, and a template raster, indicating the desired extent and resolution
}
\usage{
DisRast(gaz, ras, buffer = NULL, ncores = 1)
}

\arguments{
  \item{gaz}{
 an object of the class \code{list}, including one or more geographic gazeteers of the class \code{SpatialPointsDataFrame} or \code{SpatialLinesDataFrame}.
}
  \item{ras}{
an object of the class \code{raster}. Defining the extent and resolution of the distances rasters.
}
  \item{buffer}{
 numerical.  The size of the geographic buffer  around the extent of ras for the distance calculations in degrees, to account for geographic structures neighbouring the study area (such as a road right outside the study area)  Default is to the resolution of \code{ras}.
}
  \item{ncores}{
numerical.  The number of cores used for parallel computing. Must be lower than the available number of cores. Not finally implemented in version 0.1.0.
}
}

\value{
a \code{list} of \code{raster} objects of the same length as \code{gaz}. The values in each raster correspond to the planar geographic distance to the next feature in \code{gaz}, given the resolution of \code{ras}
}
\note{
Check https://github.com/azizka/sampbias/wiki for a tutorial on sampbias.
}

\seealso{
\code{\link{SamplingBias}}
}
\examples{
#create raster for resolution and extent
ras <- raster(extent(-5,5,-4,4), res = 1)

#create point gazeteer
pts <- data.frame(long = runif(n = 5, min = -5, max = 5),
                  lat = runif(n = 5, min = -4, max = 4),
                  dat = rep("A", 5))

pts <- SpatialPointsDataFrame(coords = pts[,1:2], data = data.frame(pts[,3]))

lin <- data.frame(long = seq(-5, 5, by = 1),
                  lat = rep(2, times = 11))
lin <- SpatialLinesDataFrame(sl = SpatialLines(list(Lines(Line(lin), ID="B1"))),
                             data = data.frame("B", row.names = "B1"))

gaz <- list(point.structure = pts, lines.strucutre = lin)

out <- DisRast(gaz, ras)

\dontrun{plot(out[[1]])}
}

\keyword{ spatial }

