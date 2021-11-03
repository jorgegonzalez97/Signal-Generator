



function [c,error]=codigoBarkerSC(n1,n2,cI1,cI2)

    if nargin<4,
        cI1=0;
        cI2=0;
    end
    
    error=0;
    c=0;
          
    [c1,error1]=codigoBarker(n1);
    [c2,error2]=codigoBarker(n2);
    
    if error1||error2,
        error=1;
        return
    end
    
    if cI1,
        c1=c1(end:-1:1);
    end
    if cI2,
        c2=c2(end:-1:1);
    end
    
    c=kron(real(exp(j*c1)),real(exp(j*c2)));
    
    c=angle(c);
    
end