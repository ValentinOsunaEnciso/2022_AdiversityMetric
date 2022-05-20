% BENCHMARK 3: [2012Corriveau]
% Decreases the diversity linearly from a fully scattered population to a
% fully converged one. This benchmark is only for 'n' dimensions.
% Valentin Osuna-Enciso, Septiembre 2019. CUCEI-UDG.
% SENSITIVITY ANALYSIS: LANDSCAPE DIMENSIONALITY.
samples=[   1 100 2 1;
            1 100 10 1;
            1 100 30 1;
            1 100 2 2;
            1 100 10 2;
            1 100 30 2;
            1 100 2 4;
            1 100 10 4;
            1 100 30 4;
            2 100 2 1;
            2 100 10 1;
            2 100 30 1;
            2 100 2 2;
            2 100 10 2;
            2 100 30 2;
            2 100 2 4;
            2 100 10 4;
            2 100 30 4;  
            3 100 2 1;
            3 100 10 1;
            3 100 30 1;
            3 100 2 2;
            3 100 10 2;
            3 100 30 2;
            3 100 2 4;
            3 100 10 4;
            3 100 30 4;
            4 100 2 1;
            4 100 10 1;
            4 100 30 1;
            4 100 2 2;
            4 100 10 2;
            4 100 30 2;
            4 100 2 4;
            4 100 10 4;
            4 100 30 4;
            5 100 2 1;
            5 100 10 1;
            5 100 30 1;
            5 100 2 2;
            5 100 10 2;
            5 100 30 2;
            5 100 2 4;
            5 100 10 4;
            5 100 30 4;
            6 100 2 1;
            6 100 10 1;
            6 100 30 1;
            6 100 2 2;
            6 100 10 2;
            6 100 30 2;
            6 100 2 4;
            6 100 10 4;
            6 100 30 4;
            ];
alfa=0.05;
experimentos=size(samples,1);
repeticiones=2;
iteraciones=49;     % Numero maximo de iteraciones para todo el proceso.
contExperimento=1;
resultados=zeros(1,18);
contadorInstancia=1;
for experimento=1:3:experimentos   
 for corridas=1:100  
    medidas=ones(iteraciones,3);
    contador=1;
  for instancia=experimento:experimento+2  
        pop_size=samples(instancia,2);
        modas=samples(instancia,4);
        GDM=samples(instancia,1);
        dimensiones=samples(instancia,3);      % Dimensiones del problema.
        u=50;  l=-50;  % Limites de espno nanaacio de busqueda.
        reductionRate=0.02; % 
        u=u.*ones(1,dimensiones); l=l.*ones(1,dimensiones);
        it_outlier=10;      % Iteracion en la que aparecen lopts outliers.
        Noutlier= 0;%0.05*pop_size; % Numero de outliers.
        medTot=zeros(iteraciones,6);
        %Creacion de las posiciones optimas:
        optimos=zeros(modas,dimensiones);
        for picos=1:modas
            optimos(picos,:)= l+(u-l).*rand(1,dimensiones);        
        end        
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
            if it>1
                if GDM==1
                    D1=DTAP(X); 
                elseif GDM==2
                    D1=TD(X); 
                elseif GDM==3
                    D1=MI(X); 
                elseif GDM==4
                    D1=PW(X); 
                elseif GDM==5
                    D1=VAC(X);  
                else
                    D1=nVOL2(X,l,u); 
                end
                bestD1=max(D1,bestD1);
                actualD1=D1/bestD1;
%                 medidas(it,contSample)=[actualD1];   
                medidas(it,contador)=[actualD1];  
                if it==49
                   contador=contador+1;
                end
                %contador=contador+1;
            else  
                D1=1; 
                if GDM==1
                    bestD1=DTAP(X); 
                elseif GDM==2
                    bestD1=TD(X); 
                elseif GDM==3
                    bestD1=MI(X); 
                elseif GDM==4
                    bestD1=PW(X); 
                elseif GDM==5
                    bestD1=VAC(X);             
                else
                    bestD1=nVOL2(X,l,u); 
                end
            end
        end  
    end
    p_value=friedman(medidas(5:10,:));
    if p_value<alfa
        resultados(1,contadorInstancia)=resultados(1,contadorInstancia)+1;
    end    
 end
 close all
 %resultados(1,contadorInstancia)=100-resultados(1,contadorInstancia);
 contadorInstancia=contadorInstancia+1;
end
A1=11;