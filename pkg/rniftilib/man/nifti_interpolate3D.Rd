\name{nifti_interpolate3d}
\alias{nifti_interpolate3d}
\title{nifti.interpolate3d}
\description{
  This function interpolates in 3d (in volume data).
}
\usage{
nifti_interpolate3d(nim, x, y, z, t=1) 
}
\arguments{
  \item{nim}{the nifti object}
  \item{x}{x coordinate (subpixel)}
  \item{y}{y coordinate (subpixel)}
  \item{z}{z coordinate (subpixel)}
  \item{t}{t coordinate (subpixel)}
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
  \code{\link{nifti_image_read}},
  \code{\link{nifti_image_write}},
  \code{\link{nifti_image_new}}
}

\examples{
\dontrun{
nifti_img <- nifti_image_read(file.choose())
plot(c(nifti_interpolate3d(nifti_img,100,100,3),
       nifti_interpolate3d(nifti_img,100.25,100,3),
       nifti_interpolate3d(nifti_img,100.5,100,3),
       nifti_interpolate3d(nifti_img,100.75,100,3),
       nifti_interpolate3d(nifti_img,101,100,3)),
       xlab="position x", ylab="interpolation")
}
}
\keyword{}
