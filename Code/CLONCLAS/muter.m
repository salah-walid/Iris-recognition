function Cim = muter( M, Ci, affiniteCi)
% function Cim = muter( Ci, affiniteCi)
%
% Muter les �lements de Ci avec un degr� proportionel � leurs
% affinit�s (affiniteCi), on obtient la population mature Cim.
%
% pour l'anticorps i, qui a une affinit� affiniteCi(i), on inverse un
% nombre al�atoire de bits compris entre 0 et M*(L-affiniteCi(i))

N = size(Ci, 1); % nombre d'anticorps
L = size(Ci, 2); % taille d'un anticorps

mut = round( M*(L-affiniteCi).*rand(N,1)); % mut(i) contient le nombre de bits � inverser
I = randint( N, L, [1 L]); % contient les indices qui vont muter

Cim = Ci;

for i = 1:N
    Cim(i, I(1:mut(i))) = ~Ci(i, I(1:mut(i)));
end % for i