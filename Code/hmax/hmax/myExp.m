function r=myExp(x)
  global expTab
  if(max(max(x))>0 | min(min(x))<-10)			% matrix args at most
    r=exp(x);
    disp(sprintf('expTab: arg=%g',x));
  else
    r=expTab(ceil((-x)*10000));
  end
%size(r)

% careful: exp(r) == expTab(r)' !!
