clc;
clear all;
close all;
%% 读取数据    %KK类别数 K为近邻点个数
% AA=load('jain.txt');KK=2;
% AA=load('C:\Users\13700\Desktop\DPC\dataset\shape\flame.txt');KK=2;K=51;dc=2.8;%60,61;1.2,1.3
% AA=load('C:\Users\13700\Desktop\DPC\dataset\shape\jain.txt');KK=2;K=2;dc=2.3;%11,35;18.8,14.6
% AA=load('C:\Users\13700\Desktop\DPC\dataset\shape\pathbased.txt');KK=3;K=17;dc=3.7;%16,18;11.2,11.3
% AA=load('C:\Users\13700\Desktop\DPC\dataset\shape\R15.txt');KK=15;K=10;dc=1.74;%11,15;3.4,3.5
% AA=load('C:\Users\13700\Desktop\DPC\dataset\shape\spiral.txt');KK=3;K=2;dc=1.7;%166,167;1.3,1.4
% AA=load('jain.txt');KK=2;%k=6;
% AA=load('flame.txt');KK=2;%dc=2.8%k=6;%TNMM_RD_MCM1:k=8
 AA=load('jain.txt');KK=2;dc=1.5%,6,7,8%k=6;
% AA=load('LineBlobs2.txt');KK=3;%dc=4.3,34%k=8;
%  AA=load('spiral.txt');KK=3;%dc=1.8;%k=8;
% AA=load('pathbased.txt');KK=3;k=8;%k=8;%k=5;
% AA=load('Ls3.txt');KK=6;
% AA=load('cth3.txt');KK=3;
% AA=load('CMC.txt');KK=3;
% AA=load('ring.txt');KK=2;
% AA=load('Sticks2.txt');KK=4;
% AA=load('Compound.txt');KK=6;%dc=3.9;30,31%k=6;
% AA=load('Aggregation.txt');KK=7;%dc=3.2,27,28%k=6;
% AA=load('R15.txt');KK=15;%dc=1.2;3,4,5%k=18;
% AA=load('D31.txt');KK=31;%dc=1.1;2;
% AA=load('circle3.txt');KK=3;
% AA=load('iris.txt');KK=3;%dc=2.9;20,21%k=29;
% AA=load('Wine.txt');KK=3;%k=25;
% AA=load('seeds_dataset.txt');KK=3;%dc=1.1;2,3%k=35;
% AA=load('ecoli.txt');KK=8;%k=41;
% AA=load('Libras.txt');KK=15;
% AA=load('Ionosphere.txt');KK=2;
% AA=load('dermatology.txt');KK=6;
% AA=load('Wdbc.txt');KK=2;
%%
B=AA(:,1:end-1);
B=libsvmscale(B,0,1); % 数据归一化   所使用的规则：y=lower+（upper-lower）*(x-MinValue)/(MaxValue-MinValue)
[rows,dim]=size(AA);
A=[B,AA(:,end)];
LAB=AA(:,end);        %提取最后一列的所有元素//
LAB(LAB==0)=3;                  %？？？%     %将LAB中等于0的元素都赋值为3。
a=max(AA(:,end));
AA(find(LAB==0),end)=a+1;       %？？？%     % find(LAB==0)：找LAB中为0的位置
% %% 显示原始结果 
% %数据格式为三列，前两列是二维数据，最后一列是类别  x,y,c  
% %最多显示7种类别的聚类
if( dim==3)
    ShowClusterA(A,'origin spiral')
end
%%
A=[B,AA(:,end)];
j=0;
for i=1:0.1:5
%  	tic
    j=j+1;
	ret=DPC(i,B,KK);
    cl = ret.cl ;
%     ari(j)=GetAri(ret.cl,LAB);    %三种评估指标%
%     %fmi(j)= compute_FMI(ret.cl,LAB);
%       %ari(j)=compute_ARI(ret.cl,LAB);
%    fmi(j)=GetFmi(ret.cl,LAB);
%     ami(j)=calculate_ami(ret.cl,LAB);    %
 ami(j)=GetAmi1(ret.cl,LAB);
    ari(j)=GetAri1(ret.cl,LAB);
    fmi(j)=GetFmi1(ret.cl,LAB);
        
    i
    if ami(j)==1
        break
    end
%  	toc
% 	t(i)=toc;
end
b=find(ari==max(ari))            % ari==max(ari):值，find(ari==max(ari))：找ari中max的序号     %聚类精度最大？此时b为最佳的k近邻个数i%
ami=ami(b(1))                    %b(1)是因为最大值可能不止一个，不能直接用b%
ari=ari(b(1))      
fmi=fmi(b(1))
b(1)=b(1)/10+1;   %真正的dc百分比值i%
% mean(t)
ret=DPC(b(1),B,KK);
F=[B,ret.cl'];
% [RI,ARI,NMI]=evolution(A,F,KK);
% ami=GetAmi(ret.cl,AA(:,end))
% ari=GetAri(ret.cl,AA(:,end))
% fmi=GetFmi(ret.cl,AA(:,end))
% acc=ClusteringAccuracy(ret.cl',AA(:,end));

if( dim==3)
ShowClusterA(F,' ');
hold on
scatter(B(ret.icl,1),B(ret.icl,2),100,'kh','MarkerFaceColor','w');    % h:六角形（标记类型） k:黑色(标记颜色）
end