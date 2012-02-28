## FirstLib: initialization of Rniftilib
##.First.lib <- function(lib, pkg) 
##{ 
## library.dynam("Rniftilib", pkg, lib)   
##}

## LastLib: cleanup of Rniftilib
##.Last.lib <- function(libpath) 
##{ 
##  library.dynam.unload("Rniftilib", libpath) 
##}

.onLoad <- function(libname, pkgname)
{
  .Call("Rnifti_init", libname, PACKAGE=pkgname)
}

