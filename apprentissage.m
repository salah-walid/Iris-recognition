function [] = apprentissage(  )
    idd = 0;
    for Id=1:249
        IdString = num2str(Id,'%.3d');
        tc = [];
        for direction=['R']
            
            currentFolder = fullfile('CASIA-Iris-Interval', IdString, direction);
            arrayFiles = dir(fullfile(currentFolder, '*.jpg'));
            fileCount = length(arrayFiles);
            
            if fileCount >= 10
                idd = idd +1;
                disp(['Dossier en cours : ' currentFolder]);
                for i=1:fileCount
                    fileName = fullfile(currentFolder, arrayFiles(i).name);
                    disp(['Fichier en cours : ' fileName]);
                    gMatrice = extractIrisData(fileName);
                    tc = [tc;gMatrice];
                end       
                Sfilename = ['database\VecteurGabor\I' num2str(idd,'%.3d') '.mat'];
                id = Id;
                save(Sfilename, 'tc', 'id');
            else
                disp(['skip : ' currentFolder]);
            end
        end
    end

end

