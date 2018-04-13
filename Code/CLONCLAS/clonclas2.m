function cellulesMemoires = clonclas2(Ag)

%clonclas modifi?version3
%**************************************************************************
% Plus l'affinit?est grande, plus elle meilleure.
%**************************************************************************

%**************************************************************************
% La repr?entation des antig?es/anticorps:
% Cas d'un exemple par antig?e
% un exemple est une image binaire de taille [sizeCxsizeL]
% L = sizeC*sizeL
% Chaque antig?e/anticorps est un vecteur [1xL double]
%**************************************************************************

%**************************************************************************
% Param?res de clonclas
%**************************************************************************

%Ag = [1 0 1 0 0 1 0 0 0 0 1 1 1 0 1 0 1 0 1]; % Antig?es

L = size( Ag, 2); % taille d'un exemple

TAbr = 2; % Taille de la population d'anticorps r?ervoire
G = 1; % nombre de g??ations avant arr? de l'algo
N = 6; % nombre d'anticorps s?ectionn? ?chaque it?ation
B = 1; % param?re utilis?lors du clonage
M = 0.000001; % param?re utilis?lors des mutations
d = 1; % nombre d'anticorps remplac? ?la fin de chaque it?ation

%**************************************************************************
% Constantes utilis?s par l'algorithme
%**************************************************************************

nbAg =size( Ag, 1); % nombre d'antig?es

% pour les besoins du dessin
%aff = [];


%**************************************************************************
% L'algorithme
%**************************************************************************


Ab=[];
 a=1;b=nbAg;
for i=1:nbAg+ TAbr
ind=a+(b-a)*rand(1);
ind1=round(ind);
Ab = [Ab;Ag(ind1,:)];
end
% Ab=[Ag(3,:);Ag(4,:);Ag(5,:);Ag(6,:)];
% Pour chaque antig?e et pour chaque g??ation
for Agi = 1:nbAg

    antigene = Ag( Agi, :);
    
    for generation = 1:G

        % calculer l'affinit?de Ab par rapport ?Agi
        affiniteAb = affinite( Ab, antigene);
        
%**************************************************************************
        % pour les besoins du dessin
        %aff = [aff; affiniteAb(Agi)];
%**************************************************************************

        % s?ectionner les N meilleurs anticorps, on obtient C
        [C, affiniteC] = selectionner( N, Ab, affiniteAb);
        
        % Cloner les anticorps de C proportionellenment ?leur affinit?
        % on obtient Ci
        [Ci, affiniteCi] = cloner( B, C, affiniteC);

        % Muter les clones avec un degr?inversement proportionel ?leurs
        % affinit?, on obtient la population mature Cim.
        Cim = muter( M, Ci, affiniteCi);
        
        % Recalculer l'affinit?de Cim
        affiniteCim = affinite(Cim, antigene);
        
        % Choisir le meilleur anticorps comme candidat
        [affiniteCandidat, indexCandidat] = min(affiniteCim);
        
        % Si l'affinit?du candidat est meilleure que celle de Abmi, alors
        % remplacer Abmi par le candidat
        if affiniteCandidat > affiniteAb(Agi)
            Ab(Agi,:) = Cim(indexCandidat,:);
        end
        
        % remplacer tous les ?ements de Abr par les meilleurs de Cim
        Abr = selectionner( TAbr, Cim, affiniteCim);
        
        % remplacer d anticorps de Abr, les plus mauvais, par des anticorps
        % g??? al?toirement. Abr est d?a tri?
        if (d > 0)
            ind=a+(b-a)*rand(1);
            ind1=round(ind);
           Abr( (TAbr-d+1):end, :) = Ag(ind1,:);
            %Abr( (TAbr-d+1):end, :) = genererAb( L, d);
        end
%         disp(size(Abr));
%         disp(size(Ab));
%         disp(nbAg);
        Ab( nbAg + TAbr - 1:end,:) = Abr;
        
    end % for Agi
    
end % for G

%**************************************************************************
% dessiner
%plot( 1:length(aff), aff, '-r');
%**************************************************************************

cellulesMemoires = Ab(1:nbAg,:);

end