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
If \code{read_data=0} only the header info is loaded.  
}
\value{
\code{\link{nifti}} object
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
nifti.img$qto.xyz        # voxel to mm transformation matrix (q-form)
nifti.img$qto.ijk        # mm to voxel transformation matrix (q-form)
nifti.img$sto.xyz        # voxel to mm transformation matrix (s-form)
nifti.img$sto.ijk        # mm to voxel transformation matrix (s-form)
nifti.img$toffset        #
nifti.img$descrip        # description
nifti.img$fname          # header filename (store image information)
nifti.img$iname          # image filename (store image data)
nifti.img$slice.duration
# access to voxel values...
nifti.img[10,11,12]      # voxel value at x=10, y=11, z=12
}
}
\keyword{IO}
