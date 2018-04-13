function affinites = affinite( Ab, Agi)
% function affinites = affinite( Ab, Agi)
%
% calcule l'affinité entre Ab et Agi (distance de Hamming).
% Ab est de taille [MxL]
% Agi est de taille [1xL]
%
% renvoit affinites de taille [Mx1], tel que affinites(i) est l'affinité de
% l'anticorps Ab(i,:)
%
% 0 < affinites <= L, l'affinité la plus grande est la meilleure


M = size(Ab, 1); % M est le nombre d'anticorps

A = repmat(Agi, M, 1);

affinites = sum( xor( Ab, A)');