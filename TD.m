%% 2. True Diversity, normalized. [2012Corriveau]; Valentin Osuna-Enciso, 
% September, 2019. Universidad de Guadalajara.
function D=TD(X)
    [N,n]=size(X);
    x=zeros(1,n);
    for i=1:n
        x(1,i)=x(1,i)+sum(X(:,i).^2);
    end
    x(1,:)=x(1,:)./N; 
    D=0;
    for i=1:n
       D=D+(x(1,i)-(mean(X(:,i)))^2);
    end
    D1=sqrt(D); 
    D=D1/n;
end
