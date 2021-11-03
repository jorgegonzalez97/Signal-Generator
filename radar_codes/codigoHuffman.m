

%
% Genera un código Huffman de longitud M dado el nivel del lóbulo
% secundario en dB (A).
%
%
%


function [c,error]=codigoHuffman(M,A)

    error=0;
    c=0;
    
    a=10^(A/20);
    
    if a>=1,
        error=1;
        return
    end
    
    % Se calculan los radios exterior e interior
    
    RE=(abs(1/(2*a))+sqrt((1/(4*a^2))-1))^(1/(M-1));
    RI=1/RE;
    R=[RE,RI];
    
    % Se calculan las fases
    fases=(0:M-2)*2*pi/(M-1);
    
    % Elegimos los ceros de forma aleatoria
    RAleatorio=zeros(1,M-1);
    for i=1:M-1,
        RAleatorio(i)=R(round(rand(1))+1);
    end
    
    ceros=RAleatorio.*exp(j*fases);
    
    c=poly(ceros);
    

end