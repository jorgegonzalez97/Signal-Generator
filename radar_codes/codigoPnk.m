
%
% Genera las fases del código P(n,k) de longitud M.
%
%
%
%


function [c,error]=codigoPnk(M,n,k)

    c=0;
    error=0;
    
    if k<0||k>1,
        error=1;
        return
    end
    
    N=512;
    Bc=1;
    
    warning off all
    F=@(x)k+(1-k)*cos(pi*x/(Bc)).^n;
    f=-Bc/2:Bc/N:Bc/2-Bc/N;
    Phi1=zeros(1,length(f));
    for i=1:length(f),
        Phi1(i)=2*pi*quad(F,-Bc/2,f(i));
    end
    warning on all
    
    Tf=(-Phi1)/2*pi;
    np=linspace(min(Tf),max(Tf),N);
    fi=-interp1(Tf,f,np);
    phi=2*pi*(M/N)*cumsum(fi);
    
    c=zeros(1,M);
    
    for i=1:M,
       ind_i=(i-1)*N/M;
       c(i)=interp1(0:N-1,phi,ind_i,'linear','extrap'); 
    end
    

end