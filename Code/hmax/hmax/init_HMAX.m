%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%       MODULE: init_HMAX
%%
%%       DESCRIPTION: sets the parameters for HMAX and initializes
%%                    expTab 
%%                    Adapt it to your needs :-)
%%
%%       last modified: 08/25/04
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%global variables

%for filters:
global fSiz filters minFS maxFS numFilterSizes numFilters numSimpleFilters

global layerAct  maxLayer numRF numV4Filters
global numSimpleCells c1RFSize
global sigmaTab
global s2Target		% target value for S2 cells
global s2Sigma
global expTab s2Tab
global c1SpaceSS c1ScaleSS c1OL



% set the parameters

s2Sigma = 1;
s2Target = 1;

% C1 spatial pooling ranges
c1SpaceSS=[4 6 9 12];
% one for each scale band

% S1 filter ranges (scale pooling)
% The indices in c1ScaleSS are the limits for the filter sizes in
% a vector fs = minFSF:sSFS:maxSFS, i.e. The ith range are the sizes in fs of the indices
% [c1ScaleSS(i),c1ScaleSS(i+1)), or, in Matlab notation: 
% fs(c1ScaleSS(i):(c1ScaleSS(i+1)-1))
c1ScaleSS = [1 3 6 9 13];
% here with a minimum filter size (minSFS) of 7 and a maximum size (maxSFS) of 29 we
% get 4 scale ranges:
% 7,9   11,13,15   17,19,21   23,25,27,29


% how many C1 cells overlap horizontally / vertically
c1OL=2;

if ~exist('whichFilter') | isempty(whichFilter)
  disp('whichFilter is not set. Using default: gabor.');
  whichFilter = 'gabor';
end


% specify filter sizes with minFS (smallest size), maxFS (largest
% size) and sSFS (step size in between) and call
% init_filters(whichFilter,minFS,maxFS,sSFS)
% This function also sets fSiz.
init_filters(whichFilter);


% compute expTab, if it's not there yet
if ~exist('skipInit')
  skipInit = 1;
  disp('initializing tables...');
  numC2Units=256;
  disp('calculating expTab...');
  expTab=exp(-(0:0.0001:10));% store vals from -0 to -10 in steps of 1e-4
  disp('done!');
end

