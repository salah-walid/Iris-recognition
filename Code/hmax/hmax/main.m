%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% 	  MODULE: main.m
%%
%%      FUNCTION: some code to show how calcCSSITC2new.m is called and how
%%                variables are set up (together with init_HMAX.m)
%%		  
%%   DESCRIPTION: this code demonstrates how to initialize the
%%                parameters and call calcCSSITC2new for an
%%                image. To run this from a Matlab prompt, simply
%%                type '>>main'. The output is a vector of C2
%%                responses in the variable 'c2Resp'.
%%                Look at the file init_HMAX.m to see how to set
%%                the parameters.
%%
%% last modified: 08/25/2004
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% which filters for the simple cells do we want to use? Options are
% 'gaussian1st': first derivative of a Gaussian
% 'gaussian': second derivative of a Gaussian
% 'gabor': Gabor filters (more realistic)

% initialize the parameters (look at the source code of init_HMAX.m
% to see them)


% load the image
fid=fopen('testImage.gray','r');
stim=reshape(fread(fid,'uchar'),128,128)'; % 8 bit grays
fclose(fid);
%colormap('gray');imagesc(stim);axis image off;

% ...and now calculate the C2 response by calling calcCSSITC2new:
tic
whichFilter = 'gabor';
init_HMAX;
c2Resp=calcCSSITC2new(stim,0)';
toc

disp('Done. The C2 response is in the variable c2Resp.');
