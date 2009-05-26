.packageName <- "Rniftilib"
CreateVOIMask<-function(templatefile=file.choose(),output_basefilename,MNI,radius=2)
{
  nifti_img=nifti_image_read(templatefile);
  nifti_set_filenames(nifti_img,output_basefilename);
  # show the result
  #print(nifti_img$fname);
  #print(nifti_img$iname);
  nifti_img$scl_inter=0
  nifti_img$scl_slope=1

  #mval=max(nifti_img[]);
  for(x in 1:dim(nifti_img)[1])
  {
    for(y in 1:dim(nifti_img)[2])
    {
      for(z in 1:dim(nifti_img)[3])
      {
        pos_mm = nifti_img$qto_xyz %*% c(x-1,y-1,z-1,1);
        if(sqrt(sum((MNI-pos_mm[1:3])^2))<=radius)
        { 
          nifti_img[x,y,z]=1;
          print(c(x,y,z))	   
        }
	    else
	    {
          nifti_img[x,y,z]=0;
        }
      }
    }
  }
  nifti_image_write(nifti_img);
}
## FirstLib: initialization of Rniftilib
.First.lib <- function(lib, pkg) 
{ 
	#print(lib);
	library.dynam("Rniftilib", pkg, lib); 
  	.Call("Rnifti_init", lib, PACKAGE="Rniftilib");
}

## LastLib: cleanup of GTKTest
.Last.lib <- function(libpath) 
{ 
	library.dynam.unload("Rniftilib", libpath) 
}

nifti_image_read <- function(file, read_data=1) 
{
	.Call("Rnifti_image_read", file, read_data); 
}

nifti_image_new <- function()
{
	.Call("Rnifti_image_new"); 
}

nifti_image_alloc_data <- function(nim)
{
	.Call("Rnifti_image_alloc_data",nim);
}

nifti_image_copy_info <- function(nim)
{
  .Call("Rnifti_image_copy_info",nim);
}

nifti_set_filenames <-function(nim, prefix, check=1, set_byte_order=1)
{
	.Call("Rnifti_set_filenames",nim, prefix, check, set_byte_order)
}

nifti_image_write <- function(nim) 
{
	.Call("Rnifti_image_write", nim); 
}

dim.nifti<- function(nim, ...)
{
	.Call("Rnifti_image_getdim",nim);
}

nifti_image_getpixdim <-function(nim)
{
	.Call("Rnifti_image_getpixdim",nim);
}

nifti_image_getmat <-function(nim)
{
	.Call("Rnifti_image_getmat",nim);
}

nifti_image_getdim_save<-function(nim,index)
{
  d=dim(nim);
  retval=1;
  if(length(d)>=index)
    retval=d[index];
  retval;   
}

"[.nifti"<-function(nim, 
					x=1:nifti_image_getdim_save(nim,1),
					y=1:nifti_image_getdim_save(nim,2),
					z=1:nifti_image_getdim_save(nim,3),
					t=1:nifti_image_getdim_save(nim,4))
{
	.Call("Rnifti_image_getpixel",nim,x-1,y-1,z-1,t-1);
}

"[<-.nifti"<-function(nim, 
					  x=1:nifti_image_getdim_save(nim,1),
					  y=1:nifti_image_getdim_save(nim,2),
					  z=1:nifti_image_getdim_save(nim,3),
					  t=1:nifti_image_getdim_save(nim,4),
					  value)
{
	.Call("Rnifti_image_setpixel",nim,x-1,y-1,z-1,t-1,value);
}

"$.nifti"<-function(nim, sym)
{
	.Call("Rnifti_image_getattribute", nim, sym);
}

"$<-.nifti"<-function(nim, sym, value)
{
	.Call("Rnifti_image_setattribute", nim, sym, value);
}

nifti_image_setdatatype<-function(nim, value)
{
  .Call("Rnifti_image_setdatatype", nim, value);
}

nifti_interpolate3d<-function(nim, x, y, z, t=1)
{
  iX=floor(x);
  iY=floor(y);
  iZ=floor(z);
  coex=x-iX;
  coey=y-iY;
  coez=z-iZ;
  #print("--");
  #print(c(x,y,z));
  #print(c(iX,iY,iZ));
  #print(nifti_image_getdim_save(nifti_img,1));
  #print(nifti_image_getdim_save(nifti_img,2));
  #print(nifti_image_getdim_save(nifti_img,3));
        
  if(iX <=0 || iY<=0 || iZ<=0 
     || iX+1>nifti_image_getdim_save(nifti_img,1)
     || iY+1>nifti_image_getdim_save(nifti_img,2)
     || iZ+1>nifti_image_getdim_save(nifti_img,3))
    return(0);
      
  p1=(1-coex)*(1-coey)*(1-coez)*nim[iX,iY,iZ,t];
  p2=(1-coex)*(1-coey)*(  coez)*nim[iX,iY,iZ+1,t];
  p3=(1-coex)*(  coey)*(1-coez)*nim[iX,iY+1,iZ,t];
  p4=(1-coex)*(  coey)*(  coez)*nim[iX,iY+1,iZ+1,t];
  p5=(  coex)*(1-coey)*(1-coez)*nim[iX+1,iY,iZ,t];
  p6=(  coex)*(1-coey)*(  coez)*nim[iX+1,iY,iZ+1,t];
  p7=(  coex)*(  coey)*(1-coez)*nim[iX+1,iY+1,iZ,t];
  p8=(  coex)*(  coey)*(  coez)*nim[iX+1,iY+1,iZ+1,t];
  p1+p2+p3+p4+p5+p6+p7+p8;
}

# generic functions to integrate the nifti methods into R environment
plot.nifti<- function(nim,x=1:255)
{
  image(nim[x,,10,1],col=gray(1:255/255))
}

print.nifti<- function(nim, ...)
{
#  print("nifti_image:");
#  print(dim(nim));
#  print("other attributes:");
#  print(.Call("Rnifti_image_listattributes",nim));
  .Call("Rnifti_image_printinfo",nim);
}

displayDTI<- function(v1, v2, v3, ...)
{
  colvec=rgb(abs(v1), abs(v2), abs(v3));
  colors <- unique(colvec);
  colmat <- array(match(colvec, colors), dim=dim(v1)[1:2])
  image(x = 1:(dim(colmat)[2]), y=1:(dim(colmat)[1]),
        z = t(colmat), col=colors,
        xlab="", ylab="", axes=FALSE, asp=1, ...)
}


