\name{nifti_set_filenames}
\alias{nifti_set_filenames}
\title{Set filenames for a NIFTI image.}
\description{
Set filenames (image and header filename) for a NIFTI image.
}
\usage{
nifti_set_filenames(nim, prefix, check=1, set_byte_order=1)
}
\arguments{
\item{nim}{the nifti object}
\item{prefix}{(required) prefix for output filenames}
\item{check}{check for previous existence of filename (existence is an error condition)}
\item{set_byte_order}{flag to set nim->byteorder here (if set_byte_order=1 then byteorder is set based on the CPU type)}
}
\details{
}
\value{

}
\references{
\url{http://nifti.nimh.nih.gov}
\url{http://niftilib.sourceforge.net}
}
\author{
Oliver Granert <o.granert@neurologie.uni-kiel.de>
}

\seealso{ 
\code{\link{nifti_image_write} \link{nifti_image_read} \link{nifti_image_new}}
}

\examples{
library(Rniftilib)
nifti_img=nifti_image_new()
nifti_set_filenames(nifti_img,"testvolume");
# show the result
nifti_img$fname
nifti_img$iname
}
\keyword{nifti_set_filenames}
