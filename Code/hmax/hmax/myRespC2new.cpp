/************************************************************************
** last modified by ezra rosen, 10/02 * this will be the new version to use
** takes into account:
** 1. correct number of s2 units per row/column
** 2. limit pooling
** 3. better commenting
** questions and comments to erosen@mit.edu
*************************************************************************
*************************************************************************
**      
**          MODULE: myRespC2new.c
**
**        FUNCTION: IN: currClip: the image itself
**                          filters:  holds all S1 simple filters, at all possible 
**                          orientations and all scales
**                          fSiz: holds the sizes of all S1 simple filters, at all
**                          possible orientations and all scales
**			    c1SpaceSS: c1 Pooling ranges
**                          c1ScaleSS: s1 Filter ranges		    
**			    c1OL: tells how many c1 cells overlap with each other
**                          angleFlag: always set to 1 for correct s1 normalization
**			    s2Target: set to 1, this is the target value for s2 cells
**			    limitPoolFlag: whether limitPooling is being done
**
**                 OUT: c2Resp: c2Resp, unexponentiated
**                   
**     DESCRIPTION: calculate C2 Responses, without exponentiating them
**                  allows for limitPooling, which basically processes the image
**                  making sure that there are no edge effects.  this is done by
**                  starting the filters at the interior of the image, so no filters
**                  overlap with the outside border.
**
**last modified: 10/04/04
**
*************************************************************************/

/****** DEFINES ******/
/****** INCLUDES ******/
#include "mex.h"
#include <math.h>
/****** GLOBAL VARS ******/
static int offTab[8]={0,0,-1,0,0,-1,-1,-1};

/****** PROTOTYPES ******/
extern double ceil(double);
extern double sqrt(double);
extern double fabs(double);

/****** FUNCTIONS ******/
double sqr(double x)
{
  return(x*x);
}


/* BEGIN */

