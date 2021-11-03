

function [c,error]=codigoBarker(N,tipo)

    error=0;
    c=0;
    
    if nargin==1,
        tipo=1;
    end
    
    switch N,
    
        case 2,
        
            if tipo,
                c=[1 1];
            else,
                c=[1 0];
            end
    
        case 3,
            
           c=[1 1 0];

        case 4,
            
            if tipo,
                c=[1 1 1 0];
            else,
                c=[1 1 0 1];
            end

        case 5,
            
            c=[1 1 1 0 1];
            
        case 7,
            
            c=[1 1 1 0 0 1 0];
        
        case 11,
            
            c=[1 1 1 0 0 0 1 0 0 1 0];
            
        case 13,
            
            c=[1 1 1 1 1 0 0 1 1 0 1 0 1];
                    
        otherwise,
            
            c=0;
            error=1;
            return
    
    end
    
    c=pi*c;
    
end