function apprentissage;
ya=[];
Xa=[];
tc1=[];
max=0;
r=0;
for i=1:2
    r=r+1;
    g=num2str(i);
    p=['C:\MATLAB7\work\iriscode\iriscode\apprentissage\app' g];
    p=[p '.mat'];
    load (p);
   for l=1:3
    ya=[ya r];
    tc1=[tc1;double(tc(l,:))];    
   end;
end;
    Xa=tc1;
    c = 1000000;
    lambda = 1e-7;
    kernel='gaussian';
    verbose = 0;
    
     kerneloption= 2
     [xsup,w,b,nbsv,classifier]=svmmulticlassoneagainstone(Xa,ya,2,c,lambda,kernel,kerneloption,verbose);
     save model.mat xsup w b nbsv classifier;
    
disp('fin apprentissage');
    

[tx,ytest]=test(c,lambda,kernel,kerneloption,verbose);
     if tx>max max=tx; ko=i; end;

    
