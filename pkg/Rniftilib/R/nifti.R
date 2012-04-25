nifti.image.new <- function()
{
  .Call("Rnifti_image_new", PACKAGE="Rniftilib") 
}

nifti.image.alloc.data <- function(nim)
{
  .Call("Rnifti_image_alloc_data", nim, PACKAGE="Rniftilib")
}

nifti.image.unload <- function(nim)
{
  .Call("Rnifti_image_unload", nim, PACKAGE="Rniftilib")
}

nifti.image.free <- function(nim)
{
  .Call("Rnifti_image_free", nim, PACKAGE="Rniftilib")
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

nifti.image.read <- function(file, read_data=1, rm.NaN=TRUE) 
{
  .Call("Rnifti_image_read", file, read_data, rm.NaN, PACKAGE="Rniftilib") 
}

nifti.image.write <- function(nim) 
{
  .Call("Rnifti_image_write", nim, PACKAGE="Rniftilib") 
}

nifti.image.getdim.save <- function(nim, index)
{
  d <- dim(nim)
  retval <- 1
  if (length(d) >= index)
    retval <- d[index]
  retval   
}

is.nifti <- function(x)
{
  is(x,"nifti")
}

"[.nifti" <- function(x, 
                      dim1=1:nifti.image.getdim.save(x,1),
                      dim2=1:nifti.image.getdim.save(x,2),
                      dim3=1:nifti.image.getdim.save(x,3),
                      dim4=1:nifti.image.getdim.save(x,4),
                      dim5=1:nifti.image.getdim.save(x,5),
                      dim6=1:nifti.image.getdim.save(x,6),
                      dim7=1:nifti.image.getdim.save(x,7))
{
  .Call("Rnifti_image_getpixel", x, dim1-1, dim2-1, dim3-1, dim4-1, dim5-1, dim6-1, dim7-1,
        PACKAGE="Rniftilib")
}

"[<-.nifti" <- function(x, 
                        dim1=1:nifti.image.getdim.save(x,1),
                        dim2=1:nifti.image.getdim.save(x,2),
                        dim3=1:nifti.image.getdim.save(x,3),
                        dim4=1:nifti.image.getdim.save(x,4),
                        dim5=1:nifti.image.getdim.save(x,5),
                        dim6=1:nifti.image.getdim.save(x,6),
                        dim7=1:nifti.image.getdim.save(x,7),
                        value)
{
  .Call("Rnifti_image_setpixel", x, dim1-1, dim2-1, dim3-1, dim4-1, dim5-1, dim6-1, dim7-1, value,
        PACKAGE="Rniftilib")
}

"$.nifti" <- function(x, sym)
{
  .Call("Rnifti_image_getattribute", x, sym, PACKAGE="Rniftilib")
}

"$<-.nifti" <- function(x, sym, value)
{
  .Call("Rnifti_image_setattribute", x, sym, value, PACKAGE="Rniftilib")
}

nifti.image.setdatatype <- function(nim, value)
{
  .Call("Rnifti_image_setdatatype", nim, value, PACKAGE="Rniftilib")
}

# EXPERIMENTAL function
nifti.read.subregion.image <- function(nim, start_index, region_size)
{
  .Call("Rnifti_read_subregion_image", nim, start_index, region_size, PACKAGE="Rniftilib")
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
plot.nifti <- function(x, 
		       dim1=1:nifti.image.getdim.save(x,1),
               dim2=1:nifti.image.getdim.save(x,2),
               dim3=1,
               dim4=1,...)
{
  image(dim1,dim2,x[dim1,dim2,dim3,dim4],col=gray(1:255/255),...)
}

print.nifti <- function(x, ...)
{
  .Call("Rnifti_image_printinfo", x, PACKAGE="Rniftilib")
}

"dim.nifti" <- function(x)
{
  .Call("Rnifti_image_getattribute", x, "dim", PACKAGE="Rniftilib")
}

"dim<-.nifti" <- function(x, value)
{
  .Call("Rnifti_image_setattribute", x, "dim", value, PACKAGE="Rniftilib")
}

nifti.compiled.with.zlib <- function()
{
  .Call("Rnifti_compiled_with_zlib", PACKAGE="Rniftilib")
}

nifti.disp.lib.version <- function()
{
  .Call("Rnifti_disp_lib_version", PACKAGE="Rniftilib")
}

nifti.units.string <- function(value)
{
  .Call("Rnifti_units_string", value, PACKAGE="Rniftilib")
}

nifti.datatype.string <- function(value)
{
  .Call("Rnifti_datatype_string", value, PACKAGE="Rniftilib")
}

