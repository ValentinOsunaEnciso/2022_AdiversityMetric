% BENCHMARK 1: [2012Corriveau]
% Decreases the diversity linearly from a fully scattered population to a
% fully converged one. This benchmark is for n dimensions.
% Valentin Osuna-Enciso, Septiembre 2019. CUCEI-UDG.
%EXPERIMENT 6: COMPUTATIONAL COST.
u=50;  l=-50;  % Limites de espacio de busqueda.
reductionRate=0.02; % 
repeticiones=50;
iteraciones=49;     % Numero maximo de iteraciones para todo el proceso.
dimensiones=100;      % Dimensiones del problema.
pop_size=100;       % Tamano de poblacion.
Noutlier= 0;%0.01*pop_size; %0; 0.05*pop_size; 0.1*pop_size; % Numero de outliers.
modas=1;            % Unimodal: modas=1; Multimodal: modas=
u=u.*ones(1,dimensiones); l=l.*ones(1,dimensiones);
it_outlier=10;      % Iteracion en la que aparecen los outliers.
medTot=zeros(iteraciones,6);
estabilidad1=[]; estabilidad2=[]; estabilidad3=[]; estabilidad4=[];
estabilidad5=[]; estabilidad6=[];
for r=1:repeticiones
    %Creacion de las posiciones optimas:
    optimos=zeros(modas,dimensiones);
    for picos=1:modas
        optimos(picos,:)= l+(u-l).*rand(1,dimensiones);        
    end
    medidas=ones(iteraciones,6);
    for it=1:iteraciones
        %Definicion de lopts limites de la iteracion para cada optimo:
        uopt=zeros(modas,dimensiones); lopt=zeros(modas,dimensiones);
        uout=zeros(modas,dimensiones); lout=zeros(modas,dimensiones);
        for picos=1:modas
                if it>1             
                    delta= 2.*u.*(1-it*reductionRate);
                    temp=l+(u-l).*rand(1,dimensiones);
                    x=temp;
                    x2=optimos(picos,:); 
                    for ind=1:dimensiones
                       while ~((l(1,ind)<x(1,ind))&&(x(1,ind)<x2(1,ind))&&(x(1,ind)+delta(1,ind)<u(1,ind))&&(x2(1,ind)<x(1,ind)+delta(1,ind)))
                          x(1,ind) = l(1,ind)+(u(1,ind)-l(1,ind))*rand();
                       end
                    end
                    lopt(picos,:)=x;
                    uopt(picos,:)=x+delta;
                else
                    uopt(picos,:)=u;
                    lopt(picos,:)=l;
                end
        end
        %Definicion de los parametros de los outliers:
        if (Noutlier>0 && it>=it_outlier)
            N=pop_size-Noutlier;    %Evaluar el tamaño de poblacion de no outliers
            if it==it_outlier
                %Definicion de los limites de los outliers:
                for picos=1:modas
                    uout(picos,:)=u;
                    lout(picos,:)=uopt(picos,:);
                end
            end
        else
            N=pop_size;
        end
        %Creación de los individuos:
        X=zeros(pop_size,dimensiones);
        picos=1;
        for ind=1:N             
                %Distribucion de los individuos uniformemente dentro de los
                %limites de cada pico:
                if (ind>(picos-1)*N/modas)&&(ind<=picos*N/modas)
                    %%%
                    X(ind,:)=lopt(picos,:)+(uopt(picos,:)-lopt(picos,:)).*rand(1,dimensiones);
                else
                    picos=picos+1; 
                    X(ind,:)=optimos(picos,:);
                end
        end
        X(1,:)=optimos(1,:);
        %Creacion de los outliers:
        if (Noutlier>0)&&(it>=it_outlier)
            for ind2=ind+1:pop_size
                X(ind2,:)=l+(u-l).*rand(1,dimensiones);   
            end
        end        
% % %         figure, hold on
% % %         plot(X(:,1),X(:,2),'r*'), plot(optimos(:,1),optimos(:,2),'db')
% % %         for picos=1:modas
% % %             x = [lopt(picos,1), uopt(picos,1), uopt(picos,1), lopt(picos,1), lopt(picos,1)];
% % %             y = [lopt(picos,2), lopt(picos,2), uopt(picos,2), uopt(picos,2), lopt(picos,2)];
% % %             plot(x, y, '-', 'LineWidth', 3);
% % %         end       
        if it>1
            t = cputime;
            D1=DTAP(X); 
            bestD1=max(D1,bestD1);            
            actualD1=D1/bestD1;
            e1 = cputime-t;
            t = cputime;
            D2=TD(X); 
            bestD2=max(D2,bestD2);            
            actualD2=D2/bestD2;
            e2 = cputime-t;
            t = cputime;
            D3=MI(X); 
            bestD3=max(D3,bestD3);            
            actualD3=D3/bestD3;
            e3 = cputime-t;
            t = cputime;
            D4=PW(X); 
            bestD4=max(D4,bestD4);            
            actualD4=D4/bestD4;
            e4 = cputime-t; 
            t = cputime;
            D5=VAC(X); 
            bestD5=max(D5,bestD5);            
            actualD5=D5/bestD5;
            e5 = cputime-t;
            t = cputime;
            D6=nVOL2(X,l,u);
            e6 = cputime-t;            
            medidas(it,:)=[e1,e2,e3,e4,e5,e6];
        else  
            D1=1; D2=1; D3=1; D4=1; D5=1; D6=nVOL2(X,l,u);
            t = cputime;
            bestD1=DTAP(X); 
            e1 = cputime-t;
            t = cputime;
            bestD2=TD(X); 
            e2 = cputime-t;
            t = cputime;
            bestD3=MI(X); 
            e3 = cputime-t;
            t = cputime;
            bestD4=PW(X);
            e4 = cputime-t;
            t = cputime;
            bestD5=VAC(X);  
            e5 = cputime-t;
            t = cputime;
            bestD6=nVOL2(X,l,u);  
            e6 = cputime-t;            
            medidas(it,:)=[e1,e2,e3,e4,e5,e6];
        end
    end  
    medTot=medTot+medidas;
end
medTot=medTot./repeticiones;
figure
plot(medTot(:,1),'-xk')
hold on
plot(medTot(:,2),'-dk')
plot(medTot(:,3),'-ok')
plot(medTot(:,4),'-vk')
plot(medTot(:,5),'-sk')
plot(medTot(:,6),'-+k')
legend('DTAP','TD','MI','PW','VAC','nVOL')
xlabel('Iterations'), ylabel('Diversity')
errores=[mean(medTot(:,1)),mean(medTot(:,2)),mean(medTot(:,3)),mean(medTot(:,4)),mean(medTot(:,5)),mean(medTot(:,6)),];
A=1;