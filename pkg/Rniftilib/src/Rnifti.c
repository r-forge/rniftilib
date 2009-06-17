#include "nifti1_io.h"   /* directly include I/O library functions */
#include "nifti1.h"
#include <R.h>
#include <Rdefines.h>

extern char *gni_version;

SEXP NIFTI_type_tag;
#define SEXP2NIFTI(nim) ((TYPEOF(nim) != EXTPTRSXP || R_ExternalPtrTag(nim) != NIFTI_type_tag)?NULL:(nifti_image *)R_ExternalPtrAddr(nim))

/*
  library(Rniftilib)
  a=nifti_image_read("C:\\ffmri_L2409-00001-00001-0.img")
  
  for(s in 1:(dim(a)[2])) image(a[1,s,,],col=gray(1:255/255))
  for(s in 1:(dim(a)[3])) image(a[1,,s,],col=gray(1:255/255))
*/

SEXP Rnifti_init(SEXP libpath)
{
  NIFTI_type_tag = install("NIFTI_TYPE_TAG");
  return R_NilValue;
}

char *Rnifti_attributes[] =
  {
    "qto.xyz", 			/* 0 */
    "qto.ijk", 			/* 1 */
    "sto.xyz", 			/* 2 */
    "sto.ijk", 			/* 3 */
    "toffset", 			/* 4 */
    "descrip", 			/* 5 */
    "fname",   			/* 6 */
    "iname",   			/* 7 */
    "slice.duration", 	/* 8 */
    "qform.code", 		/* 9 */
    "sform.code", 		/* 10 */
    "quatern.b", 		/* 11 */
    "quatern.c", 		/* 12 */
    "quatern.d", 		/* 13 */
    "qoffset.x", 		/* 14 */
    "qoffset.y", 		/* 15 */
    "qoffset.z", 		/* 16 */
    "qfac",			    /* 17 */
    "pixdim",			/* 18 */
    "nifti.type",		/* 19 */
    "sizeof.hdr",	    /* 20 */
    "datatype",         /* 21 */
    "scl.slope",        /* 22 nifti1: Data scaling: slope.  analyze 7.5: float funused1; */
    "scl.inter",        /* 23 nifti1: Data scaling: offset. analyze 7.5: float funused2; */
    NULL
  };

SEXP Rnifti_mat44_SEXP(mat44 *mat)
{
  SEXP ret_val;
  int c,r;
  PROTECT(ret_val = NEW_NUMERIC(4*4));
  for(r=0;r<4;++r)
    for(c=0;c<4;++c)
      NUMERIC_POINTER(ret_val)[r+c*4]=(double)(mat->m[r][c]);
  
  SEXP dim;
  PROTECT(dim=NEW_INTEGER(2));
  INTEGER_POINTER(dim)[0]=4;
  INTEGER_POINTER(dim)[1]=4;
  SET_DIM(ret_val,dim);
  
  UNPROTECT(2);
  return ret_val;
}

void Rnifti_SEXP_mat44(SEXP val,mat44 *mat)
{
  int c,r;
  PROTECT(val = AS_NUMERIC(val));
  if(LENGTH(val)==16)
    {
      for(r=0;r<4;++r)
	for(c=0;c<4;++c)
	  (mat->m[r][c])=(float)NUMERIC_POINTER(val)[r+c*4];
    }
  else
    error("matrix must be 4x4\n");
  UNPROTECT(1);    
}

SEXP Rnifti_mat33_SEXP(mat33 *mat)
{
  SEXP ret_val;
  int c,r;
  PROTECT(ret_val = NEW_NUMERIC(4*4));
  for(r=0;r<3;++r)
    for(c=0;c<3;++c)
      NUMERIC_POINTER(ret_val)[r+c*4]=(double)mat->m[r][c];
  
  SEXP dim;
  PROTECT(dim=NEW_INTEGER(2));
  INTEGER_POINTER(dim)[0]=3;
  INTEGER_POINTER(dim)[1]=3;
  SET_DIM(ret_val,dim);
  
  UNPROTECT(2);
  return ret_val;
}

void Rnifti_SEXP_mat33(SEXP val,mat33 *mat)
{
  int c,r;
  PROTECT(val = AS_NUMERIC(val));
  if(LENGTH(val)==9)
    {
      for(r=0;r<3;++r)
	for(c=0;c<3;++c)
	  (mat->m[r][c])=(float)NUMERIC_POINTER(val)[r+c*4];
    }
  else
    error("matrix must be 3x3\n");
  UNPROTECT(1);    
}

SEXP Rnifti_float_SEXP(float val)
{
  SEXP ret_val;
  PROTECT(ret_val=NEW_NUMERIC(1));
  NUMERIC_POINTER(ret_val)[0]=val;
  UNPROTECT(1);
  return ret_val;
}

void Rnifti_SEXP_float(SEXP val_sexp, float *val)
{
  PROTECT(val_sexp=AS_NUMERIC(val_sexp));
  *val=(float)NUMERIC_POINTER(val_sexp)[0];
  UNPROTECT(1);
}

SEXP int_to_SEXP(int val)
{
  SEXP ret_val;
  PROTECT(ret_val=NEW_INTEGER(1));
  INTEGER_POINTER(ret_val)[0]=val;
  UNPROTECT(1);
  return ret_val;
}

void SEXP_to_int(SEXP val_sexp, int *val)
{
  PROTECT(val_sexp=AS_INTEGER(val_sexp));
  *val=(int)INTEGER_POINTER(val_sexp)[0];
  UNPROTECT(1);
}

SEXP Rnifti_pchar_SEXP(const char* val)
{
  SEXP ret_val;
  PROTECT(ret_val=NEW_CHARACTER(1));
  if(val!=NULL)
    SET_STRING_ELT(ret_val, 0, mkChar(val));
  else
    SET_STRING_ELT(ret_val, 0, mkChar(""));
  UNPROTECT(1);
  return ret_val;
}

