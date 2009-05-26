\name{nifti_image_write}
\alias{nifti_image_write}
\title{Write data to nifti (analyse) files}
\description{
  This function writes volume data to a nifti file.
}
\usage{
nifti_image_write(nim) 
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
Oliver Granert <o.granert@neurologie.uni-kiel.de>
}

\seealso{
\code{\link{nifti_image_read} \link{nifti_image_new}}
}

\examples{
library(Rniftilib);
nifti_img=nifti_image_read(file.choose());
nifti_image_write(nifti_img);
}
\keyword{interface}
