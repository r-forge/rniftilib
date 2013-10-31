\name{nifti.image.new}
\alias{nifti.image.new}
\title{Create new NIfTI image}
\description{
  Create a new nifti object with basic initialization of a nifti structure (1x1x1 volume).
}
\usage{
nifti.image.new() 
}
\details{
Creates a new volume image (nifti object) of size 1x1x1. 
}
\value{
A \code{\link{nifti}} object
}
\references{
  \url{http://nifti.nimh.nih.gov}
  \url{http://niftilib.sourceforge.net}
}
\author{
  Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}

\seealso{ 
  \code{\link{nifti.image.alloc.data}},
  \code{\link{nifti.set.filenames}},
  \code{\link{nifti.image.write}},
  \code{\link{nifti.image.read}}
}

\examples{
# create 1x1x1 nifti volume
nim=nifti.image.new() 
# resize nifti volume to 15x15x15 
nim$dim<-c(15,15,15) 
}
\keyword{manip}
\keyword{data}
