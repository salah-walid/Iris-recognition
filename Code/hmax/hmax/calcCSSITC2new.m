%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%       MODULE: calcCSSITC2new.m
%%
%%     FUNCTION: IN: currClip: the image itself
%%                   limitPoolFlag: boolean whether to limitPool
%%              OUT: c2Act: c2 activations, basically the result from 
%%                   myRespC2new, but now plugged into a gaussian
%% DESCRIPTION: calls myRespC2new
%%              if there is only 1 argument assume limitPooling is off
%%              exponentiates the result of myRespC2new, and returns that 
%%
%% last modified: 10/29/02
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [c2Act] = calcCSSITC2new(currClip,limitPoolFlag)
global fSiz filters
global s2Sigma
global s2Target
global c1SpaceSS c1ScaleSS c1OL

if(nargin==1)                           % no limitPoolFlag?
  limitPoolFlag=0;
end



c2Act=myRespC2new(currClip,filters,fSiz,c1SpaceSS,c1ScaleSS,c1OL,1,s2Target,limitPoolFlag);



% compute C2 activations by taking max over all S2 cells of same type

c2Act=myExp(c2Act/(2*s2Sigma^2));







