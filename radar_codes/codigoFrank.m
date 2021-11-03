
%
% Genera las fases del código Frank de longitud M=N^2.
%   La fase i-ésima del grupo k-ésimo es:
%       fase(k,i)=(2pi/N)(i-1)(k-1).
%
%
%
%


function [c,error]=codigoFrank(M)
    
    N=sqrt(M);
    
    c=0;
    error=0;
    
    if round(N)~=N,
        error=1;
        return
    end

    c=zeros(1,M);
    
    for k=1:N,
        
        for i=1:N,
            
            c((k-1)*N+i)=((2*pi)/N)*(i-1)*(k-1);

        end
    
    end

end