void Rnifti_SEXP_pchar(SEXP val_sexp, char* val, int max_num)
{
  PROTECT(val_sexp=AS_CHARACTER(val_sexp));
  const char *pcstring = CHAR(CHARACTER_POINTER(val_sexp)[0]);
  if(strlen(pcstring)<max_num)
    strcpy(val,pcstring);
  else
    error("character string to long\n");
  UNPROTECT(1);
}

SEXP Rnifti_image_free(SEXP nim)
{
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {
      /*Rprintf("Delete nifti %p\n",pnim);*/
      nifti_image_free(pnim);
      R_ClearExternalPtr(nim);
    }
  else
    error("Rnifti_image_free: not a nifti pointer.\n");
  return R_NilValue;
}

SEXP Rnifti_image_new()
{
  nifti_image *pnim;
  
  /* create nifti image of size 1x1x1 */
  pnim = nifti_simple_init_nim();
  
  /*- if the data pointer is not yet set, get memory space for the image */
  if( pnim->data == NULL )
    {
  	int ntot = nifti_get_volsize(pnim);
    pnim->data = (void *)calloc(1,ntot) ;  /* create image memory */
    if( pnim->data == NULL )
    {
        error("** failed to alloc %d bytes for image data\n",(int)ntot);
    }
  }
  
  SEXP nim = R_MakeExternalPtr(pnim,NIFTI_type_tag, R_NilValue);
  R_RegisterCFinalizer(nim,(R_CFinalizer_t) Rnifti_image_free);
	
  /* set class attribute to nifti */
  SEXP classattrib;
  PROTECT(classattrib = allocVector(STRSXP, 1));
  SET_STRING_ELT(classattrib, 0, mkChar("nifti"));
  classgets(nim, classattrib);
  UNPROTECT(1);
  return nim;
}

SEXP Rnifti_image_alloc_data(SEXP nim)
{
  int ntot=0;
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim != NULL)
    {
      if( pnim->data != NULL )
	{
	  free(pnim->data);
	  pnim->data = NULL;
	}
      /*- if the data pointer is not yet set, get memory space for the image */
      if( pnim->data == NULL )
	{
	  ntot = nifti_get_volsize(pnim);
	  pnim->data = (void *)calloc(1,ntot) ;  /* create image memory */
	  if( pnim->data == NULL )
	    {
	      error("failed to alloc %d bytes for image data\n",(int)ntot);
	    }
	}
    }
  return int_to_SEXP(ntot);
}

SEXP Rnifti_set_filenames(SEXP nim, SEXP prefix, SEXP check, SEXP set_byte_order)
{
  SEXP ret_val=int_to_SEXP(1);
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {
      int icheck;
      int iset_byte_order;
      char prefix_buffer[500];
      
      Rnifti_SEXP_pchar(prefix, prefix_buffer, 500);
      SEXP_to_int(check, &icheck);
      SEXP_to_int(set_byte_order, &iset_byte_order);
      ret_val = int_to_SEXP(nifti_set_filenames( pnim, prefix_buffer, icheck, iset_byte_order));
    }	
  return ret_val;
}


SEXP Rnifti_image_listattributes(SEXP nim)
{
  SEXP Rstring;
  PROTECT( Rstring= NEW_CHARACTER(9));
  int iIndex;
  for(iIndex=0;Rnifti_attributes[iIndex]!=NULL;++iIndex)	  
    SET_STRING_ELT(Rstring, iIndex, mkChar(Rnifti_attributes[iIndex]));
  UNPROTECT(1);
  return Rstring;
}

SEXP Rnifti_image_setattribute(SEXP nim, SEXP sym, SEXP value)
{
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {	
      SEXP Rstring;
      PROTECT( Rstring= AS_CHARACTER(sym));
      int iIndex;
      for(iIndex=0;Rnifti_attributes[iIndex]!=NULL;++iIndex)
	if(strcmp(Rnifti_attributes[iIndex],CHAR(STRING_ELT(Rstring,0)))==0)
	  break;
      UNPROTECT(1);
      switch(iIndex)
	{
	case 0: /*qto_xyz*/
	  Rnifti_SEXP_mat44(value,&(pnim->qto_xyz)); break;
	case 1: /*qto_ijk*/
	  Rnifti_SEXP_mat44(value,&(pnim->qto_ijk)); break;
	case 2: /*sto_xyz*/
	  Rnifti_SEXP_mat44(value,&(pnim->sto_xyz)); break;	
	case 3: /*sto_ijk*/
	  Rnifti_SEXP_mat44(value,&(pnim->sto_ijk)); break;
	case 4: /*toffset*/
	  Rnifti_SEXP_float(value,&pnim->toffset); break;
	case 5: /*descrip*/
	  Rnifti_SEXP_pchar(value,pnim->descrip,80); break;
	case 6: /*fname*/
	  /* Rnifti_SEXP_pchar(value,pnim->fname,0); break; */
	  warning("Can not set this attribute directly! Please use the nifti.set.filenames function.\n"); break;
	case 7: /*iname*/
	  /* Rnifti_SEXP_pchar(value,pnim->iname,0); break; */
	  warning("Can not set this attribute directly! Please use the nifti.set.filenames function.\n"); break;
	case 8: /*slice_duration*/
	  Rnifti_SEXP_float(value,&(pnim->slice_duration)); break;
	case 11: /* quatern_b 11 */
	  Rnifti_SEXP_float(value,&(pnim->quatern_b)); break;
	case 12: /* quatern_c 12 */
	  Rnifti_SEXP_float(value,&(pnim->quatern_c)); break;
	case 13: /* quatern_d 13 */
	  Rnifti_SEXP_float(value,&(pnim->quatern_d)); break;
	case 14: /* qoffset_x 14 */
	  Rnifti_SEXP_float(value,&(pnim->qoffset_x)); break;
	case 15: /* qoffset_y 15 */
	  Rnifti_SEXP_float(value,&(pnim->qoffset_y)); break;
	case 16: /* qoffset_z 16 */
	  Rnifti_SEXP_float(value,&(pnim->qoffset_z)); break;
	case 17: /* qfac 17 */
	  Rnifti_SEXP_float(value,&(pnim->qfac)); break;
	case 18: /* pixdim 18 */
	  if(length(value)<=pnim->dim[0])
	    {
	      int iIndex;
	      PROTECT(value=AS_NUMERIC(value));
	      for(iIndex=0;iIndex<length(value);++iIndex)
		{
		  pnim->pixdim[iIndex+1]=NUMERIC_POINTER(value)[iIndex];
		}
	      UNPROTECT(1);
	    }
	  else
	    error("Length of pixdim greater than number of dimensions (dim[0])\n");
	  break;
	case 19: /* nifti_type 19 */
	  if(IS_NUMERIC(value))
	    {
	      SEXP_to_int(value,&pnim->nifti_type);
	    }
	  else
	    error("Only nummeric values are allowed to set nifti_type.\n");
	  break;
	case 21: /* datatype */
	  if(IS_NUMERIC(value))
	    {
	      SEXP_to_int(value,&pnim->datatype);
	    }
	  else
	    error("Only nummeric values are allowed to set nifti_datatype.\n");
	  break;
	case 22: /* scl_slope nifti1: Data scaling: slope.  analyze 7.5: float funused1 */
	  if(IS_NUMERIC(value))
	    {
	      Rnifti_SEXP_float(value,&(pnim->scl_slope));
	    }
	  else
	    error("Only nummeric values are allowed to set scl_slope.\n");				
	  break;	
	case 23: /* scl_inter nifti1: Data scaling: offset. analyze 7.5: float funused2 */
	  if(IS_NUMERIC(value))
	    {			 		
	      Rnifti_SEXP_float(value,&(pnim->scl_inter));
	    }
	  else
	    error("Only nummeric values are allowed to set scl_inter.\n");
	  break;	
	  
	default:
	  error("Rnifti_image_setattribute: unknown attribute\n"); 
	  break;
	}
      //Rprintf("symbol: %d\n",is_symbol(sym));			
    }
  else
    error("Rnifti_image_setattribute: not a pointer to a nifti object.\n");
  return nim;
}

