nifti.image.read <- function(file, read_data=1) 
{
  .Call("Rnifti_image_read", file, read_data, PACKAGE="Rniftilib") 
}

nifti.image.new <- function()
{
  .Call("Rnifti_image_new", PACKAGE="Rniftilib") 
}

nifti.image.alloc.data <- function(nim)
{
  .Call("Rnifti_image_alloc_data", nim, PACKAGE="Rniftilib")
}

nifti.image.copy.info <- function(nim)
{
  .Call("Rnifti_image_copy_info", nim, PACKAGE="Rniftilib")
}

nifti.set.filenames <- function(nim, prefix, check=1, set_byte_order=1)
{
  .Call("Rnifti_set_filenames", nim, prefix, check, set_byte_order,
        PACKAGE="Rniftilib")
}

nifti.image.write <- function(nim) 
{
  .Call("Rnifti_image_write", nim, PACKAGE="Rniftilib") 
}

dim.nifti <- function(x, ...)
{
  .Call("Rnifti_image_getdim", x, PACKAGE="Rniftilib")
}

nifti.image.getpixdim <- function(nim)
{
  .Call("Rnifti_image_getpixdim", nim, PACKAGE="Rniftilib")
}

nifti.image.getmat <- function(nim)
{
  .Call("Rnifti_image_getmat", nim, PACKAGE="Rniftilib")
}

nifti.image.getdim.save <- function(nim, index)
{
  d <- dim(nim)
  retval <- 1
  if (length(d) >= index)
    retval <- d[index]
  retval   
}

"[.nifti" <- function(nim, 
                      x=1:nifti.image.getdim.save(nim,1),
                      y=1:nifti.image.getdim.save(nim,2),
                      z=1:nifti.image.getdim.save(nim,3),
                      t=1:nifti.image.getdim.save(nim,4),
                      dim5=1:nifti.image.getdim.save(nim,5),
                      dim6=1:nifti.image.getdim.save(nim,6),
                      dim7=1:nifti.image.getdim.save(nim,7))
{
  .Call("Rnifti_image_getpixel", nim, x-1, y-1, z-1, t-1, dim5-1, dim6-1, dim7-1,
        PACKAGE="Rniftilib")
}

"[<-.nifti" <- function(nim, 
                        x=1:nifti.image.getdim.save(nim,1),
                        y=1:nifti.image.getdim.save(nim,2),
                        z=1:nifti.image.getdim.save(nim,3),
                        t=1:nifti.image.getdim.save(nim,4),
                        dim5=1:nifti.image.getdim.save(nim,5),
                        dim6=1:nifti.image.getdim.save(nim,6),
                        dim7=1:nifti.image.getdim.save(nim,7),
                        value)
{
  .Call("Rnifti_image_setpixel", nim, x-1, y-1, z-1, t-1, dim5-1, dim6-1, dim7-1, value,
        PACKAGE="Rniftilib")
}

"$.nifti" <- function(nim, sym)
{
  .Call("Rnifti_image_getattribute", nim, sym, PACKAGE="Rniftilib")
}

"$<-.nifti" <- function(nim, sym, value)
{
  .Call("Rnifti_image_setattribute", nim, sym, value, PACKAGE="Rniftilib")
}

nifti.image.setdatatype <- function(nim, value)
{
  .Call("Rnifti_image_setdatatype", nim, value, PACKAGE="Rniftilib")
}

nifti.interpolate3d <- function(nim, x, y, z, t=1)
{
  iX <- floor(x)
  iY <- floor(y)
  iZ <- floor(z)
  coex <- x-iX
  coey <- y-iY
  coez <- z-iZ
        
  if (iX <=0 || iY <= 0 || iZ <= 0 
      || iX+1 > nifti.image.getdim.save(nim,1)
      || iY+1 > nifti.image.getdim.save(nim,2)
      || iZ+1 > nifti.image.getdim.save(nim,3))
    return(0)
      
  p1 <- (1-coex)*(1-coey)*(1-coez)*nim[iX,iY,iZ,t]
  p2 <- (1-coex)*(1-coey)*(  coez)*nim[iX,iY,iZ+1,t]
  p3 <- (1-coex)*(  coey)*(1-coez)*nim[iX,iY+1,iZ,t]
  p4 <- (1-coex)*(  coey)*(  coez)*nim[iX,iY+1,iZ+1,t]
  p5 <- (  coex)*(1-coey)*(1-coez)*nim[iX+1,iY,iZ,t]
  p6 <- (  coex)*(1-coey)*(  coez)*nim[iX+1,iY,iZ+1,t]
  p7 <- (  coex)*(  coey)*(1-coez)*nim[iX+1,iY+1,iZ,t]
  p8 <- (  coex)*(  coey)*(  coez)*nim[iX+1,iY+1,iZ+1,t]
  return(p1+p2+p3+p4+p5+p6+p7+p8)
}

# generic functions to integrate the nifti methods into R environment
plot.nifti <- function(nim, 
						x=1:nifti.image.getdim.save(nim,1),
                        y=1:nifti.image.getdim.save(nim,2),
                        z=1,
                        t=1,...)
{
  image(x,y,nim[x,y,z,t],col=gray(1:255/255))
}

print.nifti <- function(x, ...)
{
#  print("nifti.image:")
#  print(dim(nim))
#  print("other attributes:")
#  print(.Call("Rnifti_image_listattributes",nim))
  .Call("Rnifti_image_printinfo", x, PACKAGE="Rniftilib")
}
