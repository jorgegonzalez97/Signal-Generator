

%
% Genera las fases del código Zadoff-Chu de longitud M t parámetro r.
%


function [c,error]=codigoZadoff_Chu(M,r)

    c=0;
    error=0;
    
    if abs(r)==1,
        
    else,    
        d=sort([M,r]);
        if round(d(2)/d(1))==d(2)/d(1),
            error=1;
            return
        end
    end
    
    i=1:M;
    
    if M/2==round(M/2),
        c=(pi/M)*r*(i-1).^2;
    else,
        c=(pi/M)*r*(i-1).*i;
    end

end