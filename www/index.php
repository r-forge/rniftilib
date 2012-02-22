
<!-- This is the project specific website template -->
<!-- It can be changed as liked or replaced by other content -->

<?php

$domain=ereg_replace('[^\.]*\.(.*)$','\1',$_SERVER['HTTP_HOST']);
$group_name=ereg_replace('([^\.]*)\..*$','\1',$_SERVER['HTTP_HOST']);
$themeroot='http://r-forge.r-project.org/themes/rforge/';

echo '<?xml version="1.0" encoding="UTF-8"?>';
?>
<!DOCTYPE html
	PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en   ">

  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title><?php echo $group_name; ?></title>
	<link href="<?php echo $themeroot; ?>styles/estilo1.css" rel="stylesheet" type="text/css" />
  </head>

<body>

<!-- R-Forge Logo -->
<table border="0" width="100%" cellspacing="0" cellpadding="0">
<tr><td>
<a href="/"><img src="Rniftilib_logo.png" border="0" alt="Rniftilib Logo" /> </a> </td> </tr>
</table>

<!-- get project title  -->
<!-- own website starts here, the following may be changed as you like -->

<h1>Welcome to the Rniftilib project!</h1>
<p>
<a href="http://r-forge.r-project.org/projects/rniftilib/">Rniftilib</a> provides an R-interface to the NIfTI reference implementation the <a href="http://niftilib.sourceforge.net/">niftilib C-library</a>.
</p>

<p>
The NIfTI reference implementation is a library for reading and writing files in the nifti-1 data format. 
The nifti-1 file format is a binary file format for storing medical image data and corresponding meta information,
e.g. transformation matrices, data type, image modality.
The image format is often used for analyzing magnetic resonance image (MRI) and functional MRI (fMRI) brain images.
</p>
<p>
Additional information about the reference implementation  and the <a href="http://nifti.nimh.nih.gov/nifti-1">NIfTI data format</a> can be found on the 
<a href="http://nifti.nimh.nih.gov">Neuroimaging Informatics Technology Initiative</a> homepage.
</p>

<!-- end of project description -->

<p>Further information as well as source and binary packages can be found on the <a href="http://r-forge.r-project.org/projects/rniftilib/">project summary page</a>.</p>
<hr />
<h2 class="headline">Rniftitools: software package based on Rniftilib</h2>
<p>This is a software package to trace the head surface from MRI image data and generate a triangle mesh surface.
This software was originally used in a <a href="http://en.wikipedia.org/wiki/Transcranial_magnetic_stimulation"> transcranial magnetic stimulation (TMS)</a> 
experiment to find a good stimulation site. This software is experimental research software and should be use with caution!
</p>
<h3>References</h3>
<p><b>Phonological decisions require both the left and right supramarginal gyri</b>; Hartwigsen G, Baumgaertner A, Price CJ, Koehnke M, Ulmer S, Siebner HR.; 
Proc Natl Acad Sci U S A. 2010 Sep 21;107(38):16494-9. Epub 2010 Aug 31. PMID: <a href="http://www.ncbi.nlm.nih.gov/pubmed?term=PMID%3A%2020807747">20807747</a><p>
<h3>Downloads</h3>
<p>Package source code  : <a href="Rniftitools_0.0-1.tar.gz">Rniftitools_0.0-1.tar.gz</a>  User manual : <a href="Rniftitools_0.0-1.pdf">Rniftitools_0.0-1.pdf</a></p>
<img src="nifti_iconBlue_small.png" border="0" alt="* " />
</body>
</html>