SEXP Rnifti_image_getattribute(SEXP nim, SEXP sym)
{
  SEXP ret_val=R_NilValue;
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {	
      SEXP Rstring;
      PROTECT( Rstring= AS_CHARACTER(sym));
      int iIndex;
      for(iIndex=0;Rnifti_attributes[iIndex]!=NULL;++iIndex)
	if(strcmp(Rnifti_attributes[iIndex],CHAR(STRING_ELT(Rstring,0)))==0)
	  break;
      UNPROTECT(1);
      switch(iIndex)
	{
	case 0: /*qto_xyz*/
	  return Rnifti_mat44_SEXP(&(pnim->qto_xyz)); break;
	case 1: /*qto_ijk*/
	  return Rnifti_mat44_SEXP(&(pnim->qto_ijk)); break;
	case 2: /*sto_xyz*/
	  return Rnifti_mat44_SEXP(&(pnim->sto_xyz)); break;	
	case 3: /*sto_ijk*/
	  return Rnifti_mat44_SEXP(&(pnim->sto_ijk)); break;
	case 4: /*toffset*/
	  return Rnifti_float_SEXP(pnim->toffset); break;
	case 5: /*descrip*/
	  return Rnifti_pchar_SEXP(pnim->descrip); break;
	case 6: /*fname*/
	  return Rnifti_pchar_SEXP(pnim->fname); break;
	case 7: /*iname*/
	  return Rnifti_pchar_SEXP(pnim->iname); break;
	case 8: /*slice_duration*/
	  return Rnifti_float_SEXP(pnim->slice_duration); break;
	case 9: /* qform_code */
	  switch(pnim->qform_code)
	    {			  	
	    case NIFTI_XFORM_UNKNOWN:
	      /*! Arbitrary coordinates (Method 1). */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.UNKNOWN"); 
	      break;
	    case NIFTI_XFORM_SCANNER_ANAT:
	      /*! Scanner-based anatomical coordinates */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.SCANNER_ANAT"); 
	      break;	
	    case NIFTI_XFORM_ALIGNED_ANAT:
	      /*! Coordinates aligned to another file's,
		or to anatomical "truth".            */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.ALIGNED_ANAT"); 
	      break;	
	    case NIFTI_XFORM_TALAIRACH:
	      /*! Coordinates aligned to Talairach-
		Tournoux Atlas; (0,0,0)=AC, etc. */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.TALAIRACH"); 
	      break;
	    case NIFTI_XFORM_MNI_152:
	      /*! MNI 152 normalized coordinates. */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.MNI.152"); 
	      break;
	    default:
	      {
		char buffer[100];			  	  
		snprintf(buffer,100,"qform code: %d",pnim->qform_code);
		return Rnifti_pchar_SEXP(buffer); 
	      }
	      break;			  	  			  	                   
	    }
	  break;
	case 10: /* sform_code */
	  switch(pnim->sform_code)
	    {
	    case NIFTI_XFORM_UNKNOWN:
	      /*! Arbitrary coordinates (Method 1). */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.UNKNOWN"); 
	      break;
	    case NIFTI_XFORM_SCANNER_ANAT:
	      /*! Scanner-based anatomical coordinates */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.SCANNER_ANAT"); 
	      break;	
	    case NIFTI_XFORM_ALIGNED_ANAT:
	      /*! Coordinates aligned to another file's,
		or to anatomical "truth".            */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.ALIGNED.ANAT"); 
	      break;	
	    case NIFTI_XFORM_TALAIRACH:
	      /*! Coordinates aligned to Talairach-
		Tournoux Atlas; (0,0,0)=AC, etc. */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.TALAIRACH"); 
	      break;
	    case NIFTI_XFORM_MNI_152:
	      /*! MNI 152 normalized coordinates. */
	      return Rnifti_pchar_SEXP("NIFTI.XFORM.MNI.152"); 
	      break;
	    default:
	      {
		char buffer[100];			  	  
		snprintf(buffer,100,"qform code: %d",pnim->qform_code);
		return Rnifti_pchar_SEXP(buffer); 
	      }
	      break;			  			  	
	    }
	  break;
	case 11: /* quatern_b 11 */
	  return Rnifti_float_SEXP(pnim->quatern_b); break;
	case 12: /* quatern_c 12 */
	  return Rnifti_float_SEXP(pnim->quatern_c); break;
	case 13: /* quatern_d 13 */
	  return Rnifti_float_SEXP(pnim->quatern_d); break;
	case 14: /* qoffset_x 14 */
	  return Rnifti_float_SEXP(pnim->qoffset_x); break;
	case 15: /* qoffset_y 15 */
	  return Rnifti_float_SEXP(pnim->qoffset_y); break;
	case 16: /* qoffset_z 16 */
	  return Rnifti_float_SEXP(pnim->qoffset_z); break;
	case 17: /* qfac 17 */
	  return Rnifti_float_SEXP(pnim->qfac); break;
	case 18: /* pixdim 18 */
	  if(pnim->dim[0]<8)
	    {
	      PROTECT(ret_val=NEW_NUMERIC(pnim->dim[0]));
	      for(iIndex=0;iIndex<pnim->dim[0];++iIndex)
		{
		  NUMERIC_POINTER(ret_val)[iIndex]=pnim->pixdim[iIndex+1];
		}
	      UNPROTECT(1);
	    }
	  else
	    error("number of dimensions (dim[0]) > 7!\n");
	  break;
	case 19: /* nifti_type 19 */
	  switch(pnim->nifti_type)
	    {
	    case NIFTI_FTYPE_ANALYZE:
	      return Rnifti_pchar_SEXP("NIFTI.FTYPE.ANALYZE"); break;
	    case NIFTI_FTYPE_NIFTI1_1:
	      return Rnifti_pchar_SEXP("NIFTI.FTYPE.NIFTI1.1"); break;
	    case NIFTI_FTYPE_NIFTI1_2:
	      return Rnifti_pchar_SEXP("NIFTI.FTYPE.NIFTI1.2"); break;
	    case NIFTI_FTYPE_ASCII:
	      return Rnifti_pchar_SEXP("NIFTI.FTYPE.ASCII"); break;
	    default:
	      return Rnifti_pchar_SEXP("NIFTI.FTYPE.UNKNOWN"); break;
	    }
	  break;
	case 20: /* sizeof_hdr 20 */
	  {
	    struct nifti_1_header hdr = nifti_convert_nim2nhdr(pnim);
	    return int_to_SEXP(hdr.sizeof_hdr);
	  }
	  break;
	case 21: /* datatype */
	  return int_to_SEXP(pnim->datatype);
	  break;	
	case 22: /* scl_slope nifti1: Data scaling: slope.  analyze 7.5: float funused1 */
	  return Rnifti_float_SEXP(pnim->scl_slope);
	  break;	
	case 23: /* scl_inter nifti1: Data scaling: offset. analyze 7.5: float funused2 */
	  return Rnifti_float_SEXP(pnim->scl_inter);
	  break;							
	default:
	  error("Rnifti_image_getattribute: unknown symbol\n"); break;
	  
	}
      //Rprintf("symbol: %d\n",is_symbol(sym));			
    }
  else
    error("Rnifti_image_getattribute: not a pointer to a nifti object.\n");
  return ret_val;
}

