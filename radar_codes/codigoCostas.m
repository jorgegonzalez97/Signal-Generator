
%
% Función que calcula la secuencia frecuencia(tiempo) para las
% señales radar Costas mediante el método de Welch.
% Obtenido del libro Radar Signals, Nadav Levanon y Eli Mozeson.
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% calculate the positions/frequencies of a Costas array with size NxN
% for a given N there are N! possible frequency-time arrays (sequences)
% there can be more then one Costas sequence for any value of N.
% the sequences are calculated following Welch construction
%
% Type 1 - when N=p-1 and p is an odd prime (N=2,4,6,10,12,16,...)
%
% If j=0,1,2,...,p-2 and i=1,2,3,...,p-1 are the row and column indexes
% then a dot is marked in the Costas array if i=alfa^j where alfa is
% a primitive root of GF(p)
%
% Type 2 - obtained from type 1 by deleting the first row and first
% column from the Type 1 array. (N=p-2=1,2,3,5,9,11,15,...)
%
% Type 3 - when alfa=2 (2 is a primitive element of GF(p)). Deleting the 
% two first rows and columns produce a Costas array. In this case
% N=p-3=2,4,8,10,14,...
%
%

function [positions,error]=codigoCostas(N)

    index=0;
    error=0;
    positions=[];
    
    if (isprime(N+1))*(rem(N+1,2)==1),
        % calculate Costas array using Welch construction type 1
        p=N+1;
        % check primitive elements is GF(p)
        isprimitive=[0 ones(1,p-2)];
        e_pow_n=ones(p-1,p-1);
        for e=2:p-1,
            for idx=2:p-1,
                e_pow_n(e,idx)=mod(e*e_pow_n(e,idx-1),p);
                
                isprimitive(e)=isprimitive(e)*(e_pow_n(e,idx)~=1);
            end
        end
        % loop over all possible primitive elements of GF(p)
        for pr=find(isprimitive==1),
            index=index+1;
            positions(index,1:N)=e_pow_n(pr,1:p-1);
        end
    elseif (isprime(N+2))*(rem(N+2,2)==1),
        % calculate Costas array using Welch construction type 2
        p=N+2;
        % check primitive elements is GF(p)
        isprimitive=[0 ones(1,p-2)];
        e_pow_n=ones(p-1,p-1);
        for e=2:p-1,
            for idx=2:p-1,
                e_pow_n(e,idx)=mod(e*e_pow_n(e,idx-1),p);
                
                isprimitive(e)=isprimitive(e)*(e_pow_n(e,idx)~=1);
            end
        end
        % loop over all possible primitive elements of GF(p)
        for pr=find(isprimitive==1),
            index=index+1;
            positions(index,1:N)=e_pow_n(pr,2:p-1)-1;
        end
    elseif (isprime(N+3))*(rem(N+3,2)==1),
        % calculate Costas array using Welch construction type 3
        p=N+3;
        % check 2 is primitive
        isprimitive=[0 ones(1,p-2)];
        e_pow_n=ones(p-1,p-1);
        for e=2,
            for idx=2:p-1,
                e_pow_n(e,idx)=mod(e*e_pow_n(e,idx-1),p);
                
                isprimitive(e)=isprimitive(e)*(e_pow_n(e,idx)~=1);
            end
        end
        % loop over all possible primitive elements of GF(p)
        for pr=find(isprimitive==1),
            index=index+1;
            positions(index,1:N)=e_pow_n(pr,3:p-1)-2;
        end
    end

    if isempty(positions)||(positions(1)==-1),
        positions=0;
        error=1;
    end

end


