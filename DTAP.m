%% 1. Distance to average point measure, normalized. [2012Corriveau]
% Valentin Osuna-Enciso, September, 2019. Universidad de Guadalajara.
function D=DTAP(X)
    [N,n]=size(X);
    x_=zeros(1,n);
    for i=1:n
        x_(1,i)=mean(X(:,i));
    end
    D=0;
    for i=1:N
        raiz=0;
        for k=1:n
           raiz=raiz+(X(i,k)-x_(1,k))^2; 
        end
        D=D+sqrt(raiz);
    end
    D=D/N;
end
