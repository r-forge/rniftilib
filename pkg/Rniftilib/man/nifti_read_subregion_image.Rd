\name{nifti.read.subregion.image}
\alias{nifti.read.subregion.image}
\title{Read a subregion from a NIfTI image}
\description{
EXPERIMENTAL (unstable interface!): Read a single arbitary subregion of any rectangular size from a NIfTI dataset.
}
\usage{
nifti.read.subregion.image(nim, start_index, region_size)
}
\arguments{
 \item{nim}{the nifti object}
 \item{start_index}{start_index the index location of the first voxel that will be returned}
 \item{region_size}{region_size the size of the subregion to be returned}
}
\details{
 This function may be used to read a single arbitary subregion of any
 rectangular size from a nifti dataset, such as a small 5x5x5 subregion
 around the center of a 3D image.

    Example: given  nim$dim = c(64, 64, 64) (3-D dataset)

      if start_index = c( 29,  29, 29) and
         region_size = c( 5,   5,  5)
         -> read 5x5x5 region starting with the first voxel location at (29,29,29)
}
\value{
The subregion data in a vector.
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
  \code{\link{nifti.image.read}}
}

\keyword{manip}
\keyword{data}
