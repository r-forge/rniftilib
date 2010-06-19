\name{nifti.image.setdatatype}
\alias{nifti.image.setdatatype}
\title{Change data type of nifti object.}
\description{
Set \code{datatype} and \code{nbyper} fields.
}
\usage{
nifti.image.setdatatype(nim, value)
}
\arguments{
  \item{nim}{ nifti image object }
  \item{value}{ the data type \tabular{rcl}{
\code{DT_NONE}         \tab (0) \tab \cr
\code{DT_UNKNOWN}      \tab (0) \tab   what it says, dude \cr         
\code{DT_BINARY}       \tab (1) \tab   binary (1 bit/voxel) \cr       
\code{DT_UNSIGNED_CHAR}\tab (2) \tab   unsigned char (8 bits/voxel) \cr
\code{DT_SIGNED_SHORT} \tab (4) \tab   signed short (16 bits/voxel) \cr
\code{DT_SIGNED_INT}   \tab (8) \tab   signed int (32 bits/voxel)   \cr
\code{DT_FLOAT}        \tab (16) \tab  float (32 bits/voxel) \cr
\code{DT_COMPLEX}      \tab (32) \tab  complex (64 bits/voxel) \cr
\code{DT_DOUBLE}       \tab (64) \tab  double (64 bits/voxel) \cr
\code{DT_RGB}          \tab (128) \tab RGB triple (24 bits/voxel) \cr
\code{DT_ALL}          \tab (255) \tab not very useful (?) \cr
 \tab \tab \cr
\code{DT_UINT8}        \tab (2) \tab \cr
\code{DT_INT16}        \tab (4) \tab \cr
\code{DT_INT32}        \tab (8) \tab \cr
\code{DT_FLOAT32}      \tab (16) \tab \cr
\code{DT_COMPLEX64}    \tab (32) \tab \cr
\code{DT_FLOAT64}      \tab (64) \tab \cr
\code{DT_RGB24}        \tab (128) \tab \cr
 \tab \tab \cr
\code{DT_INT8}         \tab (256) \tab signed char (8 bits) \cr
\code{DT_UINT16}       \tab (512) \tab unsigned short (16 bits) \cr
\code{DT_UINT32}       \tab (768) \tab unsigned int (32 bits) \cr
\code{DT_INT64}        \tab (1024) \tab long long (64 bits) \cr
\code{DT_UINT64}       \tab (1280) \tab unsigned long long (64 bits) \cr
\code{DT_FLOAT128}     \tab (1536) \tab long double (128 bits) \cr
\code{DT_COMPLEX128}   \tab (1792) \tab double pair (128 bits) \cr
\code{DT_COMPLEX256}   \tab (2048) \tab long double pair (256 bits) \cr
\code{DT_RGBA32}       \tab (2304) \tab 4 byte RGBA (32 bits/voxel) 
}}
}
\seealso{ 
  \code{\link{nifti.image.unload}},
  \code{\link{nifti.image.alloc.data}}
}
 
\keyword{IO}
