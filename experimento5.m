% BENCHMARK 1: [2012Corriveau]
% Decreases the diversity linearly from a fully scattered population to a
% fully converged one. This benchmark is for n dimensions.
% Valentin Osuna-Enciso, Septiembre 2019. CUCEI-UDG.
%EXPERIMENT 5: EFFECT OF OUTLIERS.
u=50;  l=-50;  % Limites de espacio de busqueda.
reductionRate=0.02; % 
repeticiones=50;
iteraciones=49;     % Numero maximo de iteraciones para todo el proceso.
dimensiones=100;      % Dimensiones del problema.
pop_size=100;       % Tamano de poblacion.
Noutlier= 0.1*pop_size;%0.01*pop_size; %0; 0.05*pop_size; 0.1*pop_size; % Numero de outliers.
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
            D1=DTAP(X); 
            D2=TD(X); 
            D3=MI(X); D4=PW(X); D5=VAC(X);
            
            bestD1=max(D1,bestD1);            
            actualD1=D1/bestD1;
            bestD2=max(D2,bestD2);
            actualD2=D2/bestD2;
            bestD3=max(D3,bestD3);
            actualD3=D3/bestD3;
            bestD4=max(D4,bestD4);
            actualD4=D4/bestD4;
            bestD5=max(D5,bestD5);
            actualD5=D5/bestD5; 
            D6=nVOL2(X,l,u);            
            medidas(it,:)=[actualD1,actualD2,(actualD3),actualD4,(actualD5),D6];
        else  
            D1=1; D2=1; D3=1; D4=1; D5=1; D6=nVOL2(X,l,u);
            bestD1=DTAP(X); bestD2=TD(X); bestD3=MI(X); 
            bestD4=PW(X); bestD5=VAC(X);  bestD6=D6;   
            medidas(it,:)=[D1,D2,D3,D4,D5,1];
        end
    end  
    medTot=medTot+medidas;
    estabilidad1=[estabilidad1,medidas(:,1)]; 
    estabilidad2=[estabilidad2,medidas(:,2)];
    estabilidad3=[estabilidad3,medidas(:,3)];
    estabilidad4=[estabilidad4,medidas(:,4)];
    estabilidad5=[estabilidad5,medidas(:,5)];
    estabilidad6=[estabilidad6,medidas(:,6)];
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
errores=[];
for ind=1:6
    B=medTot(1,ind):-(medTot(1,ind)-medTot(end,ind))/49:medTot(end,ind);
    B=B(1,1:49);
    errores=[errores,sqrt(sum((medTot(:,ind)'-B).^2))];    
end
A=1;