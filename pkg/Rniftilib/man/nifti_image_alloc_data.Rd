\name{nifti.image.alloc.data}
\alias{nifti.image.alloc.data}
\title{Allocate data block for NIfTI image}
\description{
Allocate data block for NIfTI image using the information from the header.
}
\usage{
nifti.image.alloc.data(nim)
}
\arguments{
  \item{nim}{the nifti object}
}
\details{
  The function return the number of bytes allocated.
}
\references{
  \url{http://nifti.nimh.nih.gov}
  \url{http://niftilib.sourceforge.net}
}
\author{
  Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}

\seealso{ 
  \code{\link{nifti.image.new}},
  \code{\link{nifti.image.write}},
  \code{\link{nifti.image.read}}
}

\examples{
nim=nifti.image.new()
no.of.bytes=nifti.image.alloc.data(nim)
}
\keyword{manip}
\keyword{data}
