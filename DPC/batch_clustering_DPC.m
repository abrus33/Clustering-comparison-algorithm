%clear
data_dir1 = 'D:\数据集\UCI数据集\';
%function batch_clustering_test(data_dir, result_path, K_values)
    % 输入：
    %   data_dir    : 数据集目录（字符串，如 'datasets/'）
    %   result_path : 结果保存路径（字符串，如 'results/summary.xlsx'）
    %   K_values    : 近邻数K的候选值（数组，如 [5, 10, 15]）

    disp(" DPC算法")
    disp("UCI数据集")

% 获取所有数据集文件
file_list = dir(fullfile(data_dir1,'*.txt'));

%遍历每个数据集
for fidx = 1:length(file_list)
    file_name = file_list(fidx).name
    file_name_string=string(file_name);
    file_name_string=string(file_name);
    file_name_string=repmat(file_name_string,1,49);
    dataset_name = strrep(file_name,'.txt','');
    data_path = fullfile(data_dir1,file_name);
    AA = load(data_path);
    %输入真实簇类数，可以写一个数组记录每个数据集的簇类数，一起循环
   
    %% 数据归一化
    a=find(AA(:,end)==0);
    AA(a,end)=3;
    data = AA(:,1:end-1);
    data = libsvmscale(data,0,1);
    [rows,dim] = size(AA);
    A = [data,AA(:,end)];
    answer = AA(:,end);

    KK=max(answer);
    j=0;    
    for i=1:0.1:5
        j=j+1;
        ret=DPC(i,data,KK);
        cl = ret.cl ;

        ami(j)=GetAmi1(ret.cl,answer);
        ari(j)=GetAri1(ret.cl,answer);
        fmi(j)=GetFmi1(ret.cl,answer);
         
        if ami(j)==1
           break
        end
    end
    b=find(ari==max(ari))            % ari==max(ari):值，find(ari==max(ari))：找ari中max的序号     %聚类精度最大？此时b为最佳的k近邻个数i%
ami=ami(b(1))                    %b(1)是因为最大值可能不止一个，不能直接用b%
ari=ari(b(1))      
fmi=fmi(b(1))
b(1)=b(1)/10+1    
end

data_dir2 = 'D:\数据集\人工数据集\';
disp("人工数据集")
% 获取所有数据集文件
file_list = dir(fullfile(data_dir2,'*.txt'));

%遍历每个数据集
for fidx = 1:length(file_list)
    file_name = file_list(fidx).name
    file_name_string=string(file_name);
    file_name_string=string(file_name);
    file_name_string=repmat(file_name_string,1,49);
    dataset_name = strrep(file_name,'.txt','');
    data_path = fullfile(data_dir2,file_name);
    AA = load(data_path);
    
   
    %% 数据归一化
    a=find(AA(:,end)==0);
    AA(a,end)=3;
    data = AA(:,1:end-1);
    data = libsvmscale(data,0,1);
    [rows,dim] = size(AA);
    A = [data,AA(:,end)];
    answer = AA(:,end);

   
    KK=max(answer);
    j=0;    
    for i=1:0.1:5
        j=j+1;
        ret=DPC(i,data,KK);
        cl = ret.cl ;

        ami(j)=GetAmi1(ret.cl,answer);
        ari(j)=GetAri1(ret.cl,answer);
        fmi(j)=GetFmi1(ret.cl,answer);
         
        if ami(j)==1
           break
        end
    end
    b=find(ari==max(ari))            % ari==max(ari):值，find(ari==max(ari))：找ari中max的序号     %聚类精度最大？此时b为最佳的k近邻个数i%
ami=ami(b(1))                    %b(1)是因为最大值可能不止一个，不能直接用b%
ari=ari(b(1))      
fmi=fmi(b(1))
b(1)=b(1)/10+1
end