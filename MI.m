%% 3. Moment of inertia, normalized. [2012Corriveau]
% Valentin Osuna-Enciso, September, 2019. Universidad de Guadalajara.
function D=MI(X)
    [N,n]=size(X);
    x_=zeros(1,n);
    for i=1:n
        x_(1,i)=mean(X(:,i));
    end
    D=0;
    for k=1:n
       x2k=0;
       for i=1:N
            x2k=x2k+(X(i,k)-x_(1,k))^2;
       end       
       D=D+x2k;
    end    
end