/** @brief Copy the nifti_image structure, without data.

    Duplicate the structure, including fname, iname and extensions.
    Leave the data pointer as NULL.
*/
SEXP Rnifti_image_copy_info(SEXP nim)
{
  SEXP ret_val=R_NilValue;
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {
      nifti_image *pnew_nim=nifti_copy_nim_info(pnim);
      ret_val = R_MakeExternalPtr(pnew_nim,NIFTI_type_tag, R_NilValue);
      R_RegisterCFinalizer(ret_val,(R_CFinalizer_t) Rnifti_image_free);
      
      // set class attribute to nifti
      SEXP classattrib;
      PROTECT(classattrib = allocVector(STRSXP, 1));
      SET_STRING_ELT(classattrib, 0, mkChar("nifti"));
      classgets(ret_val, classattrib);
      UNPROTECT(1);
    }
  else
    error("nifti_image_copy_info: object is not a nifti image");
  return ret_val;
}

SEXP Rnifti_image_read(SEXP file, SEXP read_data)
{
  nifti_image *pnim;
  PROTECT(read_data = AS_INTEGER(read_data));
  PROTECT(file = AS_CHARACTER(file));
  if(!isString(file) || length(file) != 1)
    error("Rnifti_image_read: file is not a single string\n");
  if(length(read_data) != 1)
    error("Rnifti_image_read: read_data is not a single integer\n");
  int *piread_data = INTEGER_POINTER(read_data);
  const char *pcfilename  = CHAR(STRING_ELT(file , 0));
  pnim = nifti_image_read( pcfilename , piread_data[0] ) ;
  if(pnim==NULL)
    {
      error("Rnifti_image_read: Can not open file \"%s\"",pcfilename);
      UNPROTECT(2);
      return R_NilValue;
    }
  
  SEXP nim = R_MakeExternalPtr(pnim,NIFTI_type_tag, R_NilValue);
  R_RegisterCFinalizer(nim,(R_CFinalizer_t) Rnifti_image_free);
  
  // set class attribute to PAC::ImageBase
  SEXP classattrib;
  PROTECT(classattrib = allocVector(STRSXP, 1));
  SET_STRING_ELT(classattrib, 0, mkChar("nifti"));
  classgets(nim, classattrib);
  UNPROTECT(3);
  return nim;
}

SEXP Rnifti_image_write(SEXP nim)
{
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {
      nifti_image_write(pnim);
    }
  return R_NilValue;
}

SEXP Rnifti_image_getdim(SEXP nim)
{
  SEXP ret_val=R_NilValue;
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {
      int i;
      PROTECT(ret_val = NEW_INTEGER(pnim->dim[0]));
      for(i=0;i<pnim->dim[0];++i)
	INTEGER(ret_val)[i]=pnim->dim[i+1];
      UNPROTECT(1);
    }	
  return ret_val;
}

