displayDTI <- function(v1, v2, v3, ...)
{
  colvec <- rgb(abs(v1), abs(v2), abs(v3))
  colors <- unique(colvec)
  colmat <- array(match(colvec, colors), dim=dim(v1)[1:2])
  image(x = 1:(dim(colmat)[2]), y=1:(dim(colmat)[1]),
        z = t(colmat), col=colors,
        xlab="", ylab="", axes=FALSE, asp=1, ...)
}


CreateVOIMask <- function(templatefile=file.choose(),
                          output.basefilename, MNI, radius=2)
{
  nifti.img <- nifti.image.read(templatefile)
  nifti.set.filenames(nifti.img, output.basefilename)
  # show the result
  #print(nifti.img$fname)
  #print(nifti.img$iname)
  nifti.img$"scl.inter" <- 0
  nifti.img$"scl.slope" <- 1

  #mval <- max(nifti.img[])
  for (x in 1:dim(nifti.img)[1])
  {
    for (y in 1:dim(nifti.img)[2])
      {
        for (z in 1:dim(nifti.img)[3])
          {
            pos.mm <- nifti.img$qto.xyz %*% c(x-1,y-1,z-1,1)
            if (sqrt(sum((MNI-pos.mm[1:3])^2)) <= radius)
              { 
                nifti.img[x,y,z] <- 1
                print(c(x,y,z))	   
              }
	    else
              {
                nifti.img[x,y,z] <- 0
              }
          }
      }
  }
  nifti.image.write(nifti.img)
  invisible()
}