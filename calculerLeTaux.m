function [ T ] = calculerLeTaux( from, to )

    nbrReconnue = 0;
    for i=from:to
    
        fileName = ['database\Apprentissage\Gabor\G' num2str(i, '%.3d') '.mat'];
        load(fileName);
        sizeVecteurGabor = size(Tg, 1);
        disp(['individus en cours ' num2str(idG)]);
        for j=1:sizeVecteurGabor
            [idR, ~] = searchIris(Tg(j,:), from, to);
            %disp(idR);
            if(idR == idG)
            
                nbrReconnue = nbrReconnue + 1;
                disp('reconnue');
                break
                
            end
        end
        
    end
    nbrReconnue
    T = (nbrReconnue*100) / (to - from +1);

end