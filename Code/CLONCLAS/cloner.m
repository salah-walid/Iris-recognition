function [Ci, affiniteCi] = cloner( B, C, affiniteC)
% [Ci, affiniteCi, itCi] = cloner( B, C, affiniteC, itC)
%
% Clone les élements de C proportionnelement à leurs affinités (affiniteC)
%
% Pour chaque anticorps C(i) on génère un nombre de clones déterminé par la
% formule suivante (d'aprés l'algo original de CLONALG)
%
% nbClones(i) = round( B*N/i) où N est le nombre total d'anticorps

N = size(C, 1); % nombre d'anticorps
L = size(C, 2); % taille d'un anticorps

nb = round( (B*N)./(1:N)); % nb(i) contient le nombre de clones pour C(i)
TCi = sum( nb); % taille de Ci

Ci = ones( TCi, L);
affiniteCi = ones( TCi, 1);

ind = 1;
for k = 1:N
    Ci( ind:(nb(k)+ind-1),:) = repmat( C(k,:), nb(k), 1);
    affiniteCi( ind:(nb(k)+ind-1)) = ones( nb(k), 1)*affiniteC(k);
    ind = ind + nb(k);
end