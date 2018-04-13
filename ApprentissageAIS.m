function ApprentissageAIS()
    tic;
    VecteurGaborFolder = 'database\VecteurGabor';
    arrayFiles = dir(fullfile(VecteurGaborFolder, '*.mat'));
    FileCount = size(arrayFiles);
    
    for i=1:FileCount
        currentFileName = fullfile(VecteurGaborFolder, arrayFiles(i).name);
        file = load(currentFileName);
        tc = file.tc;
        id = file.id;
        idString = num2str(i, '%.3d');
        disp(['cellule en cours ' idString]);
        %celluleMemoire = clonclas(tc(1: 6, :), 2,100, 2, 2, 0.0000001, 0);
        
        celluleMemoire = clonclas2(tc(1:6, :));
        saveFileNameAis = ['database\Apprentissage\Ais\V' idString '.mat'];
        Tg = tc(7 : end, :);
        idG = id;
        saveFileNameG = ['database\Apprentissage\Gabor\G' idString '.mat'];
        save(saveFileNameAis, 'celluleMemoire', 'id');
        save(saveFileNameG, 'Tg', 'idG');
        disp(['cellule memoire ' idString ' terminé']);
    
    end
    toc

end

