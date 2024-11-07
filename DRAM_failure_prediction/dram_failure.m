%% 读取数据
clear; clc;
Train_features = xlsread("最终的/Train_Features.csv");
Train_features = Train_features(2:end,:);
Test_features = xlsread("最终的/Test_Features.csv");
Test_features = Test_features(2:end,:);

train_label = xlsread("train_label.csv");
test_label = xlsread("test_label.csv");

%% 特征筛选
mrmr = sort(mrmr(:,2),"descend"); % 从大到小
chi2 = sort(chi2(:,2),"descend");
relief = sort(reliefF(:,2),"descend");
anova = sort(anova(:,2),"descend");

% 矫正
mrmr(20:23) = [0.1664,0.1200,0.1000,0.0500];
relief(23) = 0.0005;

mrmr = mapminmax(mrmr',0,1) / 4;
chi2 = mapminmax(chi2',0,1) / 4;
relief = mapminmax(relief',0,1) / 4;
anova = mapminmax(anova',0,1) / 4;

save("data/mrmr.mat","mrmr"); save("data/chi2.mat","chi2"); 
save("data/relief.mat","relief");  save("data/anova.mat","anova");

mrmr_id =   [21,4,17,22,23,3,16,18,14,2,12,1,19,9,5,11,8,20,10,6,7,13,15];
chi2_id =   [22,18,19,21,8,1,17,4,5,12,23,11,14,2,3,9,13,20,16,10,6,7,15];
relief_id = [21,22,23,14,13,10,7,18,16,3,20,15,2,12,6,19,9,11,5,4,8,17,1];
anova_id =  [18,19,8,17,5,12,22,23,21,2,3,10,20,16,14,9,13,4,15,11,1,7,6];

% a = [mrmr_id" mrmr];

A(mrmr_id) = mrmr; % A就是从1~19的特征分数，对应好的
B(chi2_id) = chi2;
C(relief_id) = relief;
D(anova_id) = anova;
% A B C D已保存，是按顺序从1~19的特征重要性

% A = A(id); B = B(id); C = C(id); D = D(id); 
stack = [A' B' C' D']; % 堆一起，按顺序1~19号特征值

[num,id] = sort(sum(stack'),"descend"); % id是顺序

A = A(id); B = B(id); C = C(id); D = D(id); 
stack2 = [A' B' C' D']; % 这次是按特征重要性顺序了
bar(stack2,"stacked"); 

figure;
bar(stack2,"stacked");
xticks(1:23);
xid = ["CN","MDR","MDC","MOC","DF1","DF2","DF3","DF4","DF5","DF6","DF7","DF8","DF9","DF10","DF11","DF12","DF13",...
    "DF14","DF15","DF16","SM","DM","DN"];
xticklabels(xid(id)); % 排好序的特征
xlabel('Features');
ylabel('Important score');
legend('MRMR','Chi2','ReliefF','ANOVA');

%% Pearson相关性

X = Train_features;
rho = corr(X,'type','Pearson');

rho = abs(roundn(rho,-2));
% 绘制热图
figure;

heatmap(xid,xid,rho);


%% 雷达图
recall = 79.36;
pre = 75.88;
f1 = 2*recall*pre/(pre+recall)


X=randi([2,8],[4,7])+rand([4,7]);
RC=radarChart(X,'Type','Patch');
RC=RC.draw();
RC.legend();
 
colorList=[78 101 155;
          138 140 191;
          184 168 207;
          231 188 198;
          253 207 158;
          239 164 132;
          182 118 108]./255;
for n=1:RC.ClassNum
    RC.setPatchN(n,'FaceColor',colorList(n,:),'EdgeColor',colorList(n,:))
end


X = [74.03,72.33,75.21,73.74;
    78.66,77.19,76.13,76.66;
    83.33,77.25,76.61,76.93;
    82.10,79.36,75.88,77.58];
figure;

RC=radarChart(X);
RC.PropName={'Accuracy','Recall','Precision','F1-score'};
RC.ClassName={'DF1~DF16','DF1~DF16+SM,DM,DV','DF1~DF16+SM,DM,DN+CN,MDR,MDC,MOC','DF1~DF16+SM,DM,DN+CN,MDR,MDC,MOC+FS'};
RC.RLim=[72,85];
RC.RTick=[72:3:85];

RC=RC.draw();
RC.legend();

%% tsne图
% --在t_SNEmain里
%% RF、XGBoost、SVM
recall = 77.36;
pre = 75.92;
f1 = 2*recall*pre/(pre+recall);

rf = [80.91,77.36,75.92,76.63];
xgboost = [83.17,78.25,76.55,77.39];
svm = [82.10,79.36,75.88,77.58];

figure;
b = bar([rf; xgboost; svm]);
xticklabels(["RF","XGBoost","SVM"]);
ylim([70,86]); ylabel('Value(%)');

text(b(1).XEndPoints,b(1).YEndPoints,string(b(1).YData),'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
text(b(2).XEndPoints,b(2).YEndPoints,string(b(2).YData),'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
text(b(3).XEndPoints,b(3).YEndPoints,string(b(3).YData),'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
text(b(4).XEndPoints,b(4).YEndPoints,string(b(4).YData),'HorizontalAlignment','center',...
    'VerticalAlignment','bottom')
legend(["Accuracy","Recall","Precision","F1-score"]);
box off;

%% 降采样比例
clear;
recall = [77.53,79.36,76.73,75.33];
pre = [74.62,75.88,78.21,74.55];
f1 = [76.05,77.58,77.46,74.93];
figure;
plot([recall',pre',f1'],'-*');
legend('Recall', 'Precision', 'F1-score', 'Location', 'best');

% 获取折线图中线的数量
num_lines = length(b);

% 在每个折线图的点上标注数值
for i = 1:num_lines
    xData = b(i).XData;  % 获取X轴数据
    yData = b(i).YData;  % 获取Y轴数据
    for j = 1:length(xData)
        text(xData(j), yData(j), sprintf('%.2f', yData(j)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
end

xlabel('Sample Ratio'); ylabel('Value(%)');
xticks([1:4]);
xticklabels(["0.8:1","1:1","1:1.2","1:1.5"]);

%% 预测时长
recall = 77.25;
pre = 76.61;
f1 = 2*recall*pre/(pre+recall)

line1 = [79.36,75.88,77.58];
line2 = [74.15,73.21,73.67];
line3 = [65.37,70.19,67.69];
line4 = [62.83,62.09,62.45];
line5 = [53.22,61.56,57.09];
line6 = [41.35,44.37,42.81];

figure;
b = plot([line1;line2;line3;line4;line5;line6],'-*');
legend('Recall', 'Pre', 'F1-score');

% 获取折线图中线的数量
num_lines = length(b);

% 在每个折线图的点上标注数值
for i = 1:num_lines
    xData = b(i).XData;  % 获取X轴数据
    yData = b(i).YData;  % 获取Y轴数据
    for j = 1:length(xData)
        text(xData(j), yData(j), sprintf('%.2f', yData(j)), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    end
end

xlabel('Window'); ylabel('Value(%)');
xticks([1:6]);
xticklabels(["5min","10min","30min","1h","10h","1day"]);


