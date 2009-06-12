\name{nifti}
\alias{nifti}
\title{NIfTI object}
\description{
  A NIfTI object contains the image description and data of an image
  volume.
  The voxels can be accessed by the bracket [dim1,dim2,dim3,...,dim7] operator.
}
\arguments{
  \item{qto.xyz}{hold voxel to mm transformation} 
  \item{qto.ijk}{hold mm to voxel transformation}
  \item{sto.xyz}{hold voxel to mm transformation}
  \item{sto.ijk}{hold mm to voxel transformation} 
  \item{toffset}{}
  \item{descrip}{description (up to 80 characters}
  \item{fname}{header filename (store image information)}
  \item{iname}{image filename (store image data)}
  \item{slice.duration}{Time for 1 slice}	
  \item{qform.code}{ \tabular{rc}{ 
      \code{NIFTI.XFORM.UNKNOWN} \tab 0\cr
      \code{NIFTI.XFORM.SCANNER.ANAT} \tab 1\cr
      \code{NIFTI.XFORM.ALIGNED.ANAT} \tab 2\cr
      \code{NIFTI.XFORM.TALAIRACH} \tab 3\cr
      \code{NIFTI.XFORM.MNI.152} \tab 4\cr
      qform code: >No< for unknown tags \tab <No>
  }}
  \item{sform.code}{ \tabular{rc}{ 
      \code{NIFTI.XFORM.UNKNOWN} \tab 0\cr
      \code{NIFTI.XFORM.SCANNER.ANAT} \tab 1\cr
      \code{NIFTI.XFORM.ALIGNED.ANAT} \tab 2\cr
      \code{NIFTI.XFORM.TALAIRACH} \tab 3\cr
      \code{NIFTI.XFORM.MNI.152} \tab 4\cr
      qform code: >No< for unknown tags \tab <No>
  }}
  \item{quatern.b}{}
  \item{quatern.c}{}
  \item{quatern.d}{}
  \item{qoffset.x}{}
  \item{qoffset.y}{}
  \item{qoffset.z}{}
  \item{qfac}{}
  \item{pixdim}{Grid spacings.}
  \item{nifti.type}{\tabular{rc}{ 
      \code{NIFTI.FTYPE.ANALYZE} \tab (0) \cr
      \code{NIFTI.FTYPE.NIFTI1.1} \tab (1) \cr
      \code{NIFTI.FTYPE.NIFTI1.2} \tab (2) \cr
      \code{NIFTI.FTYPE.ASCII} \tab (3)}}
  \item{sizeof_hdr}{MUST be 348}
  \item{datatype}{Defines data type!}
  \item{scl.slope}{nifti1: Data scaling: slope.  analyze 7.5: float funused1}
  \item{scl.inter}{nifti1: Data scaling: offset. analyze 7.5: float funused2}  
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
\keyword{package}
\keyword{data}
\keyword{manip}
