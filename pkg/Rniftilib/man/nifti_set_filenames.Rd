\name{nifti.set.filenames}
\alias{nifti.set.filenames}
\title{Set filenames for a NIFTI image}
\description{
  Set filenames (image and header filename) for a NIfTI image.
}
\usage{
nifti.set.filenames(nim, prefix, check=1, set_byte_order=1)
}
\arguments{
  \item{nim}{the nifti object}
  \item{prefix}{(required) prefix for output filenames}
  \item{check}{check for previous existence of filename (existence is an
    error condition)}
  \item{set_byte_order}{flag to set nim->byteorder here (if
    set\_byte\_order=1 then byteorder is set based on the CPU type)}
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
  \code{\link{nifti.image.read}},
  \code{\link{nifti.image.new}}
}
\examples{
nifti.img <- nifti.image.new()
nifti.set.filenames(nifti.img, "testvolume")
# show the result
nifti.img$fname
nifti.img$iname
}
\keyword{manip}
