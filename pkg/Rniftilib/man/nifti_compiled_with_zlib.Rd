\name{nifti.compiled.with.zlib}
\alias{nifti.compiled.with.zlib}
\title{Check support for compressed NIfTI files.}
\description{
Return whether the given Rniftilib C-library was compiled with \code{HAVE_ZLIB} set.
}
\usage{
nifti.compiled.with.zlib()
}
\value{
 \item{TRUE}{library supports compressed files (.gz)} 
 \item{FALSE}{compressed files are not supported} 
}
\references{
  \url{http://nifti.nimh.nih.gov}
  \url{http://niftilib.sourceforge.net}
}
\seealso{ 
  \code{\link{nifti.image.new}},
  \code{\link{nifti.image.write}},
  \code{\link{nifti.image.read}}
}

\examples{
nifti.compiled.with.zlib() # return logical value (TRUE or FALSE)
}
\keyword{manip}
\keyword{data}