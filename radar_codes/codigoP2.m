
%
% Genera las fases del código P2 de longitud M=N^2.
%   La fase i-ésima del grupo k-ésimo es:
%       fase(k,i)=(pi/(2N))(N+1-2i)(N+1-2k).
%
%
%
%


function [c,error]=codigoP2(M)

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
            
            c((k-1)*N+i)=(pi/(2*N))*(N+1-2*i)*(N+1-2*k);
%             c((k-1)*N+i)=(pi/2)*((N-1)/N)-((pi/N)*(i-k))*(N+1-2*k);

        end
    
    end

end