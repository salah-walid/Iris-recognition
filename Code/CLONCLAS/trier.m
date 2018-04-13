function [AbT, affinitesAbT] = trier(Ab, affinitesAb)
% function [AbT, affinitesAbT] = trier(Ab, affinitesAb)
%
% trie les anticorps Ab selon leurs affinit�s (affinitesAb)
% le r�sultat est dans AbT

A = flipud(sortrows([affinitesAb' Ab],1));

% s�parer les matrices
affinitesAbT = (A(:,1))';
AbT = A(:,2:end);