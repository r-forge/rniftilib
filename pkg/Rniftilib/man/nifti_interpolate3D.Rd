\name{nifti.interpolate3d}
\alias{nifti.interpolate3d}
\title{Interpolation between voxels}
\description{
  This function interpolates in 3d between voxels (in volume data).
}
\usage{
nifti.interpolate3d(nim, x, y, z, t=1) 
}
\arguments{
  \item{nim}{the nifti object}
  \item{x}{x coordinate (subpixel/floating point)}
  \item{y}{y coordinate (subpixel/floating point)}
  \item{z}{z coordinate (subpixel/floating point)}
  \item{t}{t coordinate (subpixel/floating point)}
}
\references{
\url{http://nifti.nimh.nih.gov}
\url{http://niftilib.sourceforge.net}
}
\author{
Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}

\seealso{
  \code{\link{nifti.image.read}},
  \code{\link{nifti.image.write}},
  \code{\link{nifti.image.new}}
}

\examples{
\dontrun{
nifti.img <- nifti.image.read(file.choose())
plot(c(nifti.interpolate3d(nifti.img,100,100,3),
       nifti.interpolate3d(nifti.img,100.25,100,3),
       nifti.interpolate3d(nifti.img,100.5,100,3),
       nifti.interpolate3d(nifti.img,100.75,100,3),
       nifti.interpolate3d(nifti.img,101,100,3)),
       xlab="position x", ylab="interpolation")
}
}
\keyword{utilities}
