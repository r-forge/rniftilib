\name{nifti}
\alias{nifti}
\title{NIfTI object}
\description{
  A NIfTI object contains the image description and data of an image
  volume.
}
\arguments{
  \item{qto_xyz}{hold voxel to mm transformation} 
  \item{qto_ijk}{hold mm to voxel transformation}
  \item{sto_xyz}{hold voxel to mm transformation}
  \item{sto_ijk}{hold mm to voxel transformation} 
  \item{toffset}{}
  \item{descrip}{description (up to 80 characters}
  \item{fname}{header filename (store image information)}
  \item{iname}{image filename (store image data)}
  \item{slice_duration}{Time for 1 slice}	
  \item{qform_code}{ \tabular{rc}{ 
      \code{NIFTI_XFORM_UNKNOWN} \tab 0\cr
      \code{NIFTI_XFORM_SCANNER_ANAT} \tab 1\cr
      \code{NIFTI_XFORM_ALIGNED_ANAT} \tab 2\cr
      \code{NIFTI_XFORM_TALAIRACH} \tab 3\cr
      \code{NIFTI_XFORM_MNI_152} \tab 4\cr
      qform code: >No< for unknown tags \tab <No>
  }}
  \item{sform_code}{ \tabular{rc}{ 
      \code{NIFTI_XFORM_UNKNOWN} \tab 0\cr
      \code{NIFTI_XFORM_SCANNER_ANAT} \tab 1\cr
      \code{NIFTI_XFORM_ALIGNED_ANAT} \tab 2\cr
      \code{NIFTI_XFORM_TALAIRACH} \tab 3\cr
      \code{NIFTI_XFORM_MNI_152} \tab 4\cr
      qform code: >No< for unknown tags \tab <No>
  }}
  \item{quatern_b}{}
  \item{quatern_c}{}
  \item{quatern_d}{}
  \item{qoffset_x}{}
  \item{qoffset_y}{}
  \item{qoffset_z}{}
  \item{qfac}{}
  \item{pixdim}{Grid spacings.}
  \item{nifti_type}{\tabular{rc}{ 
      \code{NIFTI_FTYPE_ANALYZE} \tab (0) \cr
      \code{NIFTI_FTYPE_NIFTI1_1} \tab (1) \cr
      \code{NIFTI_FTYPE_NIFTI1_2} \tab (2) \cr
      \code{NIFTI_FTYPE_ASCII} \tab (3)}}
  \item{sizeof_hdr}{MUST be 348}
  \item{datatype}{Defines data type!}
  \item{scl_slope}{nifti1: Data scaling: slope.  analyze 7.5: float funused1}
  \item{scl_inter}{nifti1: Data scaling: offset. analyze 7.5: float funused2}  
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
