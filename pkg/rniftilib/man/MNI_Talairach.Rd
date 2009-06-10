\name{MNITalairach}
\alias{MNITalairach}
\title{Convert MNI coordinates to Talairach coordinates.}
\description{
This is an example demonstrating coordinate transformations between MNI and Talairach space.
To get from McGill [MNI]-SPM96-coordinates to Talairach 88-SPM 95 coordinates:
X' = 0.88*X - 0.8
Y' = 0.97*Y - 3.32
Z' = 0.05*Y + 0.88*Z - 0.44
}
\references{
  \url{http://imaging.mrc-cbu.cam.ac.uk/imaging/MniTalairach}
}
\examples{
MNI <- c(10,10,10,1)
M <- t(matrix(nrow=4,ncol=4,c(0.88,0,0,-0.8,0,0.97,0,-3.32,0,0.05,0.88,-0.44,0,0,0,1)))
Talairach <- M %*% MNI
print(Talairach)
}
\keyword{manip}