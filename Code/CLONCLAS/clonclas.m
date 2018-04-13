function cellulesMemoires = clonclas(Vecteur, TAbr, G, N, B, M, d)

%**************************************************************************
% Plus l'affinit� est grande, plus elle meilleure.
%**************************************************************************

%**************************************************************************
% La repr�sentation des antig�nes/anticorps:
% Cas d'un exemple par antig�ne
% un exemple est une image binaire de taille [sizeCxsizeL]
% L = sizeC*sizeL
% Chaque antig�ne/anticorps est un vecteur [1xL double]
%**************************************************************************

%**************************************************************************
% Param�tres de clonclas
%**************************************************************************

%Ag = [1 0 1 0 0 1 0 0 0 0 1 1 1 0 1 0 1 0 1]; % Antig�nes
Ag = Vecteur;
L = size( Ag, 2); % taille d'un exemple

% TAbr = 2; % Taille de la population d'anticorps r�servoire
% G = 100; % nombre de g�n�rations avant arr�t de l'algo
% N = 2; % nombre d'anticorps s�lectionn�s � chaque it�ration
% B = 2; % param�tre utilis� lors du clonage
% M = 1; % param�tre utilis� lors des mutations
% d = 1; % nombre d'anticorps remplac�s � la fin de chaque it�ration

%**************************************************************************
% Constantes utilis�es par l'algorithme
%**************************************************************************

nbAg = size( Ag, 1); % nombre d'antig�nes

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
% Pour chaque antig�ne et pour chaque g�n�ration
for Agi = 1:nbAg

    antigene = Ag( Agi, :);
    
    for generation = 1:G

        % calculer l'affinit� de Ab par rapport � Agi
        affiniteAb = affinite( Ab, antigene);
        
%**************************************************************************
        % pour les besoins du dessin
        %aff = [aff; affiniteAb(Agi)];
%**************************************************************************

        % s�lectionner les N meilleurs anticorps, on obtient C
        [C, affiniteC] = selectionner( N, Ab, affiniteAb);
        
        % Cloner les anticorps de C proportionellenment � leur affinit�
        % on obtient Ci
        [Ci, affiniteCi] = cloner( B, C, affiniteC);

        % Muter les clones avec un degr� inversement proportionel � leurs
        % affinit�s, on obtient la population mature Cim.
        Cim = muter( M, Ci, affiniteCi);
        
        % Recalculer l'affinit� de Cim
        affiniteCim = affinite(Cim, antigene);
        
        % Choisir le meilleur anticorps comme candidat
        [affiniteCandidat, indexCandidat] = min(affiniteCim);
        
        % Si l'affinit� du candidat est meilleure que celle de Abmi, alors
        % remplacer Abmi par le candidat
        if affiniteCandidat > affiniteAb(Agi)
            Ab(Agi,:) = Cim(indexCandidat,:);
        end
        
        % remplacer tous les �lements de Abr par les meilleurs de Cim
        Abr = selectionner( TAbr, Cim, affiniteCim);
        
        % remplacer d anticorps de Abr, les plus mauvais, par des anticorps
        % g�n�r�s al�atoirement. Abr est d�ja tri�
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