function [tx,ytest]=test(c,lambda,kernel,kerneloption,verbose)
ytest=[];
taux=0;
load model.mat;
r=0;
for i=1:2
    r=r+1;
    g=num2str(i);
    p=['C:\MATLAB7\work\iriscode\iriscode\apprentissage\tes' g];
    p=[p '.mat'];
    load (p);
   for l=1:3
    ytest=[ytest r];
    Xtest=double(tc(l,:));
    [ypred,maxi] = svmmultivaloneagainstone(Xtest,xsup,w,b,nbsv,kernel,kerneloption); 
    if r==ypred taux=taux+1; end;
    t=[num2str(r) 'reconnu comme' num2str(ypred)];
    disp(t);    
   end;
end;
taux=(taux*100)/(2*3);
p=[' le taux de reconnaissance est de   ' num2str(taux)];disp(p); 
tx=taux;


  