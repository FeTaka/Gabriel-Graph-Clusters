%%% VALIDATION F THE METHOD WITH GMM INPUT

%% Sample parameters
N = 100;
nd = randi([2 5], 1, N); %number of functions
x1 = -9:0.5:9; x2 = -9:0.5:9;
[X1,X2] = meshgrid(x1,x2);
Sigma = [1 0; 0 1];

%% Outputs
r_js = zeros(4,N);%resultado jensen shannon

%% Test loop
for i =1:N
    Mu = rand(nd(i),2)*(9+9)-9;
    
    f_fun = my_gmdistribution(Mu,Sigma,ones(1,nd(i)));
    OX = [X1(:) X2(:)];
    [X, px]= mapstd(OX');
    X = X';

    %creating sick and sane inputs with generated model
    F = pdf(f_fun,OX);
    [F,~]=mapminmax(F', 0, 1);
    D = -1*ones(size(F));
    R = rand(size(F));
    D(R < 0.1*F) = 1;

    %method
    obj = gg_probability_func(X, D');

    pdfO = pdf(f_fun, OX);
    pdfE = pdf(obj, mapstd('apply', OX', px)');
    d_js = jensen_shannon(pdfO, pdfE);
    d_js1 = jensen_shannon(pdfO, ones(size(pdfO)));
    d_js0 = jensen_shannon(pdfO, zeros(size(pdfO)));
    d_jsU = jensen_shannon(pdfO, rand(size(pdfO)));
    r_js(:,i) = [d_js; d_js1; d_js0; d_jsU];
end
save('data_100','r_js')


%% Plots
x1 = -9:0.2:9; x2 = -9:0.2:9;
[X1,X2] = meshgrid(x1,x2);
selX = randperm(numel(X1));
Sigma = [1.5 0; 0 1.5];
Mu=[-6,6;
    -4.5,4;
    -4,5;
    1,-4;
    -1,-5;
    5,5];

f_fun = my_gmdistribution(Mu,Sigma,ones(1,size(Mu,1)));
OX = [X1(:) X2(:)];
OX = OX(selX(1:1000),:);
[X, px]= mapstd(OX');
X = X';

%creating sick and sane inputs with generated model
F = pdf(f_fun,OX);  
Fi = F;
[F, ps]=mapminmax(F', 0, 1);
D = -1*ones(size(F));
R = rand(size(F));
D(R < F) = 1;

%method
obj = gg_probability_func(X, D', [0.0022]);

figure;
plot(OX(D==1,1), OX(D==1,2), '.k')
hold on
h(2)=ezcontour(@(x,y)pdf(f_fun,[x y]'),[-10 10],[-10 10],100);
        %set(h,'edgecolor','none')
        colormap winter
hold off

figure;
plot(OX(D==-1,1), OX(D==-1,2), '.r')
hold on
plot(OX(D==1,1), OX(D==1,2), '.k')

h(2)=ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',px)'),[-10 10],[-10 10],100);
        %set(h,'edgecolor','none')
        colormap autumn
hold off

%
figure;
Z=arrayfun(@(x,y)pdf(f_fun,[x y]'),X1, X2);
plot(max(Z)', 'b')
hold on
Z=arrayfun(@(x,y)pdf(obj,mapstd('apply',[x y]',px)'),X1, X2);
plot(max(Z)', 'r')

pdfO = pdf(f_fun, OX);
pdfE = pdf(obj, mapstd('apply', OX', px)');
d_js = jensen_shannon(pdfO, pdfE);

