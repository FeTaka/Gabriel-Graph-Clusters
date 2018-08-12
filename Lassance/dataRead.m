function [A, Ay, Date] = dataRead(showPlot)
% input 0 <- pra não plotar
%       1 <- para plotar
% output A <- matrix nx2 onde n é o tamanho da pop
%             e as colunas são as coordenadas
%        yA <- vetor tamanho n , em que:
               %0 indica são
               %1 indica infectado

               
dataI=readtable('cases.txt', 'Format', '%f\t%f\t%f\t%f\t%{dd-MMMM-yy}D',...
    'ReadVariableNames',false);
dataC=load('control.txt');

A = dataC(:, 2:3);
[l, ~] = size(A);
Ay = zeros(l, 1);
n = l;
date = datenum(table2array(dataI(:,5)));
dataI = [table2array(dataI(:, 1:3)), date];
B = dataI(:, 2:3);
[l, ~] = size(B);
By = ones(l, 1);
n = n+l;
A = [A;B];
Ay = [Ay; By];
Date = date;
if showPlot
    H = A(Ay==0, :);
    U = A(Ay==1, :);
    figure;
    plot(H(:, 1),H(:,2), 'x')
    hold on
    plot(U(:, 1),U(:,2), 'or')
    hold off
end
