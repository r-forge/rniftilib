\name{nifti.datatype.string}
\alias{nifti.datatype.string}
\title{Return string for NIfTI-1 datatype code value.}
\description{
Return a string for the datatype of a NIFTI data type.
}
\usage{
nifti.datatype.string(value) 
}
\arguments{
 \item{value}{NIfTI-1 datatype}
}
\details{
Return a string for the datatype of a NIFTI data type (e.g. "INT8" signed integer data type).   
}
\value{
String for the given data type value.
}
\references{
  \url{http://nifti.nimh.nih.gov}
  \url{http://niftilib.sourceforge.net}
}

\seealso{ 
  \code{\link{nifti.units.string}},
  \code{\link{nifti.image.write}},
  \code{\link{nifti.image.read}}
}

\keyword{manip}
\keyword{data}
