\name{displayDTI}
\alias{displayDTI}
\title{Display vector valued images.}
\description{
Function to display vector valued images (e.g. components of a DTI image). 
}
\usage{
displayDTI<-function(v1,v2,v3,...)
}
\arguments{
\item{v1}{two dimensional matrix used for red comp.}
\item{v2}{two dimensional matrix used for green comp.}
\item{v3}{two dimensional matrix used for blue comp.}
}
\details{
The function can be used for example to display diffusion tensor images (DTI). 
The three components given as the parameters v1, v2, v3 are used to display a 
colour image. The first comp. (v1) is used for the red channel, the second component (v2)
is used for the green channel and the third (v3) is used for the blue channel.
The components v1, v2, v3 should be given as a two-dimensional matrix or array.
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
# Load two images (one vector valued + one scalar valued image)
# Display the images (vector is used for color, scalar is used for modulation)

library(Rniftilib)
# load vector image (e.g. EV1,EV2 or EV3)
nifti_img=nifti_image_read(file.choose())
# load FA image (e.g. fractional anisotropy)
nifti_FA=nifti_image_read(file.choose())

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
maxFA=max(nifti_FA[,,]);
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
\keyword{nifti_image_alloc_data}
