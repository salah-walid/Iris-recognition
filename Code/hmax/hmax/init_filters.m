% function init_filters(whichFilter [,minFS,maxFS,sSFS])
% 
% generates filters for hmax, stored in the global variable
% 'filters' such that each column of filters holds a filter (in the
% rows 1:filter_size^2.
% Filters of four orientations (0,45,90,135 degrees) are computed.
%
% arguments (optional)
% whichFilter = 'gaussian1st' : First derivative of Gaussian
% whichFilter = 'gaussian' : Second derivative of Gaussian (default)
% whichFilter = 'gabor' : Gabor filters. For Gabor filters,
%                minFS = 7, maxFS = 39 and sSFS = 2 are fixed.
% minFS: size of smallest filter
% maxFS: size of largest filter
% sSFS: filters of sizes minFS:sSFS:maxFS are computed
%

function []=init_filters(varargin)

global fSiz filters minFS maxFS numFilterSizes numFilters ...
    numSimpleFilters

disp('initializing filters...');

sigDivisor=4;

if nargin < 1
  whichFilter = 'gabor';
else
  whichFilter = varargin{1};
end

if strcmp(whichFilter,'gabor')
  minFS = 7;
  maxFS = 29;
  sSFS = 2;
else

  %filter sizes are minFS:sSFS:maxFS
  if nargin < 4
    sSFS = 2;
  else
    sSFS = varargin{4};
  end
  
  maxFS;	% original values
  if nargin < 3
    maxFS=29;
  else
    maxFS = varargin{3};
  end
  
  if nargin < 2
    minFS=7;
  else
    minFS = varargin{2};
  end
end


numSimpleFilters=4;	% four orientations: 0,45,90,135 deg

numFilterSizes=floor((maxFS-minFS)/sSFS+1);
% eee numSimpleFilters gives number of simple cell feature types
numFilters=numFilterSizes*numSimpleFilters;
filters=zeros(maxFS^2,numFilters);
fSiz=zeros(numFilters,1);	% vector with filter sizes


switch whichFilter
 
 case 'gabor'
  rot = [90 -45 0 45];
  div = [4:-.05:3.45];
  RF_siz = minFS:sSFS:maxFS;
  lambda = RF_siz*2./div;
  sigma  = lambda.*0.8;
  G      = 0.3;   % spatial aspect ratio: 0.23 < gamma < 0.92

  for k = 1:numFilterSizes
    for r = 1:numSimpleFilters
      theta     = rot(r)*pi/180;
      filtSize = RF_siz(k);
      center    = ceil(filtSize/2);
      filtSizeL = center-1;
      filtSizeR = filtSize-filtSizeL-1;
      sigmaq    = sigma(k)^2;
      
      for i = -filtSizeL:filtSizeR
	for j = -filtSizeL:filtSizeR
	  
	  if ( sqrt(i^2+j^2)>filtSize/2 )
	    E = 0;
	  else
	    x = i*cos(theta) - j*sin(theta);
	    y = i*sin(theta) + j*cos(theta);
	    E = exp(-(x^2+G^2*y^2)/(2*sigmaq))*cos(2*pi*x/lambda(k));
	  end
	  f(j+center,i+center) = E;
	end
      end
      
      f = f - mean(mean(f));
      f = f ./ sqrt(sum(sum(f.^2)));
      p = numSimpleFilters*(k-1) + r;
      filters(1:filtSize^2,p)=reshape(f,filtSize^2,1);
      fSiz(p)=filtSize;
    end
  end
  
 otherwise
  fprintf(['\n%s is not a valid parameter for init_filters.\nChoose' ...
	   ' ''gaussian1st'', ''gaussian'' or ''gabor''.\n'],whichFilter);
  return;
end

  
  