SEXP Rnifti_image_getpixdim(SEXP nim)
{
  SEXP ret_val=R_NilValue;
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {
      int i;
      PROTECT(ret_val = NEW_NUMERIC(pnim->dim[0]));
      for(i=0;i<pnim->dim[0];++i)
	NUMERIC_POINTER(ret_val)[i]=pnim->pixdim[i+1];
      UNPROTECT(1);
    }	
  return ret_val;
}


SEXP Rnifti_image_getpixel(SEXP nim,
			SEXP sexp_x, SEXP sexp_y, 
			SEXP sexp_z, SEXP sexp_t,
			SEXP sexp_dim5, SEXP sexp_dim6, SEXP sexp_dim7)
{
  SEXP ret_val=R_NilValue;
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
  {
    SEXP coord[7];
    PROTECT(coord[0] = AS_INTEGER(sexp_x));
    PROTECT(coord[1] = AS_INTEGER(sexp_y));
    PROTECT(coord[2] = AS_INTEGER(sexp_z));
    PROTECT(coord[3] = AS_INTEGER(sexp_t));
    
    PROTECT(coord[4] = AS_INTEGER(sexp_dim5));
    PROTECT(coord[5] = AS_INTEGER(sexp_dim6));
    PROTECT(coord[6] = AS_INTEGER(sexp_dim7));
      
    int iDim,outdim=0;
    int *iCoord[7];
    for(iDim=0;iDim<7;++iDim)
	{
	  if(LENGTH(coord[iDim])>1) outdim++;
	  iCoord[iDim]=INTEGER(coord[iDim]);
	}
      
    int iCoordCounter;
    for(iDim=0;iDim<7;++iDim)
	  for(iCoordCounter=0;iCoordCounter<LENGTH(coord[iDim]);++iCoordCounter)
	    if(   iCoord[iDim][iCoordCounter]<0 || iCoord[iDim][iCoordCounter]>(int)pnim->dim[iDim+1])
	    {
	      error("nifti: index out of range\n");
	      UNPROTECT(7);
	      return ret_val; 
	    }
      
    PROTECT(ret_val = NEW_NUMERIC(LENGTH(sexp_x)*LENGTH(sexp_y)*LENGTH(sexp_z)*LENGTH(sexp_t)));
    int iIndex[7], iTOffset=0, iSOffset=0;
    /* do type checking outside the main loop to speedup processing...*/
    switch(pnim->datatype)
	{
	/* uchar (8 bits) */
	case DT_UNSIGNED_CHAR:
		for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
		  for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		    for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])			
	          for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	            for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	              for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
		            for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
		            {
		            	iSOffset=  iCoord[0][iIndex[0]]
		            	         + iCoord[1][iIndex[1]]*pnim->dim[1]
		            	         + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
		            	         + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
		            			 + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
                                 + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
                                 + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
		            	NUMERIC_POINTER(ret_val)[iTOffset] = (double)((unsigned char*)pnim->data)[iSOffset];
		            	++iTOffset;
		            }
		break;
	/* signed char (8 bits) */
	case DT_INT8:
		for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
		  for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		    for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])			
	          for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	            for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	              for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
		            for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
		            {
		            	iSOffset=  iCoord[0][iIndex[0]]
		            	         + iCoord[1][iIndex[1]]*pnim->dim[1]
		            	         + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
		            	         + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
		            			 + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
	                                + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
	                                + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
		            	NUMERIC_POINTER(ret_val)[iTOffset] = (double)((signed char*)pnim->data)[iSOffset];
		            	++iTOffset;
		            }
		break;
	/* unsigned short (16 bits) */
	case DT_UINT16:
		for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
		  for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		    for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])			
	          for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	            for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	              for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
		            for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
		            {
		            	iSOffset=  iCoord[0][iIndex[0]]
		            	         + iCoord[1][iIndex[1]]*pnim->dim[1]
		            	         + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
		            	         + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
		            			 + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
	                             + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
	                             + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
		            	NUMERIC_POINTER(ret_val)[iTOffset] = (double)((unsigned short*)pnim->data)[iSOffset];
	                    ++iTOffset;
		            }
	     break;		
	/* signed short (16 bits) */
	case DT_SIGNED_SHORT:
		for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
		  for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		    for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])			
	          for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	            for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	              for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
		            for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
		            {
		            	iSOffset=  iCoord[0][iIndex[0]]
		            	         + iCoord[1][iIndex[1]]*pnim->dim[1]
		            	         + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
		            	         + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
		            			 + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
                                 + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
                                 + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
		            	NUMERIC_POINTER(ret_val)[iTOffset] = (double)((short*)pnim->data)[iSOffset];
                        ++iTOffset;
		            }
	     break;
	/* unsigned int (32 bits) */
	case DT_UINT32:
		for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
		  for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		    for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])			
	          for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	            for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	              for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
		            for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
		            {
		            	iSOffset=  iCoord[0][iIndex[0]]
		            	         + iCoord[1][iIndex[1]]*pnim->dim[1]
		            	         + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
		            	         + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
		            			 + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
	                             + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
	                             + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];			          
		            	NUMERIC_POINTER(ret_val)[iTOffset] = (double)((unsigned int*)pnim->data)[iSOffset];
		            	++iTOffset;	
		            }
		  break;  
	/* signed int (32 bits) */
	case DT_SIGNED_INT:
		for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
		  for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		    for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])			
	          for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	            for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	              for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
		            for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
		            {
		            	iSOffset=  iCoord[0][iIndex[0]]
		            	         + iCoord[1][iIndex[1]]*pnim->dim[1]
		            	         + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
		            	         + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
		            			 + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
                                 + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
                                 + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];			          
		            	NUMERIC_POINTER(ret_val)[iTOffset] = (double)((int*)pnim->data)[iSOffset];
		            	++iTOffset;	
		            }
	  break;
	/* float (32 bits) */ 
	case DT_FLOAT:
		for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
		  for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		    for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])			
	          for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	            for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	              for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
		            for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
		            {
		            	iSOffset=  iCoord[0][iIndex[0]]
		            	         + iCoord[1][iIndex[1]]*pnim->dim[1]
		            	         + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
		            	         + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
		            			 + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
                                 + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
                                 + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];			          
		            	NUMERIC_POINTER(ret_val)[iTOffset] = (double)((float*)pnim->data)[iSOffset];
		            	++iTOffset;
		            }
	  break;
	/* double (64 bits) */
	case DT_DOUBLE:
		for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
		  for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		    for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])			
	          for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	            for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	              for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
		            for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
		            {
		            	iSOffset=  iCoord[0][iIndex[0]]
		            	         + iCoord[1][iIndex[1]]*pnim->dim[1]
		            	         + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
		            	         + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
		            			 + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
                                 + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
                                 + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];			          
		            	NUMERIC_POINTER(ret_val)[iTOffset] = (double)((double*)pnim->data)[iSOffset];
		            	++iTOffset;
		            }			 			
	  break;
	default:
	  warning("unsupported data format (identifier %d)",pnim->datatype);
	}
    /*Rprintf("outdim=%d\n",outdim);*/
    /* set the dimension attribute */
    if(outdim>1)
	{
	  SEXP dim;
	  PROTECT(dim=NEW_INTEGER(outdim));
	  int iDimCount=0;
	  for(iDim=0;iDim<7;++iDim)
	  {
	      /*Rprintf("length[%d]=%d\n",iDim,LENGTH(coord[iDim]));*/
	      if(LENGTH(coord[iDim])>1) 
	      {
		    INTEGER_POINTER(dim)[iDimCount++]=LENGTH(coord[iDim]);
		  }
	  }
	  SET_DIM(ret_val,dim);
	  UNPROTECT(1);
	}
    UNPROTECT(8);
  }
  return ret_val;	
}

