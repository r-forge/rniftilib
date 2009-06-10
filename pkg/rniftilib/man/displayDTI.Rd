\name{displayDTI}
\alias{displayDTI}
\title{Display vector valued images.}
\description{
  Function to display vector valued images (e.g. components of a DTI
  image).
}
\usage{
displayDTI(v1, v2, v3, ...)
}
\arguments{
\item{v1}{matrix used for red component}
\item{v2}{matrix used for green component}
\item{v3}{matrix used for blue component}
\item{...}{additional arguments for the \code{\link{image}} function.}
}
\details{
The function can be used to display diffusion tensor images (DTI). 
The three components given as the parameters v1, v2, v3 are used to display a 
colour image. The first component (v1) is used for the red channel, the second component (v2)
is used for the green channel and the third (v3) is used for the blue channel.
The components v1, v2, v3 should be given as a two-dimensional matrix or array.
}
\references{
\url{http://nifti.nimh.nih.gov}
\url{http://niftilib.sourceforge.net}
}
\author{
Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}
\seealso{ 
  \code{\link{nifti_image_new}},
  \code{\link{nifti_image_write}},
  \code{\link{nifti_image_read}}
}
\examples{
\dontrun{
# Load two images (one vector valued + one scalar valued image)
# Display the images (vector is used for color, scalar is used for modulation)

# load vector image (e.g. EV1,EV2 or EV3)
nifti_img <- nifti_image_read(file.choose())
# load FA image (e.g. fractional anisotropy)
nifti_FA <- nifti_image_read(file.choose())

# Animate (go through all slices)
for(slice in 1:dim(nifti_img)[3])
{
  displayDTI(t(nifti_img[,,slice,1]),t(nifti_img[,,slice,2]),t(nifti_img[,,slice,3]))
}

for(slice in 1:dim(nifti_img)[2])
{
  displayDTI(t(nifti_img[,slice,,1]),t(nifti_img[,slice,,2]),t(nifti_img[,slice,,3]))
}

for(slice in 1:dim(nifti_img)[1])
{
  displayDTI(t(nifti_img[slice,,,1]),t(nifti_img[slice,,,2]),t(nifti_img[slice,,,3]))
}

# Modulate vector image with FA image
maxFA <- max(nifti_FA[,,])
for(slice in 1:dim(nifti_img)[3])
{
  displayDTI(t(nifti_FA[,,slice]*1/maxFA*nifti_img[,,slice,1]),t(nifti_FA[,,slice]*nifti_img[,,slice,2]*1/maxFA),t(nifti_FA[,,slice]*nifti_img[,,slice,3]*1/maxFA))
}

for(slice in 1:dim(nifti_img)[2])
{
  displayDTI(t(nifti_FA[,slice,]*1/maxFA*nifti_img[,slice,,1]),t(nifti_FA[,slice,]*1/maxFA*nifti_img[,slice,,2]),t(nifti_FA[,slice,]*1/maxFA*nifti_img[,slice,,3]))
}

for(slice in 1:dim(nifti_img)[1])
{
  displayDTI(t(nifti_FA[slice,,]*1/maxFA*nifti_img[slice,,,1]),t(nifti_FA[slice,,]*1/maxFA*nifti_img[slice,,,2]),t(nifti_FA[slice,,]*1/maxFA*nifti_img[slice,,,3]))
}
}
}
\keyword{dplot}
