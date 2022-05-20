% BENCHMARK 1: [2012Corriveau]
% Decreases the diversity linearly from a fully scattered population to a
% fully converged one. This benchmark is for n dimensions.
% Valentin Osuna-Enciso, Septiembre 2019. CUCEI-UDG.
Noutlier= 0; %0; 0.05*pop_size; 0.1*pop_size; % Numero de outliers.
u=50;  l=-50;  % Limites de espacio de busqueda.
reductionRate=0.02; % 
repeticiones=50;
iteraciones=49;     % Numero maximo de iteraciones para todo el proceso.
dimensiones=180;      % Dimensiones del problema.
pop_size=100;       % Tamano de poblacion.
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
        %%%
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
            %for picos=1:modas                
                %Distribucion de los individuos uniformemente dentro de los
                %limites de cada pico:
                if (ind>(picos-1)*N/modas)&&(ind<=picos*N/modas)
                    %%%
                    X(ind,:)=lopt(picos,:)+(uopt(picos,:)-lopt(picos,:)).*rand(1,dimensiones);
                else
                    picos=picos+1; 
                    X(ind,:)=optimos(picos,:);
                end
            %end
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
            %D6=exp((log(nVOL2(X,l,u)))/(dimensiones*0.5)); %CASO 2
            %bestD6=max(D6,bestD6);                          
            %actualD6=exp((log(D6/bestD6))/(dimensiones*0.5)); %CASO 2
            %actualD6=D6;
            %actualD6=sqrt(sqrt(D6/bestD6)); 
            %actualD6=nthroot(D6/bestD6,dimensiones/2);
            
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
xlabel('Iterations'), ylabel('Diversity measure')
dispersion1=0; dispersion2=0; dispersion3=0; dispersion4=0; 
dispersion5=0; dispersion6=0; ind1=5; ind2=iteraciones;
for ind=ind1:ind2
   x=estabilidad1(ind,:);
   dispersion1=dispersion1+(max(x(x<max(x)))-min(x(x>min(x))));%;range(estabilidad1(ind,:)); 
   x=estabilidad2(ind,:);
   dispersion2=dispersion2+(max(x(x<max(x)))-min(x(x>min(x))));%range(estabilidad2(ind,:));
   x=estabilidad3(ind,:);
   dispersion3=dispersion3+(max(x(x<max(x)))-min(x(x>min(x))));%range(estabilidad3(ind,:));
   x=estabilidad4(ind,:);
   dispersion4=dispersion4+(max(x(x<max(x)))-min(x(x>min(x))));%range(estabilidad4(ind,:));
   x=estabilidad5(ind,:);
   dispersion5=dispersion5+(max(x(x<max(x)))-min(x(x>min(x))));%range(estabilidad5(ind,:));
   x=estabilidad6(ind,:);
   dispersion6=dispersion6+(max(x(x<max(x)))-min(x(x>min(x))));%range(estabilidad6(ind,:));
end
dispersion1=dispersion1/(ind2-ind1); dispersion2=dispersion2/(ind2-ind1);
dispersion3=dispersion3/(ind2-ind1); dispersion4=dispersion4/(ind2-ind1);
dispersion5=dispersion5/(ind2-ind1); dispersion6=dispersion6/(ind2-ind1);
% dispersion1=range(estabilidad1(5,:))-range(estabilidad1(30,:));
% dispersion2=range(estabilidad2(5,:))-range(estabilidad2(30,:));
% dispersion3=range(estabilidad3(5,:))-range(estabilidad3(30,:));
% dispersion4=range(estabilidad4(5,:))-range(estabilidad4(30,:));
% dispersion5=range(estabilidad5(5,:))-range(estabilidad5(30,:));
% dispersion6=range(estabilidad6(5,:))-range(estabilidad6(30,:));
A=1;