SEXP Rnifti_image_printinfo(SEXP nim)
{
  int iIndex;
  SEXP ret_val=R_NilValue;
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {
      Rprintf("dimension: ");
      for(iIndex=0;iIndex<pnim->dim[0];++iIndex)
	    Rprintf("%d ",pnim->dim[iIndex+1]);
      Rprintf("\n");
      
      Rprintf("dimensions: freq = %d, phase = %d, slice = %d\n",
	      pnim->freq_dim, pnim->phase_dim, pnim->slice_dim);
      if(pnim->qform_code!=NIFTI_XFORM_UNKNOWN)
	{
	  int icod, jcod, kcod;
	  nifti_mat44_to_orientation( pnim->qto_xyz , &icod, &jcod, &kcod );
	  Rprintf("i orientation (voxel x-axis): %s\n",nifti_orientation_string(icod));
	  Rprintf("j orientation (voxel y-axis): %s\n",nifti_orientation_string(jcod));
	  Rprintf("k orientation (voxel z-axis): %s\n",nifti_orientation_string(kcod));
	}
      int c;
      Rprintf("number of nifti ext. : %d\n",pnim->num_ext);
      for (c = 0; c < pnim->num_ext; c++ )
	{
	  Rprintf("%d] size: %d code: %d",c,pnim->ext_list[c].esize,pnim->ext_list[c].ecode);
	  switch(pnim->ext_list[c].ecode)
	    {
	    case NIFTI_ECODE_IGNORE:
	      Rprintf("(ignore /unknown)\n");
	      break;
	    case NIFTI_ECODE_DICOM:
	      Rprintf("(raw DICOM attributes)\n");
	      break;
	    case NIFTI_ECODE_AFNI:
	      Rprintf("(Robert W Cox: http://afni.nimh.nih.gov/afni)\n");
	      break;		
	    case NIFTI_ECODE_COMMENT:
	      Rprintf("(plain ASCII text)\n");
	      break;
	    case NIFTI_ECODE_XCEDE:
	      Rprintf("(David B Keator: http://www.nbirn.net/Resources/Users/Applications/xcede/index.htm)\n");
	      break;		
	    case NIFTI_ECODE_JIMDIMINFO:
	      Rprintf("(Mark A Horsfield: http://someplace/something)\n");
	      break;
	    case NIFTI_ECODE_WORKFLOW_FWDS:
	      Rprintf("(Kate Fissell: http://kraepelin.wpic.pitt.edu)\n");
	      break; 	
	    default:
	      Rprintf("(unknown NIFTI_ECODE)\n");
	      break;	
	    }
	}
      switch(pnim->datatype)
	{
	  /*--- the original ANALYZE 7.5 type codes ---*/
	case  DT_BINARY:           /*  1      binary (1 bit/voxel)         */
	  Rprintf(" data type: 1 binary (1 bit/voxel)\n"); 
	  break;
	case  DT_UNSIGNED_CHAR:    /*  2      unsigned char (8 bits/voxel) */
	  Rprintf(" data type: 2 unsigned char (8 bits/voxel)\n"); 
	  break;
	case  DT_SIGNED_SHORT:     /*  4      signed short (16 bits/voxel) */
	  Rprintf(" data type: 4 signed short (16 bits/voxel)\n"); 
	  break;
	case  DT_SIGNED_INT:       /*  8      signed int (32 bits/voxel)   */
	  Rprintf(" data type: 8 signed int (32 bits/voxel)\n"); 
	  break;
	case  DT_FLOAT:            /* 16      float (32 bits/voxel)        */
	  Rprintf(" data type: 16 float (32 bits/voxel)\n"); 
	  break;
	case  DT_COMPLEX:          /* 32      complex (64 bits/voxel)      */
	  Rprintf(" data type: 32 complex (64 bits/voxel)\n"); 
	  break;
	case  DT_DOUBLE:           /* 64      double (64 bits/voxel)       */
	  Rprintf(" data type: 64 double (64 bits/voxel) \n"); 
	  break;
	case  DT_RGB:              /*128      RGB triple (24 bits/voxel)   */
	  Rprintf(" data type: 128 RGB triple (24 bits/voxel)\n");
	  break;
	  
	  /*------------------- new codes for NIFTI ---*/
	case  DT_INT8:             /* 256      signed char (8 bits)         */
	  Rprintf(" data type: 256 signed char (8 bits)\n"); 
	  break;
	case  DT_UINT16:           /* 512      unsigned short (16 bits)     */
	  Rprintf(" data type: 512 unsigned short (16 bits)\n"); 
	  break;
	case  DT_UINT32:           /* 768      unsigned int (32 bits)       */
	  Rprintf(" data type: 768 unsigned int (32 bits)\n"); 
	  break;
	case  DT_INT64:            /*1024      long long (64 bits)          */
	  Rprintf(" data type: 1024 long long (64 bits)\n"); 
	  break;
	case  DT_UINT64:           /*1280      unsigned long long (64 bits) */
	  Rprintf(" data type: 1280 unsigned long long (64 bits)\n");
	  break;
	case  DT_FLOAT128:         /*1536      long double (128 bits)       */
	  Rprintf(" data type: 1536 long double (128 bits)\n");
	  break;
	case  DT_COMPLEX128:       /*1792      double pair (128 bits)       */
	  Rprintf(" data type: 1792 double pair (128 bits)\n");
	  break;
	case  DT_COMPLEX256:       /*2048      long double pair (256 bits)  */
	  Rprintf(" data type: 2048 long double pair (256 bits)\n");
	  break;
	default:              	   /*         what it says, dude           */
	  Rprintf(" data type: %u what it says, dude\n",pnim->datatype); 
	  break;
	}
    }
  Rprintf("intent: %s\n",nifti_intent_string(pnim->intent_code));
  Rprintf("attributes: (accessible via $ operator)\n");
  for(iIndex=0;Rnifti_attributes[iIndex]!=NULL;++iIndex)
    {
      if(iIndex!=0)
	{
	  if(iIndex%5==0)
	    Rprintf("\n");
	  else
	    Rprintf("; ");
	}
      Rprintf("\"%s\"",Rnifti_attributes[iIndex]);		  
    }
  Rprintf("\n");
  return ret_val;
}

