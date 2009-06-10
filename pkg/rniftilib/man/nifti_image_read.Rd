\name{nifti.image.read}
\alias{nifti.image.read}
\title{Read data from NIfTI (Analyze) files}
\description{
  This function reads the data from a nifti file into the R
  environment.
}
\usage{
nifti.image.read(file, read_data=1) 
}
\arguments{
  \item{file}{the name of the nifti file}
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
  Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}

\seealso{ 
  \code{\link{nifti.image.write}},
  \code{\link{nifti.image.new}}
}
\examples{
\dontrun{
nifti.img <- nifti.image.read(file.choose())
# access to attributes...
nifti.img$"qto_xyz"     #
nifti.img$"qto_ijk"     # hold voxel to mm transformation (?)
nifti.img$"sto_xyz"     #
nifti.img$"sto_ijk"     #
nifti.img$"toffset"     #
nifti.img$"descrip"     # hold description
nifti.img$"fname"       # header filename (store image information)
nifti.img$"iname"       # image filename (store image data)
nifti.img$"slice_duration"
}
}
\keyword{IO}
