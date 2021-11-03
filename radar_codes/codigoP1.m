

%
% Genera las fases del código P1 de longitud M=N^2.
%   La fase i-ésima del grupo k-ésimo es:
%       fase(k,i)=(-pi/N)(N-(2k-1))((k-1)N+(i-1)).
%
%
%
%


function [c,error]=codigoP1(M)

    N=sqrt(M);
    
    error=0;
    c=0;
    
    if round(N)~=N,
        error=1;
        return
    end
    
    c=zeros(1,M);
    
    for k=1:N,
        
        for i=1:N,
            
            c((k-1)*N+i)=(-pi/N)*(N-(2*k-1))*((k-1)*N+(i-1));

        end
    
    end

end