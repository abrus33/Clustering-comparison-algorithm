clc;
clear all;
close all;
%% ��ȡ����    %KK����� KΪ���ڵ����
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
B=libsvmscale(B,0,1); % ���ݹ�һ��   ��ʹ�õĹ���y=lower+��upper-lower��*(x-MinValue)/(MaxValue-MinValue)
[rows,dim]=size(AA);
A=[B,AA(:,end)];
LAB=AA(:,end);        %��ȡ���һ�е�����Ԫ��//
LAB(LAB==0)=3;                  %������%     %��LAB�е���0��Ԫ�ض���ֵΪ3��
a=max(AA(:,end));
AA(find(LAB==0),end)=a+1;       %������%     % find(LAB==0)����LAB��Ϊ0��λ��
% %% ��ʾԭʼ��� 
% %���ݸ�ʽΪ���У�ǰ�����Ƕ�ά���ݣ����һ�������  x,y,c  
% %�����ʾ7�����ľ���
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
%     ari(j)=GetAri(ret.cl,LAB);    %��������ָ��%
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
b=find(ari==max(ari))            % ari==max(ari):ֵ��find(ari==max(ari))����ari��max�����     %���ྫ����󣿴�ʱbΪ��ѵ�k���ڸ���i%
ami=ami(b(1))                    %b(1)����Ϊ���ֵ���ܲ�ֹһ��������ֱ����b%
ari=ari(b(1))      
fmi=fmi(b(1))
b(1)=b(1)/10+1;   %������dc�ٷֱ�ֵi%
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
scatter(B(ret.icl,1),B(ret.icl,2),100,'kh','MarkerFaceColor','w');    % h:�����Σ�������ͣ� k:��ɫ(�����ɫ��
end