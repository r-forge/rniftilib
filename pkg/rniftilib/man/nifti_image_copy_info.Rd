\name{nifti_image_copy_info}
\alias{nifti_image_copy_info}
\title{Copy NIFTI image (info) without voxel data.}
\description{
Copy the nifti.image structure, without data.

Duplicate the structure, including fname, iname and extensions.
Leave the data pointer as NULL.
}
\usage{
nifti_image_copy_info(nim) 
}
\arguments{
 \item{nim}{the nifti object}
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
Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}

\seealso{ 
\code{\link{nifti_image_new} \link{nifti_image_read} \link{nifti_image_write}}
}

\examples{
\dontrun{
library(Rniftilib)
nifti_img1=nifti_image_read(file.choose())
nifti_img2=nifti_image_copy_info(nifti_img1)
}
}
\keyword{manip}
