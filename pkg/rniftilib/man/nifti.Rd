\name{nifti}
\alias{nifti}
\title{nifti object}
\description{
  A nifti object contains the image description and data of an image volume. 
}
\arguments{
  \item{qto_xyz}{} 
  \item{qto_ijk}{hold voxel to mm transformation (?)}
  \item{sto_xyz}{}
  \item{sto_ijk}{} 
  \item{toffset}{}
  \item{descrip}{hold description (up to 80 characters}
  \item{fname}{header filename (store image information)}
  \item{iname}{image filename (store image data)}
  \item{slice_duration}{Time for 1 slice}	
  \item{qform_code}{}
  \item{sform_code}{}
  \item{quatern_b}{}
  \item{quatern_c}{}
  \item{quatern_d}{}
  \item{qoffset_x}{}
  \item{qoffset_y}{}
  \item{qoffset_z}{}
  \item{qfac}{}
  \item{pixdim}{Grid spacings.}
  \item{nifti_type}{NIFTI_FTYPE_ANALYZE (0), NIFTI_FTYPE_NIFTI1_1 (1), NIFTI_FTYPE_NIFTI1_2  (2), NIFTI_FTYPE_ASCII (3)}
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
Oliver Granert <o.granert@neurologie.uni-kiel.de>
}

\seealso{ 
\code{\link{nifti_image_read} \link{nifti_image_write}  \link{nifti_image_new}}
}
