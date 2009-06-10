\name{CreateVOIMask}
\alias{CreateVOIMask}
\title{Create a mask (VOI) image.}
\description{
  Create a mask in an image volume (NIfTI-image object). 
}
\usage{
CreateVOIMask(templatefile=file.choose(), output_basefilename, MNI, radius)
}
\arguments{
 \item{templatefile}{file name of image volume used as template}
 \item{output_basefilename}{base file name for mask image volume}
 \item{MNI}{centre coordinate vector in MNI space (mm)}
 \item{radius}{radius of VOI}
}
\references{
\url{http://nifti.nimh.nih.gov}
\url{http://niftilib.sourceforge.net}
}
\author{
Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}
\seealso{ 
  \code{\link{nifti_image_read}},
  \code{\link{nifti_image_write}},
  \code{\link{nifti_image_new}}
}
\examples{
\dontrun{
 ## create mask at MNI coordinate [-22 33 44] and radius 2
 CreateVOIMask(templatefile=file.choose(),output_basefilename="C:\\\\maskimg_-22_33_44",c(-22,33,44),2)
}
}
