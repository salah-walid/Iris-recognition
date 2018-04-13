function [AbT, affinitesAbT] = trier(Ab, affinitesAb)
% function [AbT, affinitesAbT] = trier(Ab, affinitesAb)
%
% trie les anticorps Ab selon leurs affinités (affinitesAb)
% le résultat est dans AbT

A = flipud(sortrows([affinitesAb' Ab],1));

% séparer les matrices
affinitesAbT = (A(:,1))';
AbT = A(:,2:end);