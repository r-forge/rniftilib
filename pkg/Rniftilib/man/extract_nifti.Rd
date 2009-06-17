\name{[.nifti}
\alias{[.nifti}
\alias{[<-.nifti}
\alias{$.nifti}
\alias{$<-.nifti}
\title{Subscript a NIfTI Object}
\usage{
\method{[}{nifti}(nim,
                  x = 1:nifti.image.getdim.save(nim, 1),
                  y = 1:nifti.image.getdim.save(nim, 2),
                  z = 1:nifti.image.getdim.save(nim, 3),
                  t = 1:nifti.image.getdim.save(nim, 4),
                  dim5 = 1:nifti.image.getdim.save(nim, 5),
                  dim6 = 1:nifti.image.getdim.save(nim, 6),
                  dim7 = 1:nifti.image.getdim.save(nim, 7))
\method{[}{nifti}() <- value
\method{$}{nifti}(nim, sym)
\method{$}{nifti}() <- value
}
\arguments{
 \item{nim}{}
 \item{x,y,z,t}{}
 \item{dim5,dim6,dim7}{}
 \item{sym}{}
 \item{value}{}
}
\description{
  ~~ blah ~~
}
\value{

}
\author{
  Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}
\seealso{
  \code{\link{[}}, \code{\link{$}}, \code{\link{nifti}}
}
\examples{
}
\keyword{models}
