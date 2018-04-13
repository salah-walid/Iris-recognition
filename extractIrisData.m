function [ gMatrice ] = extractIrisData( fileName )
   irisImg = extractIris(fileName, 24 ,240);
   gMatrice = gaborFilter(irisImg);

end

