function cellulesMemoires = clonclas(Vecteur, TAbr, G, N, B, M, d)

%**************************************************************************
% Plus l'affinité est grande, plus elle meilleure.
%**************************************************************************

%**************************************************************************
% La représentation des antigènes/anticorps:
% Cas d'un exemple par antigène
% un exemple est une image binaire de taille [sizeCxsizeL]
% L = sizeC*sizeL
% Chaque antigène/anticorps est un vecteur [1xL double]
%**************************************************************************

%**************************************************************************
% Paramètres de clonclas
%**************************************************************************

%Ag = [1 0 1 0 0 1 0 0 0 0 1 1 1 0 1 0 1 0 1]; % Antigènes
Ag = Vecteur;
L = size( Ag, 2); % taille d'un exemple

% TAbr = 2; % Taille de la population d'anticorps réservoire
% G = 100; % nombre de générations avant arrêt de l'algo
% N = 2; % nombre d'anticorps sélectionnés à chaque itération
% B = 2; % paramètre utilisé lors du clonage
% M = 1; % paramètre utilisé lors des mutations
% d = 1; % nombre d'anticorps remplacés à la fin de chaque itération

%**************************************************************************
% Constantes utilisées par l'algorithme
%**************************************************************************

nbAg = size( Ag, 1); % nombre d'antigènes

% pour les besoins du dessin
%aff = [];

%**************************************************************************
% L'algorithme
%**************************************************************************

% Generer la population initiale d'anticorps
% Ab(i) est Abmi
% le reste fait partie de Abr
Ab = Ag(1:6, :);
%genererAb( L, TAbr)
% Pour chaque antigène et pour chaque génération
for Agi = 1:nbAg

    antigene = Ag( Agi, :);
    
    for generation = 1:G

        % calculer l'affinité de Ab par rapport à Agi
        affiniteAb = affinite( Ab, antigene);
        
%**************************************************************************
        % pour les besoins du dessin
        %aff = [aff; affiniteAb(Agi)];
%**************************************************************************

        % sélectionner les N meilleurs anticorps, on obtient C
        [C, affiniteC] = selectionner( N, Ab, affiniteAb);
        
        % Cloner les anticorps de C proportionellenment à leur affinité
        % on obtient Ci
        [Ci, affiniteCi] = cloner( B, C, affiniteC);

        % Muter les clones avec un degré inversement proportionel à leurs
        % affinités, on obtient la population mature Cim.
        Cim = muter( M, Ci, affiniteCi);
        
        % Recalculer l'affinité de Cim
        affiniteCim = affinite(Cim, antigene);
        
        % Choisir le meilleur anticorps comme candidat
        [affiniteCandidat, indexCandidat] = min(affiniteCim);
        
        % Si l'affinité du candidat est meilleure que celle de Abmi, alors
        % remplacer Abmi par le candidat
        if affiniteCandidat > affiniteAb(Agi)
            Ab(Agi,:) = Cim(indexCandidat,:);
        end
        
        % remplacer tous les élements de Abr par les meilleurs de Cim
        Abr = selectionner( TAbr, Cim, affiniteCim);
        
        % remplacer d anticorps de Abr, les plus mauvais, par des anticorps
        % générés aléatoirement. Abr est déja trié
        if (d > 0)
            ind=1+(nbAg-1)*rand(1);
            ind1=round(ind);
            Abr( TAbr:end, :) = Ag(ind1);
        end
        Ab( nbAg+1:end,:) = Abr;
        
    end % for Agi
    
end % for G

%**************************************************************************
% dessiner
%plot( 1:length(aff), aff, '-r');
%**************************************************************************

cellulesMemoires = Ab(1:nbAg,:);