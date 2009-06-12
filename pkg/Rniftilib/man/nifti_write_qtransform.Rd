\name{nifti.write.qtransform}
\alias{nifti.write.qtransform}
\title{Read data from NIfTI (Analyze) files and write qtransform}
\description{
  This function reads the data from a NIfTI file into the R environment.
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
  Oliver Granert <o.granert <at> neurologie.uni-kiel.de>
}

\seealso{ 
  \code{\link{nifti.image.write}}
}

\examples{
\dontrun{
nifti.img <- nifti.image.read(file.choose())
nifti.image.setdatatype(nifti.img, 4)
#nifti.img$quatern.b <- 0
#nifti.img$quatern.c <- 0
#nifti.img$quatern.d <- 0
#nifti.img$qoffset.x <- 0
#nifti.img$qoffset.y <- 0
#nifti.img$qoffset.z <- 0
#nifti.img$qfac <- 1
nifti.image.write(nifti.img)

pixdim <- nifti.image.getpixdim(nifti.img)
ijk.to.xyz.inv <- matrix(nrow=4, ncol=4, c(1.0/pixdim[1],0,0,0, 0,1.0/pixdim[2],0,0, 0,0,1.0/pixdim[3],0, 0,0,0,1))

edges <- matrix(nrow=3, ncol=8, c(0,0,0,0,0,1,0,1,0,0,1,1,1,0,0,1,0,1,1,1,0,1,1,1))
#edges[edges[]==0] <- -0.5
#edges[edges[]==1] <- 0.5

#targetdim <- c(256,256,160)
#targetqto.xyz <- matrix(nrow=4, ncol=4, c(-0.05352118, -0.8644106, -0.1247190, 0, -0.05518163,-0.1213564, 0.8647847, 0, 0.9961408, -0.06944249, 0.05381847, 0, -80.4613, -112.5341, 121.1274, 1))

targetdim <- dim(nifti.img)
targetqto.xyz <- nifti.img$qto.xyz
edges <- edges * targetdim
edges <- rbind(edges,rep(1,8)) # make homogen
edges.scanner.mm <- targetqto.xyz %*% edges
x.range <- c(min(edges.scanner.mm[1,]), max(edges.scanner.mm[1,]))
y.range <- c(min(edges.scanner.mm[2,]), max(edges.scanner.mm[2,]))
z.range <- c(min(edges.scanner.mm[3,]), max(edges.scanner.mm[3,]))
x.center <- x.range[1] + (x.range[2]-x.range[1])/2
y.center <- y.range[1] + (y.range[2]-y.range[1])/2
z.center <- z.range[1] + (z.range[2]-z.range[1])/2

x.center <- -7.833286 
y.center <- -244.2677
z.center <- 224.4667

x.center <- 0 
y.center <- 0
z.center <- 0

#img.x.range <- 256*0.88
#img.y.range <- 256*0.88
#img.z.range <- 160*1.00

img.x.range <- 256*0.88
img.y.range <- 256*0.88
img.z.range <- 160*1.00
img.x.center <- img.x.range/2
img.y.center <- img.y.range/2
img.z.center <- img.z.range/2
T <- matrix(nrow=4, ncol=4, c(1,0,0,0, 0,1,0,0, 0,0,1,0, img.x.center-x.center,img.y.center-y.center,img.z.center-z.center,1))

if (nifti.img$qform.code=="NIFTI.XFORM.SCANNER.ANAT") {
  filename <- file.choose()
  write(t(T %*% nifti.img$qto.xyz %*% ijk.to.xyz.inv), file=filename, ncolumns=4)
  write(c(x.range,y.range,z.range,x.center,y.center,z.center), file=paste(filename,".par",sep=""), ncolumns=4)
  write(t(edges.scanner.mm), file=paste(filename,".edges",sep=""), ncolumns=8)
}

# ----
edges1 <- read.table(file=file.choose(),header=FALSE)
edges2 <- read.table(file=file.choose(),header=FALSE)
edges3 <- read.table(file=file.choose(),header=FALSE)
edges4 <- read.table(file=file.choose(),header=FALSE)
all.edges <- rbind(t(edges1[c(1,3),]),
                   t(edges2[c(1,3),]),
                   t(edges3[c(1,3),]),
                   t(edges4[c(1,3),]))
layout(matrix(nrow=1,ncol=2,c(1,2)))
plot(all.edges,main="scanner top view", xlab="x", ylab="z")
points(t(edges1[c(1,3),]), col=1)
points(t(edges2[c(1,3),]), col=2)
points(t(edges3[c(1,3),]), col=3)
points(t(edges4[c(1,3),]), col=4)

all.edges <- rbind(t(edges1[c(2,3),]),
                   t(edges2[c(2,3),]),
                   t(edges3[c(2,3),]),
                   t(edges4[c(2,3),]))
plot(all.edges, main="scanner side view", xlab="y", ylab="z")
points(t(edges1[c(2,3),]), col=1)
points(t(edges2[c(2,3),]), col=2)
points(t(edges3[c(2,3),]), col=3)
points(t(edges4[c(2,3),]), col=4)
}
}
\keyword{interface}
\keyword{manip}
