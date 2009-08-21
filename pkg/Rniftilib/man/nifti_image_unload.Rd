\name{nifti.image.unload}
\alias{nifti.image.unload}
\title{Unload NIfTI image data}
\description{
Unload the image data in nifti struct, but keep the metadata.
}
\usage{
nifti.image.unload(nim) 
}
\arguments{
 \item{nim}{the nifti object}
}
\details{
Unload image data, but keep header information and other metadata.
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
  \code{\link{nifti.image.free}}
}

\keyword{manip}
\keyword{data}