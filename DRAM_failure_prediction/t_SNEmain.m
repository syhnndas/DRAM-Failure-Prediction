clear; clc; close all;
Data = xlsread('特征值.xlsx'); % 80x17代表80个样本，每个样本长度是16个特征值，最后一列是标签
data = Data(:,1:16); % 数据
label = Data(:,17); % 标签

data = mapminmax(data); % 进行归一化，不然画图不好看

data2 = tsne(data,'Algorithm','exact','Distance','euclidean'); % 对data进行t-sne降维
data2 = mapminmax(data2'); % 进行归一化，不然画图不好看
data2 = data2';

figure; gscatter(data2(:,1), data2(:,2), label); % 若无label输入，则画出的图没有色彩区分
title('t-SNE降维可视化结果');
xlabel('t-SNE降维后第一维度'); ylabel('t-SNE降维后第二维度');
set(gca,'FontSize',14); 



clear;clc;

data = xlsread("Train_features.csv");
label = xlsread("train_label.csv");

data_nor = mapminmax(data); % 进行归一化，不然画图不好看



data2 = tsne(data_nor); % 对data进行t-sne降维 % 'Algorithm','exact','Distance','euclidean'
data3 = mapminmax(data2');
data4 = data3';

figure; gscatter(data4(:,1), data4(:,2), label); % 若无label输入，则画出的图没有色彩区分
title('t-SNE降维可视化结果');
% xlabel('The first dimension'); ylabel('The second dimension');
set(gca,'FontSize',14); 



choose_id = [5,6,7,9,10,12,14,16,17,18,19];

data_nor = mapminmax(data(:,choose_id)); % 进行归一化，不然画图不好看

data2 = tsne(data_nor,'Algorithm','exact','Distance','euclidean'); % 对data进行t-sne降维 % 'Algorithm','exact','Distance','euclidean'
data3 = mapminmax(data2');
data4 = data3';

figure; gscatter(data4(:,1), data4(:,2), label); % 若无label输入，则画出的图没有色彩区分
title('t-SNE降维可视化结果');
% xlabel('The first dimension'); ylabel('The second dimension');
set(gca,'FontSize',14); 