void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
  double *image,*filters,*fSiz,*spaceSS,*scaleSS;
  int angleFlag,imgy,imgx,filtersY,filtersX,spaceSSY,spaceSSX,scaleSSY,scaleSSX;
  int i,j,k,x,y,bufX,bufY;
  double *buf,*bStart,*currI,*currB,*currF;
  int fx,fy,posX,posY,maxX,maxY;
  double res;
  double imgLen;
  double *retPtr,*rPtr2;
  mxArray *retC2;
  double *ret,*c2Ptr;
  double *sBuf,*sBufPtr,*sPtr2;
  double s2Target,*c1Act,s2Resp,pixVal;
  int maxFS,sSS,scaleInd,numScaleBands,numScales,numSimpleFilters,numPos;
  int fSizX,fSizY,currScale,yS,xS,sFInd,step,c1SpaceOL;
  int f1,f2,f3,f4,c2Ind,maxXY;
  int poolRange,limitPool,xoff,yoff;

  int jumpX, jumpY;
  int *limPoolShift, limPoolCount;
  




  if((nlhs != 1)||(nrhs<8))
    mexErrMsgTxt("syntax: c=myRespC2sum(image,filters,fSiz,c1SpaceSS,c1ScaleSS,c1SpaceOL,angleFlag,s2Target[,limitPool])\n");
  else{
    if(nrhs==8)                 /* no limitPool? */
      limitPool=0;
    else
      limitPool=(int)*(mxGetPr(prhs[8]));
    /* copy and check rhs arguments */
    image=mxGetPr(prhs[0]);     /* first input arg: image */
    imgy=mxGetM(prhs[0]);
    imgx=mxGetN(prhs[0]);
    /*mexPrintf("imgy=%d imgx=%d\n",imgy,imgx);*/
    filters=mxGetPr(prhs[1]);   /* 2nd input arg: filters */
    filtersY=mxGetM(prhs[1]);
    filtersX=mxGetN(prhs[1]);
    fSiz=mxGetPr(prhs[2]);      /* 3rd input arg: fSiz */
    fSizY=mxGetM(prhs[2]);
    fSizX=mxGetN(prhs[2]);
    spaceSS=mxGetPr(prhs[3]);   /* 4th input arg: c1SpaceSS */
    spaceSSY=mxGetM(prhs[3]);
    spaceSSX=mxGetN(prhs[3]);
    scaleSS=mxGetPr(prhs[4]);   /* 5th input arg: c1ScaleSS */
    scaleSSY=mxGetM(prhs[4]);
    scaleSSX=mxGetN(prhs[4]);
    c1SpaceOL=(int)*(mxGetPr(prhs[5])); /* c1SpaceOL determines how many RF per
                                           sampling range*/
    angleFlag=(int)*(mxGetPr(prhs[6]));
    s2Target=*(mxGetPr(prhs[7]));
   
    for(maxFS=0,i=fSizY*fSizX-1;i>=0;i--)
      maxFS=fSiz[i]>maxFS?fSiz[i]:maxFS;
  
    /* for each interval in scaleSS, filter type, go through spaceSS, allocate enough mem
     * to calc all these response fields in S1 & then do max over the required range */
    numScaleBands=scaleSSY*scaleSSX-1;  /* last element is max index + 1 */
    numScales=scaleSS[numScaleBands]-1; 
  
    /* last index in scaleSS contains scale index where next band would start, 
     * i.e., 1 after highest scale!! */
   
    numSimpleFilters=fSizY*fSizX/numScales; 
    /* calculate number of positions for each C-cell */
    numPos=(int)(ceil(imgy/spaceSS[0])*ceil(imgx/spaceSS[0]))*c1SpaceOL*c1SpaceOL;
    /* changed output format; 2D matrix w/ first dim filters, 2nd dim image coords*/
    /* be a little wasteful: in each filter band, allocate enough for smallest
       scale */
    retC2=mxCreateDoubleMatrix(numSimpleFilters*numSimpleFilters*numSimpleFilters*numSimpleFilters,1,mxREAL);
 
    c2Ptr=mxGetPr(retC2);
    ret=mxCalloc(numPos*numScaleBands*numSimpleFilters,sizeof(double));
    sBuf=mxCalloc(numSimpleFilters*imgy*imgx,sizeof(double)); 
    /* s1 activations before pooling over space (sBuf already pools over *scale*) */
    
    
    /* keeps track of the largest filter size on each scaleBand */
    limPoolShift=mxCalloc(numScaleBands, sizeof(int));
    /* calculate largest filter size in each scaleBand 
     * this will be used for offsetting
     * if there's no limitPooling, there's no offset, so these are all 0 */
    for(limPoolCount=0;limPoolCount<numScaleBands;limPoolCount++){
	limPoolShift[limPoolCount]=limitPool?((int)fSiz[numSimpleFilters*((int)scaleSS[limPoolCount+1]-1)-1])/2+((int)fSiz[numSimpleFilters*((int)scaleSS[limPoolCount+1]-1)-1])%2:0; 
    }
    
  
    /*no zeros if limitPooling, so we can make bufX and bufY smaller(size of img itself) */
    bufX= limitPool? imgx : imgx+maxFS;
    bufY= limitPool? imgy : imgy+maxFS;

    buf=mxCalloc(bufX*bufY,sizeof(double));
    /* copy image and pad with zeros to half max filter size 
     * if limitPooling, don't need to displace the currB pointer at all */
    memset(buf,0,bufX*bufY*sizeof(double));
    for(currB=buf+(limitPool?0:(maxFS>>1)*bufY+(maxFS>>1)),currI=image,i=0;i<imgx;i++,currI+=imgy,currB+=bufY)
      memcpy(currB,currI,imgy*sizeof(double));
    /* S1 is calculated by convolving the filter with small sectors of the image
     * C1 takes the maximum (pooling) over lots of S1 units.
     * scaleInd is varied on the outer loop, that changes the ScaleBands
     * currScale varies over the current ScaleBand, ie in ScaleBand 1 this would be 7,9
     * then for each frame you filter the image through all possible filters, ie /\-|.  
     * that's what loop 3 varies.
     * these S1 cells are stored in res, then the max over scalebands is stored in *sBufPtr.
     * thus, sBufPtr contains all of the S1 activations after the max within a scaleband is taken 
     */	      
    for(scaleInd=0;scaleInd<numScaleBands;scaleInd++){
	memset(sBuf,0,numSimpleFilters*imgy*imgx*sizeof(double));
	for(currScale=scaleSS[scaleInd];currScale<scaleSS[scaleInd+1];currScale++){
	   /*   printf("currScale=%d", currScale); */
	    for(sBufPtr=sBuf,sFInd=0;sFInd<numSimpleFilters;sFInd++){
		fy=fx=fSiz[numSimpleFilters*(currScale-1)+sFInd];
		/* eee scale inds start at 1, matlab convention */
		/* this is where limit pooling changes things.  we calculate fewer s1 units, because we
		 * start and end calculating s1 units by a length of xoff and yoff.  These are lengths of 
		 * half of the filter sizes.  also note that calculating fewer s1 units means that there 
		 * should be fewer c1 and s2 units.  Number of c2 units(system output) remains the same.
		 */
		
                /* if there is no limitPooling, jump in by maxFS/2.  if we are limitPooling, only jump in by
		 * the maxFS in a given scale band, to avoid falling off of the edge of the image */ 
		jumpX=limitPool?limPoolShift[scaleInd]:maxFS/2; 	     
		jumpY=limitPool?limPoolShift[scaleInd]:maxFS/2;
                /* without limitPooling, there will be imgx^2 S1 units for all scales.
		 * with limitPooling, though, there will be (imgx-2*limPoolShift[scaleInd])^2 S1 units for all scales.
		 * consequently, when calculating things for C1, S2, and C2, whenever indexing the pointer by the 
		 * size of the S1 units, we use (imgx-2*limPoolShift[scaleInd]).  Then, when not limitPooling, this 
		 * just becomes imgx, and when you are takes on the new dimension of the S1 units as we want */
		for(x=limPoolShift[scaleInd],bStart=buf+jumpX*bufX+jumpY;x<(imgx-limPoolShift[scaleInd]);x++,bStart+=bufX-imgx+limPoolShift[scaleInd]){ 
		 
		    for(y=limPoolShift[scaleInd], bStart+=limPoolShift[scaleInd];y<(imgy-limPoolShift[scaleInd]);y++,bStart++,sBufPtr++){

			/* center filter on current image point */
			/* convolution is just "flip and shift" of the filter and the image
		         * that's all that's really happening here */
			for(res=0,imgLen=0,currB=bStart-fx/2*bufY-fy/2,currF=filters+(sFInd+(currScale-1)*numSimpleFilters)*maxFS*maxFS,j=0;j<fx;j++,currB+=bufY-fy)
			    for(k=0;k<fy;k++){
				pixVal=*currB++;
				imgLen+=pixVal*pixVal;
				res += pixVal**currF++;
			    }
			if(angleFlag && (imgLen>0)) res/=sqrt(imgLen);
			res=fabs(res);
			*sBufPtr = *sBufPtr>res?*sBufPtr:res; 
			/* already do max over scale, so we are actually doing 
			 * a bit of C1 calculation here while we do S1 */
		    }
		}
	    }
	}
	/* now pool(take max) over space, take overlap into account */
	/* take ceiling here otherwise might get more than c1SpaceOL times */
	/* displace pointers by imgx-2*limPoolShift[scaleInd], as described above */
	for(retPtr=ret+numPos*numSimpleFilters*scaleInd,sSS=(int)ceil((double)spaceSS[scaleInd]/c1SpaceOL),poolRange=spaceSS[scaleInd],sFInd=0;sFInd<numSimpleFilters;sFInd++)
	  for(rPtr2=retPtr+numPos*sFInd,xS=0;xS-sSS+poolRange<(imgx-2*limPoolShift[scaleInd]);xS+=sSS)
	    for(yS=0;yS-sSS+poolRange<(imgy-2*limPoolShift[scaleInd]);yS+=sSS,rPtr2++)
	      /* eee still have same pooling range!!
		 division by c1SpaceOL only in stepping of start pos! */
	      for(*rPtr2=0.0,sBufPtr=sBuf+(imgy-2*limPoolShift[scaleInd])*((imgx-2*limPoolShift[scaleInd])*sFInd+xS)+yS,x=xS;(x-xS<poolRange)&&(x<(imgx-2*limPoolShift[scaleInd]));x++)
		for(sPtr2=sBufPtr+(x-xS)*(imgy-2*limPoolShift[scaleInd]),y=yS;(y-yS<poolRange)&&(y<(imgy-2*limPoolShift[scaleInd]));y++,sPtr2++)
		  *rPtr2=*rPtr2>*sPtr2?*rPtr2:*sPtr2;/* *rPtr2 is the maximum of all *sPtr2*/
	
    }
    /* now: do S2 calculation by doing all combinations of features  */
    /* to make things a little more efficient, the outer loop runs over
       the 4 filters that a S2 cell combines, the inner loop does the calculation
       for all pos & filter bands & takes the max (ret contains C2 then w/out exp) */
    /* all S2 values must be between -4 and 0, as each pools over 4 C1 cells */
    /* let's be a little more precise about what's actually happening in these loops.
     * as we compute S2, C2 is constructed on the fly.  Each C2 unit takes the max over
     * all of the S2 units of a certain type over the whole image, over all scale bands as well.
     * the inner three loops compute S2 responses over the x, y range of an image for a specific S2
     * cell type over all scale bands.  the inner two loops vary x and y coordinates, while the 3rd 
     * varies the scale bands.  the maximum of all of these S2 values calculated is one C2 unit.
     * the outer four loops vary the types of S2 units of different types; as there are 4 different 
     * filter orientations and a 2x2=4 square of filters, meaning there are 4^4=256 types of S2 cells,
     * so because there is a 1-1 correspsondence between S2 types and C2 cells, there are 256 C2
     * cells 
     */
    for(c1Act=ret,c2Ind=0,f1=0;f1<numSimpleFilters;f1++)
	for(f2=0;f2<numSimpleFilters;f2++)
	    for(f3=0;f3<numSimpleFilters;f3++)
		for(f4=0;f4<numSimpleFilters;f4++,c2Ind++){
		    for(c2Ptr[c2Ind]=res=-1e10,scaleInd=0;scaleInd<numScaleBands;scaleInd++){
			/*again, as described above, calculate number of S2 units with imgx-2*limPoolShift[sca;eInd]*/
		      for(maxXY=(int)(ceil((imgy-2*limPoolShift[scaleInd])/ceil((double)spaceSS[scaleInd]/c1SpaceOL))),x=c1SpaceOL;x<maxXY;x++)
			    for(y=c1SpaceOL;y<maxXY;y++){
				/* careful to notice that x,y have range of <maxXY because of overlap of units*/
				/* use the fact that exp is monotonous in abs(arg): just pass back
				   max of neg. dist (arg of exp) */
				s2Resp=-(sqr(c1Act[numPos*(scaleInd*numSimpleFilters+f1)+y+maxXY*x]-s2Target)+sqr(c1Act[numPos*(scaleInd*numSimpleFilters+f2)+y+c1SpaceOL*offTab[3]+maxXY*(x+c1SpaceOL*offTab[2])]-s2Target)+sqr(c1Act[numPos*(scaleInd*numSimpleFilters+f3)+y+c1SpaceOL*offTab[5]+maxXY*(x+c1SpaceOL*offTab[4])]-s2Target)+sqr(c1Act[numPos*(scaleInd*numSimpleFilters+f4)+y+c1SpaceOL*offTab[7]+maxXY*(x+c1SpaceOL*offTab[6])]-s2Target));
				
				res=s2Resp>res?s2Resp:res;                  /* max over {x,y} coordinates of image*/
			    }
			c2Ptr[c2Ind]=c2Ptr[c2Ind]>res?c2Ptr[c2Ind]:res; /* max the {x,y}max over scale */
		    }
		}
    
    plhs[0]=retC2; /*this is the output of the mex file*/
    mxFree(sBuf);
    mxFree(buf);
    mxFree(ret);
  }
}
/* END */







