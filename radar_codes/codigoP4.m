

%
% Genera las fases del código P4 de longitud r.
%   La fase i-ésima del grupo k-ésimo es:
%       fase(i)=(pi/(4r))*(2i-1).^2-(pi/4)(2i-1).
%
%
%
%


function c=codigoP4(r,palin)

    i=1:r;
    
    if palin,
        c=(pi/(4*r)).*(2*i-1).^2-(pi/4).*(2*i-1);
    else,
        c=(2*pi/r).*(i-1).*((i-1-r)/2);
    end

end