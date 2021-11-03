
%
% Genera las fases del código Px de longitud N^2.
%


function [c,error]=codigoPx(M)

    N=sqrt(M);
    
    error=0;
    
    if round(N)~=N,
        error=1;
        return
    end

    c=zeros(1,M);
    
    for k=1:N,
        
        for i=1:N,
            
            if N/2==round(N/2),
                c((k-1)*N+i)=(2*pi/N)*((N+1)/2-i)*((N+1)/2-k);
            else,
                c((k-1)*N+i)=(2*pi/N)*(N/2-i)*((N+1)/2-k);
            end
            
        end
    
    end

end