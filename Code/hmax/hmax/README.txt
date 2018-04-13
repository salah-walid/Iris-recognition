=======================
last modified: 10/04/04
=======================

This tarball contains the C/Matlab code of the HMAX model and is
available at
	  http://riesenhuberlab.neuro.georgetown.edu/hmax/code.html#Cmatlab


To understand the computation of the HMAX model, it will help to read
the original HMAX paper [1].


DISCLAIMER OF WARRANTY 
======================
The programs provided in this tarball are provided `as is' without
warranty of any kind. We make no warranties, express or implied, that
the programs are free of error, or are consistent with any particular
standard of merchantability, or that they will meet your requirements
for any particular application. They should not be relied upon for
solving a problem whose incorrect solution could result in injury to a
person or loss of property. If you do use the programs or procedures
in such a manner, it is at your own risk. The authors disclaim all
liability for direct, incidental or consequential damages resulting
from your use of the programs on this website.



How to use the code:
====================

- do "mex myRespC2new.c" (that's the mex function to calculate the C2
  activations) to compile the mex .c file into a .mex* or .dll for
  your platform 
- start MATLAB
- type "main" to run the demo program, which loads in an image
  (testImage.gray) and calculates the C2 responses for it (which are
  stored in c2Resp afterwards). 


The components in this tarball:
===============================

Computation of C2 activation

- c2Act = calcCSSITC2new(currClip,limitPoolFlag)
  calcCSSITC2new is the MATLAB function to calculate the C2 responses
  (which it returns). It calls myRespC2new, which does the actual
  computation. The arguments are:
  - currClip: the image (a 2d array) to calculate the C2 activity for
  - limitPoolFlag (optional):  boolean whether to limitPool
    * for limitPool=0, S1 receptive fields are centered at each pixel
      (in which case the image is zero-padded because some S1 cell
      receptive fields extend outside the image; this is the original
      version of the model) or 
    * for limitPool=1, C1 activity is only based on S1 cells whose
      receptive fields lie completely within the image. This parameter
      is useful if you work with images that have nonzero backgrounds.
   Additionally, the function needs the global variables mentioned below.

- myRespC2new: called by calcCSSITC2new, does the actual computation
  of activations. This mex function needs to be compiled.


... additionally

- main: demonstrates how to use HMAX. It loads an image, displays it
  and computes the C2 response for it.

- init_HMAX: initializes the necessary parameters for HMAX (see
  below). Adjust it to your needs or take it as an example.

- [] = init_filters(whichFilter,minFS,maxFS,sSFS)
  initializes the S1 simple filters.

  whichFilter can be
  - 'gaussian': second derivative of a Gaussian. Those are the
    		standard filters, and the filters used to generate
		the simulations for the "many feature" version of the model
		in [1] and subsequent papers. The Methods section in [1] 
		erroneously referred to the filters as first derivative of
		Gaussian. However, results using first derivative of
		Gaussian (whichFilter='gaussian1st')  are comparable in
		terms of VTU selectivity and invariance ranges for the
		paperclip benchmark.
  - 'gabor':    Gabor filters with parameters chosen to better fit
    		experimental data on V1 simple and complex cell tuning
		properties. For more information, see [2].

  optional arguments are (only if Gaussians are used):
  - minFS: size of smallest filter, default is 7
  - maxFS: size of largest filter, default is 29 for Gaussian filters
  - sSFS:  filters of sizes minFS:sSFS:maxFS are computed; default is 2



The following global variables are necessary for the C2 computation:
====================================================================

filters
 holds all S1 simple filters, at all possible orientations and all
 scales
 The ith (square) filter of size filtSize is
 reshape(filters(1:(filtSize*filtSize),i),filtSize,filtSize), 
 i.e. the filters are kept as column vectors of length
 maxFSF*maxFSF. For a filter of size s, The first s*s elements of the
 vector contain the filter, the rest is padding.

fSiz
 holds the sizes of all S1 simple filters, at all possible orientations and all scale

c1SpaceSS
 C1 Pooling ranges (spatial pooling)

c1ScaleSS
 S1 Filter ranges (pooling over scale)

c1OL
 tells how many C1 cells overlap with each other

s2Sigma
 tuning width of C2 units

s2Target
 set to 1, this is the target value for s2 cells



References:
===========

[1] Riesenhuber, M., and Poggio, T. 
   Hierarchical Models of Object Recognition in Cortex. 
   Nature Neuroscience 2 , 1019-1025 (1999).

[2] Serre, T., and Riesenhuber, M.
   Realistic Modeling of Simple and Complex Cell Tuning in the HMAX
   Model, and Implications for Invariant Object Recognition in
   Cortex
   CBCL Paper #239/AI Memo #2004-017  
   Massachusetts Institute of Technology (2004)

