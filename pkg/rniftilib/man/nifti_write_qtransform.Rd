\name{nifti_write_qtransform}
\alias{nifti_write_qtransform}
\title{Read data from nifti (analyse) files and write qtransform.}
\description{
  This function reads the data from a nifti file into the R environment.
  and stores transformation matrix to scanner coordinate system.
}
\usage{

}
\arguments{

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
\code{\link{nifti_image_write}}
}

\examples{
library(Rniftilib)
nifti_img=nifti_image_read(file.choose())
nifti_image_setdatatype(nifti_img,4)
#nifti_img$quatern_b=0
#nifti_img$quatern_c=0
#nifti_img$quatern_d=0
#nifti_img$qoffset_x=0
#nifti_img$qoffset_y=0
#nifti_img$qoffset_z=0
#nifti_img$qfac=1
nifti_image_write(nifti_img)

pixdim=nifti_image_getpixdim(nifti_img)
ijk_to_xyz_inv=matrix(nrow=4,ncol=4,
c(1.0/pixdim[1],0,0,0, 0,1.0/pixdim[2],0,0, 0,0,1.0/pixdim[3],0, 0,0,0,1));

edges=matrix(nrow=3,ncol=8,
c(
0,0,0,
0,0,1,
0,1,0,
0,1,1,
1,0,0,
1,0,1,
1,1,0,
1,1,1))
#edges[edges[]==0]=-0.5
#edges[edges[]==1]=0.5

#targetdim=c(256,256,160)
#targetqto_xyz=matrix(nrow=4,ncol=4,c(-0.05352118, -0.8644106, -0.1247190, 0, -0.05518163,
#-0.1213564, 0.8647847, 0, 0.9961408, -0.06944249,
#0.05381847, 0, -80.4613, -112.5341, 121.1274, 1));

targetdim=dim(nifti_img)
targetqto_xyz=nifti_img$qto_xyz
edges=edges * targetdim
edges=rbind(edges,rep(1,8)) # make homogen
edges_scanner_mm=targetqto_xyz%*%edges
x_range=c(min(edges_scanner_mm[1,]),max(edges_scanner_mm[1,]))
y_range=c(min(edges_scanner_mm[2,]),max(edges_scanner_mm[2,]))
z_range=c(min(edges_scanner_mm[3,]),max(edges_scanner_mm[3,]))
x_center=x_range[1]+(x_range[2]-x_range[1])/2
y_center=y_range[1]+(y_range[2]-y_range[1])/2
z_center=z_range[1]+(z_range[2]-z_range[1])/2

x_center=-7.833286 
y_center=-244.2677
z_center=224.4667

x_center=0 
y_center=0
z_center=0

#img_x_range=256*0.88
#img_y_range=256*0.88
#img_z_range=160*1.00

img_x_range=256*0.88
img_y_range=256*0.88
img_z_range=160*1.00
img_x_center=img_x_range/2
img_y_center=img_y_range/2
img_z_center=img_z_range/2
T=matrix(nrow=4,ncol=4,c(1,0,0,0, 0,1,0,0, 0,0,1,0, img_x_center-x_center,img_y_center-y_center,img_z_center-z_center,1))


if(nifti_img$qform_code=="NIFTI_XFORM_SCANNER_ANAT")
{
  filename=file.choose()
  write(t(T%*%nifti_img$qto_xyz%*%ijk_to_xyz_inv),file=filename,ncolumns = 4);
  write(c(x_range,y_range,z_range,x_center,y_center,z_center),file=paste(filename,".par",sep=""),ncolumns = 4);
  write(t(edges_scanner_mm),file=paste(filename,".edges",sep=""),ncolumns = 8);
}

# ----
edges1=read.table(file=file.choose(),header=FALSE);
edges2=read.table(file=file.choose(),header=FALSE);
edges3=read.table(file=file.choose(),header=FALSE);
edges4=read.table(file=file.choose(),header=FALSE);
all_edges=rbind(t(edges1[c(1,3),]),t(edges2[c(1,3),]),t(edges3[c(1,3),]),t(edges4[c(1,3),]))
layout(matrix(nrow=1,ncol=2,c(1,2)))
plot(all_edges,main="scanner top view",xlab="x",ylab="z")
points(t(edges1[c(1,3),]),col=1)
points(t(edges2[c(1,3),]),col=2)
points(t(edges3[c(1,3),]),col=3)
points(t(edges4[c(1,3),]),col=4)

all_edges=rbind(t(edges1[c(2,3),]),t(edges2[c(2,3),]),t(edges3[c(2,3),]),t(edges4[c(2,3),]))
plot(all_edges,main="scanner side view",xlab="y",ylab="z")
points(t(edges1[c(2,3),]),col=1)
points(t(edges2[c(2,3),]),col=2)
points(t(edges3[c(2,3),]),col=3)
points(t(edges4[c(2,3),]),col=4)


}
\keyword{interface}