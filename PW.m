%% 4. Mean of the pairwise distance among individuals in the population,
% normalized; [2012Corriveau];Valentin Osuna-Enciso, September, 2019.
% Universidad de Guadalajara.
function D=PW(X)
    [N,n]=size(X);
    D=0;
    for i=2:N
        raiz2=0;
        for j=1:i-1
            raiz=0;
            for k=1:n
                raiz=raiz+(X(i,k)-X(j,k))^2;
            end    
            raiz2=raiz2+sqrt(raiz); 
        end
        D=D+raiz2; 
    end
    D=(D*2)/(N*(N-1));
end