SEXP Rnifti_image_setpixel(
		SEXP nim, 
		SEXP sexp_x, SEXP sexp_y, 
		SEXP sexp_z, SEXP sexp_t, 
		SEXP sexp_dim5, SEXP sexp_dim6, SEXP sexp_dim7,
		SEXP value)
{
  SEXP ret_val=R_NilValue;
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
  {
      /*PROTECT(sexp_x = AS_INTEGER(sexp_x));
	PROTECT(sexp_y = AS_INTEGER(sexp_y));
	PROTECT(sexp_z = AS_INTEGER(sexp_z));
	PROTECT(sexp_t = AS_INTEGER(sexp_t));
	int x=INTEGER(sexp_x)[0];
	int y=INTEGER(sexp_y)[0];
	int z=INTEGER(sexp_z)[0];
	int t=INTEGER(sexp_t)[0];*/
      
    SEXP coord[7];
    PROTECT(coord[0] = AS_INTEGER(sexp_x));
    PROTECT(coord[1] = AS_INTEGER(sexp_y));
    PROTECT(coord[2] = AS_INTEGER(sexp_z));
    PROTECT(coord[3] = AS_INTEGER(sexp_t));
      
    PROTECT(coord[4] = AS_INTEGER(sexp_dim5));
    PROTECT(coord[5] = AS_INTEGER(sexp_dim6));
    PROTECT(coord[6] = AS_INTEGER(sexp_dim7));
      
    int iDim,outdim=0;
    int *iCoord[7];
    for(iDim=0;iDim<7;++iDim)
	{
	  if(LENGTH(coord[iDim])>1) outdim++;
	  iCoord[iDim]=INTEGER(coord[iDim]);
	}
      
    int iCoordCounter;
    for(iDim=0;iDim<7;++iDim)
	  for(iCoordCounter=0;iCoordCounter<LENGTH(coord[iDim]);++iCoordCounter)
	    if(   iCoord[iDim][iCoordCounter]<0 
	       || iCoord[iDim][iCoordCounter]>(int)pnim->dim[iDim+1])
	    {
	      error("nifti: index out of range\n");
	      UNPROTECT(4);
	      return ret_val; 
	    }
    int iIndex[7], iTOffset=0, iSOffset=0;
      /*
	if(   x<0 || x>=(int)pnim->dim[1]
	|| y<0 || y>=(int)pnim->dim[2] 
	|| z<0 || z>=(int)pnim->dim[3]
	|| t<0 || t>=(int)pnim->dim[4])
	error("Rnifti_image_setpixel: index out of range\n");	
	else
	{	*/
    switch(pnim->datatype)
	{
	/* uchar (8 bits) */
	case DT_UNSIGNED_CHAR: 	 
	  for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
        for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		  for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])
			for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	          for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	            for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
		          for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
		          {		            
		            iTOffset =  iCoord[0][iIndex[0]]
	            	          + iCoord[1][iIndex[1]]*pnim->dim[1]
		            		  + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
		            		  + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
		            		  + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
		                      + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
		                      + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
		            ((unsigned char*)pnim->data)[iTOffset]=(unsigned char)(NUMERIC_POINTER(value)[iSOffset]);
		            ++iSOffset;
		          }	
	  break;
    /* signed char (8 bits) */
	case DT_INT8:
	  for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
	    for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		  for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])
			for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
		      for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
		        for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
			      for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
			      {		            
			        iTOffset =  iCoord[0][iIndex[0]]
		          	          + iCoord[1][iIndex[1]]*pnim->dim[1]
			           		  + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
			           		  + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
			           		  + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
			                  + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
			                  + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
			        ((signed char*)pnim->data)[iTOffset]=(signed char)(NUMERIC_POINTER(value)[iSOffset]);
			        ++iSOffset;
			      }	
		  break;	
	/* unsigned short (16 bits) */
	case DT_UINT16:	  
	  for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
	    for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		  for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])
			for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
		      for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
		        for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
			      for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
			      {		            
			        iTOffset =  iCoord[0][iIndex[0]]
		           	          + iCoord[1][iIndex[1]]*pnim->dim[1]
			           		  + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
			           		  + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
			           		  + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
			                  + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
			                  + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
			        ((unsigned short*)pnim->data)[iTOffset]=(unsigned short)(NUMERIC_POINTER(value)[iSOffset]);
			        ++iSOffset;
			      }
	  break;
	// signed short (16 bits)
	case DT_SIGNED_SHORT:
	  //((short*)pnim->data)[x+y*pnim->dim[1]+z*pnim->dim[1]*pnim->dim[2]+t*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]]=(short)NUMERIC_POINTER(value)[0];
	  for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
	    for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		  for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])
			for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
		      for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
		        for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
			      for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
			      {		            
			        iTOffset =  iCoord[0][iIndex[0]]
		           	          + iCoord[1][iIndex[1]]*pnim->dim[1]
			           		  + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
			           		  + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
			           		  + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
			                  + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
			                  + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
		    		((short*)pnim->data)[iTOffset]=(short)(NUMERIC_POINTER(value)[iSOffset]);
		    		++iSOffset;
			      }				  
	  break;
	// signed int (32 bits)
	case DT_SIGNED_INT:
	  for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
	    for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		  for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])
			for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
		      for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
		        for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
			      for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
			      {		            
			        iTOffset =  iCoord[0][iIndex[0]]
		           	          + iCoord[1][iIndex[1]]*pnim->dim[1]
			           		  + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
			           		  + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
			           		  + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
			                  + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
			                  + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
			        ((int*)pnim->data)[iTOffset]=(int)(NUMERIC_POINTER(value)[iSOffset]);
			        ++iSOffset;
			      }
	  break;
    /* unsigned int (32 bits) */	  
	case DT_UINT32:
	  for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
	    for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		  for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])
			for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
		      for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
		        for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
			      for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
			      {		            
			        iTOffset =  iCoord[0][iIndex[0]]
		           	          + iCoord[1][iIndex[1]]*pnim->dim[1]
			           		  + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
			           		  + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
			           		  + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
			                  + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
			                  + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
			        ((unsigned int*)pnim->data)[iTOffset]=(unsigned int)(NUMERIC_POINTER(value)[iSOffset]);
			        ++iSOffset;
			      }
	  break;
	/* float (32 bits) */
	case DT_FLOAT:
	  for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
	    for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
		  for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])
			for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
		      for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
		        for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
			      for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
			      {		            
			        iTOffset =  iCoord[0][iIndex[0]]
		           	          + iCoord[1][iIndex[1]]*pnim->dim[1]
			           		  + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
			           		  + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
			           		  + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
			                  + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
			                  + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];			          
			        ((float*)pnim->data)[iTOffset]=(float)(NUMERIC_POINTER(value)[iSOffset]);
			        ++iSOffset;
			      }
	  break;
    // double (64 bits)
	case DT_DOUBLE:
	  for(iIndex[6]=0;iIndex[6]<LENGTH(coord[6]);++iIndex[6])
	  	    for(iIndex[5]=0;iIndex[5]<LENGTH(coord[5]);++iIndex[5])
	  		  for(iIndex[4]=0;iIndex[4]<LENGTH(coord[4]);++iIndex[4])
	  			for(iIndex[3]=0;iIndex[3]<LENGTH(coord[3]);++iIndex[3])
	  		      for(iIndex[2]=0;iIndex[2]<LENGTH(coord[2]);++iIndex[2])
	  		        for(iIndex[1]=0;iIndex[1]<LENGTH(coord[1]);++iIndex[1])
	  			      for(iIndex[0]=0;iIndex[0]<LENGTH(coord[0]);++iIndex[0])
	  			      {		            
	  			        iTOffset =  iCoord[0][iIndex[0]]
	  		           	          + iCoord[1][iIndex[1]]*pnim->dim[1]
	  			           		  + iCoord[2][iIndex[2]]*pnim->dim[1]*pnim->dim[2]
	  			           		  + iCoord[3][iIndex[3]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]
	  			           		  + iCoord[4][iIndex[4]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]
	  			                  + iCoord[5][iIndex[5]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]
	  			                  + iCoord[6][iIndex[6]]*pnim->dim[1]*pnim->dim[2]*pnim->dim[3]*pnim->dim[4]*pnim->dim[5]*pnim->dim[6];
	  			        ((double*)pnim->data)[iTOffset]=(double)(NUMERIC_POINTER(value)[iSOffset]);
	  			        ++iSOffset;
	  			      }
	  break;
	default:
	  warning("unsupported data format (identifier %d)",pnim->datatype);
	}
    UNPROTECT(4);
  }	
  return nim;
}

SEXP Rnifti_image_setdatatype(SEXP nim, SEXP value)
{
  nifti_image *pnim=SEXP2NIFTI(nim);
  
  if(pnim!=NULL)
    {
      PROTECT(value = AS_INTEGER(value));
      pnim->datatype=INTEGER(value)[0];
      UNPROTECT(1);
    }
  return nim;
}


SEXP Rnifti_compiled_with_zlib(void)
{
  SEXP ret_val=R_NilValue;
  
  PROTECT(ret_val=NEW_LOGICAL(1));
  LOGICAL_POINTER(ret_val)[0]=nifti_compiled_with_zlib();
  UNPROTECT(1);
  
  return ret_val;
}

SEXP Rnifti_disp_lib_version(void)
{
	SEXP ret_val=R_NilValue;
	char buffer[200];
	
    snprintf(buffer, 200, "%s, compiled %s", nifti_disp_lib_version(), __DATE__);
    	
	PROTECT(ret_val = NEW_CHARACTER(1));
    SET_STRING_ELT(ret_val, 0, mkChar(buffer));	
	UNPROTECT(1);
		
	return ret_val;
}
