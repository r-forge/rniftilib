\name{nifti.image.copy.info}
\alias{nifti.image.copy.info}
\title{Copy NIFTI image (info) without voxel data.}
\description{
Copy the nifti.image structure, without data.

Duplicate the structure, including fname, iname and extensions.
Leave the data pointer as NULL.
}
\usage{
nifti.image.copy.info(nim) 
}
\arguments{
 \item{nim}{the nifti object}
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
  \code{\link{nifti.image.read}},
  \code{\link{nifti.image.write}}
}

\examples{
\dontrun{
nim <- nifti.image.read(file.choose())
nim_copy <- nifti.image.copy.info(nim)
}
}
\keyword{manip}
