function [ Id, distanceMinimale ] = searchIris( VecteurDeGabor, from, to )

    distances = [];
    ids = [];
    
    for i=from:to
    
        fileName = ['database\Apprentissage\Ais\V' num2str(i, '%.3d') '.mat'];
        load(fileName, 'celluleMemoire', 'id');
        
        sizeCelluleMemoire = size(celluleMemoire, 1);
        distance = [];
        for j=1:sizeCelluleMemoire
        
            d= pdist([celluleMemoire(j,:);VecteurDeGabor],'cosine');%sum(abs(celluleMemoire(j,:) - VecteurDeGabor));
            distance = [distance; d];
        
        end
        distances = [distances, min(distance)];
        %disp(min(distance));
        ids = [ids, id];
        
    end
    
    %disp(distances);
    [~, I] = min(distances);
    distanceMinimale = distances(I);
    Id = ids(I);

end

