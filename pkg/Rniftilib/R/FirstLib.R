## FirstLib: initialization of Rniftilib
.First.lib <- function(lib, pkg) 
{ 
  library.dynam("Rniftilib", pkg, lib) 
  .Call("Rnifti_init", lib, PACKAGE="Rniftilib")
}

## LastLib: cleanup of GTKTest
.Last.lib <- function(libpath) 
{ 
  library.dynam.unload("Rniftilib", libpath) 
}
