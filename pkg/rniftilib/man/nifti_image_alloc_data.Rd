\name{nifti_image_alloc_data}
\alias{nifti_image_alloc_data}
\title{Allocate data block for NIFTI image}
\description{
Allocate data block for NIFTI image using the information from the header.
}
\usage{
nifti_image_alloc_data(nim)
}
\arguments{
\item{nim}{the nifti object}
}
\details{
The function return the number of bytes allocated.
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
\code{\link{nifti_image_new} \link{nifti_image_write} \link{nifti_image_read}}
}

\examples{
library(Rniftilib);
nifti_img=nifti_image_new();
no_of_bytes=nifti_image_alloc_data(nifti_img);
}
\keyword{nifti_image_alloc_data}
