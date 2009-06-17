\name{nifti.image.new}
\alias{nifti.image.new}
\title{Create new NIfTI image}
\description{
  Basic initialization of a nifti.image structure (to a 1x1x1 image)
}
\usage{
nifti.image.new() 
}
\details{
Creates an image of size 1x1x1. 
}
\value{
a \code{\link{nifti}} object
}
\references{
  \url{http://nifti.nimh.nih.gov}
  \url{http://niftilib.sourceforge.net}
}
\author{
  Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}

\seealso{ 
  \code{\link{nifti.image.write}},
  \code{\link{nifti.image.read}}
}

\examples{
nifti.img=nifti.image.new()
}
\keyword{manip}
\keyword{data}
