 VecteurGaborFolder = 'database\VecteurGabor';
    arrayFiles = dir(fullfile(VecteurGaborFolder, '*.mat'));
    FileCount = size(arrayFiles);
    idd=1;
    for i=1:FileCount
        currentFileName = fullfile(VecteurGaborFolder, arrayFiles(i).name);
        file = load(currentFileName);
        tc = file.tc;
         id = file.Id;
        idString = num2str(id, '%.3d');
        if size(tc,1)>=15
            Id=idd;
            idString = num2str(Id, '%.3d');
            idd=idd+1;
            saveFileNameAis = ['database\VecteurGaborUtilisable\I' idString '.mat'];
             save(saveFileNameAis, 'tc', 'Id');
        end
    end