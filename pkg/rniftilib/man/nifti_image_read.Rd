\name{nifti_image_read}
\alias{nifti_image_read}
\title{Read data from nifti (analyse) files}
\description{
  This function reads the data from a nifti file into the R environment.
}
\usage{
nifti_image_read(file, read_data=1) 
}
\arguments{
  \item{file}{the name of the analyse file}
  \item{read_data}{0=do not read data, 1=read data}
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
\code{\link{nifti_image_write}  \link{nifti_image_new}}
}

\examples{
library(Rniftilib)
nifti_img=nifti_image_read(file.choose())

# access to attributes...
nifti_img$qto_xyz #
nifti_img$qto_ijk # hold voxel to mm transformation (?)
nifti_img$sto_xyz #
nifti_img$sto_ijk #
nifti_img$toffset #
nifti_img$descrip # hold description
nifti_img$fname # header filename (store image information)
nifti_img$iname # image filename (store image data)
nifti_img$slice_duration #
}
\keyword{interface}
