CreateVOIMask <- function(templatefile=file.choose(),
                          output.basefilename, MNI, radius=2)
{
  nifti.img <- nifti.image.read(templatefile)
  nifti.set.filenames(nifti.img, output.basefilename)
  # show the result
  #print(nifti.img$"fname")
  #print(nifti.img$"iname")
  nifti.img$"scl_inter" <- 0
  nifti.img$"scl_slope" <- 1

  #mval <- max(nifti.img[])
  for (x in 1:dim(nifti.img)[1])
  {
    for (y in 1:dim(nifti.img)[2])
      {
        for (z in 1:dim(nifti.img)[3])
          {
            pos.mm <- nifti.img$"qto_xyz" %*% c(x-1,y-1,z-1,1)
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
