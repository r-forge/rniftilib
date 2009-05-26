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
