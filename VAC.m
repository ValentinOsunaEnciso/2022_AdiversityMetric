%% 5. Variance average chromosome, normalized. [2012Corriveau]
% Valentin Osuna-Enciso, September, 2019. Universidad de Guadalajara.
function D=VAC(X)
    [N,n]=size(X);
    x_=zeros(1,n);
    for i=1:n
        x_(1,i)=mean(X(:,i));
    end
    x_=mean(x_);
    D=0;
    for i=1:N
        D=D+(mean(X(i,:))-x_)^2;
    end
    D=D/N;
end