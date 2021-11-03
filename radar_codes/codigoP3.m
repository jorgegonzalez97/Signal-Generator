

%
% Genera las fases del c�digo P3 de longitud r.
%   La fase i-�sima del grupo k-�simo es:
%       fase(i)=(pi/r)(i-1)^2.
%
%
%
%


function c=codigoP3(r)

    i=1:r;
    
    c=(pi/r)*(i-1).^2;
    

end