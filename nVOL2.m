%% 1. Volume in n-dimensions, by interquartil range. [2020Osuna]
% Valentin Osuna-Enciso, September, 2019-Julio, 2020. Ude Guadalajara.
function D=nVOL2(X,l,u)
    [~,d]=size(X);
    ladosUL=u-l; 
    %maxX=max(X); %CASO2A
    %minX=min(X); %CASO2A
    ladosX=(2.*iqr(X))./ladosUL; %CASO 2
    %ladosX=(maxX-minX)./ladosUL; %CASO 2A 
    %% FORMA 2
    c1=1; c2=1; 
    for ind=1:d
       c2=c2*ladosX(1,ind);
    end
    D=sqrt(c2/c1);
    D=exp((log(D))/(d*0.5));
end
