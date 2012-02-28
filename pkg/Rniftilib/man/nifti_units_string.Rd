\name{nifti.units.string}
\alias{nifti.units.string}
\title{Return string for NIfTI-1 unit code value.}
\description{
Return a string holding the name of a NIFTI units type.
}
\usage{
nifti.units.string(value) 
}
\arguments{
 \item{value}{NIfTI-1 unit code}
}
\details{
Return a string holding the name of a NIFTI units type.    
}
\value{
String for the given unit type value.
}
\references{
  \url{http://nifti.nimh.nih.gov}
  \url{http://niftilib.sourceforge.net}
}

\seealso{ 
  \code{\link{nifti.datatype.string}},
  \code{\link{nifti.image.write}},
  \code{\link{nifti.image.read}}
}

\keyword{manip}
\keyword{data}
