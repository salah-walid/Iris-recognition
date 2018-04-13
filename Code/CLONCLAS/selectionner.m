function [C, affiniteC] = selectionner( N, Ab, affiniteAb)
% function [C, affiniteC] = selectionner( N, Ab, affiniteAb)
%
% trie Ab selon son affinité (affiniteAb) puis renvoit les N premiers
% anticorps dans C et leurs affinités dans affiniteC

[AbT, affiniteAbT] = trier(Ab, affiniteAb);
C = AbT(1:N, :);
affiniteC = affiniteAbT(1:N);
