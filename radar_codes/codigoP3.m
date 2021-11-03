

%
% Genera las fases del código P3 de longitud r.
%   La fase i-ésima del grupo k-ésimo es:
%       fase(i)=(pi/r)(i-1)^2.
%
%
%
%


function c=codigoP3(r)

    i=1:r;
    
    c=(pi/r)*(i-1).^2;
    

end