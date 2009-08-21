\name{nifti.image.free}
\alias{nifti.image.free}
\title{Free NIfTI image data structure}
\description{
Free image data (everything!).
}
\usage{
nifti.image.free(nim) 
}
\arguments{
 \item{nim}{the nifti object}
}
\details{
Free 'everything' about a nifti struct (including the passed struct):
(fname and iname, data, extensions, nim)
}
\value{
A \code{\link{nifti}} object
}
\references{
  \url{http://nifti.nimh.nih.gov}
  \url{http://niftilib.sourceforge.net}
}

\seealso{ 
  \code{\link{nifti.image.write}},
  \code{\link{nifti.image.read}}
  \code{\link{nifti.image.unload}}
}

\keyword{manip}
\keyword{data}