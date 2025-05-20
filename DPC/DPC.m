function [ ret ] = DPC( dc,A,KK )%,class_num,k)    %KKΪѡ������ĵ������������3��7��17;3���ʱ��Ч�����%
%CFSFDP ���������󷵻�����������е�
%   �˴���ʾ��ϸ˵��
%     xx=load('example_distances.dat');
%     clear all  
%     close all  
%     disp('The only input needed is a distance matrix file')  
%     disp('The format of this file should be: ')  
%     disp('Column 1: id of element i')  
%     disp('Column 2: id of element j')  
%     disp('Column 3: dist(i,j)')  
%% ʹ���ڲ���������
B=pdist2(A,A,'minkowski',2);  %�������ݼ�A������֮��ľ���  % B:����Ķ�ά����
%  B=pdist2(img_val,img_val,'minkowski',2);%���ɾ���Ķ�ά���� 
% save('B.mat','B');%�������ݣ����ڲ������ַ�����ʱ��
%  distance=mat2dist(B);%�Ľ���ֱ�ӵ��ú�����Ч�ʱȽϺ�

[row_b,col_b]=size(B);   % row_b:B��������col_b:B������
%  clear distance;
 xx=zeros(row_b*(row_b-1)/2,3);  %����[row_b*(row_b-1)/2]�У�3�е������   %��СΪm*(m-1)/2
 index=1;
 for i=1:row_b   %��B�����������ݴ���xx�����У�����¼����(i,j)%
     for j=i+1:col_b
         xx(index,1)=i;
         xx(index,2)=j;
         xx(index,3)=B(i,j);
         index=index+1;
     end
 end
    %% ���ļ��ж�ȡ����  

%     axe=load('var.mat','distance'); 
%     xx=axe.distance;

%     xx=distance_mat;
    ND=max(xx(:,2));  
    NL=max(xx(:,1));  
    if (NL>ND)  
      ND=NL;  %% ȷ�� DN ȡΪ��һ�������ֵ�еĽϴ��ߣ���������Ϊ���ݵ�����  
    end  

    N=size(xx,1); %% xx ��һ��ά�ȵĳ��ȣ��൱���ļ�����������������ܸ�����  % N:XX������

    %% ��ʼ��Ϊ��    
    %ʹ�þ����ʼ�����ṩ���������ٶ�
%   dist=zeros(ND,ND);
%     for i=1:ND  
%       for j=1:ND  
%         dist(i,j)=0;  
%       end  
%     end  

    %% ���� xx Ϊ dist ���鸳ֵ��ע������ֻ���� 0.5*DN(DN-1) ��ֵ�����ｫ�䲹����������  
    %% ���ﲻ���ǶԽ���Ԫ��  
    for i=1:N       %dist������B��ȣ�%
      ii=xx(i,1);  
      jj=xx(i,2);  
      dist(ii,jj)=xx(i,3);  
      dist(jj,ii)=xx(i,3);  
    end  
    
    %% ȷ�� dc  %ע�ͺ��˹�ȷ��dcֵ��%
%     hmise=mean(1.06*std(A,0,1)*row_b^(-1.0/k));  %%
%     percent=hmise*100;  
 %   percent=8.0;
%     fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);  

%    position=round(N*percent/100); %% round ��һ���������뺯��  
%    sda=sort(xx(:,3)); %% �����о���ֵ����������  
 %   dc=sda(position);
 %   if(dc<0.00000000001)
 %       dc=min(sda(sda~=0));  % ~= ��ʾ������
 %   end
 percent=dc;
position=round(N*percent/100);   %% round ��һ���������뺯����  %�ڰٷ�֮2��ֵ�������%
sda=sort(xx(:,3));   %% �����о���ֵ����������
dc=sda(position);

    %% ����ֲ��ܶ� rho (���� Gaussian ��)  

%     fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);  

    %% ��ÿ�����ݵ�� rho ֵ��ʼ��Ϊ��  
    %rho=zeros(ND);  %����ND�׷���
     for i=1:ND  
       rho(i)=0.;  
     end  

    %ksdensity���ܶȹ���
%     hmise=mean(1.06*std(B,0,1)*row_b^(-0.2));
%     p = kde(A', hmise ); 
   % p=kde(A', 'rot');
  %  rho=evaluate(p, A');
    % Gaussian kernel  
    for i=1:ND-1  
       for j=i+1:ND  
          rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));  
          rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));             %�����ڼ��㵽j��֮ǰ��j����֮ǰ���rhoֵ
       end  
    end  
%             figure
%         subplot(1,2,1);plot(rho);title('origin rho');    
%         subplot(1,2,2);plot(rho2);title('kde rho'); 

    % "Cut off" kernel  
 %   for i=1:ND-1  
 %     for j=i+1:ND  
 %       if (dist(i,j)<dc)  
 %          rho(i)=rho(i)+1.;  
 %          rho(j)=rho(j)+1.;  
 %       end  
 %     end  
 %   end  

    %% ������������ֵ���������ֵ�����õ����о���ֵ�е����ֵ  
    maxd=max(max(dist));   

    %% �� rho ���������У�ordrho ������  
    [rho_sorted,ordrho]=sort(rho,'descend');  %rho_sortedΪ������������ordrhoΪ����ֵ��rho(ordrho)=rho_sorted.

    %% ���� rho ֵ�������ݵ�  
    delta(ordrho(1))=-1.;  
    nneigh(ordrho(1))=0;  

    %% ���� delta �� nneigh ����  
    for ii=2:ND  
       delta(ordrho(ii))=maxd;  
       for jj=1:ii-1  
         if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))  
            delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));  
            %���ֵ�����ǲ��ǿ����������ࣿ���� 
            % ordrho(jj)����ordrho(ii)����������ordrho(jj)���ܶȸ��� 
            nneigh(ordrho(ii))=ordrho(jj);   
            %% ��¼ rho ֵ��������ݵ����� ordrho(ii) ��������ĵ�ı�� ordrho(jj)  
         end  
       end  
    end  

    %% ���� rho ֵ������ݵ�� delta ֵ  
%     delta(ordrho(1))=max(delta(:));  
    delta(ordrho(1)) = max(max(dist)); 
    %% ����ͼ  

%     disp('Generated file:DECISION GRAPH')   
%     disp('column 1:Density')  
%     disp('column 2:Delta')  

%     fid = fopen('DECISION_GRAPH', 'w');  
%     for i=1:ND  
%        fprintf(fid, '%6.2f %6.2f\n', rho(i),delta(i));  
%     end  

    %% ѡ��һ��Χס�����ĵľ���  
%     disp('Select a rectangle enclosing cluster centers')  
% 
%     %% ÿ̨�����������ĸ�����ֻ��һ����������Ļ�����ľ������ 0  
%     %% >> scrsz = get(0,'ScreenSize')  
%     %% scrsz =  
%     %%            1           1        1280         800  
%     %% 1280 �� 800 ���������õļ�����ķֱ��ʣ�scrsz(4) ���� 800��scrsz(3) ���� 1280  
%     scrsz = get(0,'ScreenSize');  
% 
%     %% ��Ϊָ��һ��λ�ã��о���û����ô auto �� :-)  
%     figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);  
%% ���ݹ�һ��    %������ÿһ�д���������[-1,1]�ڣ� �������е���Сֵ�����ֵӳ��Ϊ[-1 1]��%
rho=mapminmax(rho,0,1);
delta=mapminmax(delta,0,1);
   
%% ind �� gamma �ں��沢û���õ�  
%     ind=zeros(ND);
%     gamma=zeros(ND);
    for i=1:ND  
      ind(i)=i;   
      gamma(i)=rho(i)*delta(i);  
    end  

    %��gamma��������Ȼ��ѡ��ͻ�����Щ��������ֻѡ��ǰ7������
    [gamma_sorted,gamma_order]=sort(gamma,'descend');
   
    
    %��߿��Բ�����ѡ��2����3����Ч���Ƿ񣬳�����3��7��17;3���ʱ��Ч�����    
%      [~,yy]=sort(delta,'descend');
%      sta_d=std(delta);
%     class_num=length(find(delta>3*sta_d));
% %     class_num=2;
%     cccc=yy(1:class_num);
    %������̬�ֲ���һԪ��Ⱥ���ⷽ�� 
 
   % std_val=std(gamma_sorted);
    %class_num=length(find(gamma_sorted>3*std_val));
     class_num=KK;
    cccc=gamma_order(1:class_num);
    %% ���� rho �� delta ����һ����ν�ġ�����ͼ��  

%     subplot(2,1,1)  
 %   figure;
 %   tt=plot(rho(:),delta(:),'o','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');  
%   title ('Decision Graph','FontSize',15.0)  
 %   xlabel ('\rho')  
 %   ylabel ('\delta')  
 
 
 
% 
%     subplot(2,1,1)  
%     rect = getrect(1);   
%     %% getrect ��ͼ��������ȡһ���������� rect �д�ŵ���  
%     %% �������½ǵ����� (x,y) �Լ����ؾ��εĿ�Ⱥ͸߶�  
%     rhomin=rect(1);  
%     deltamin=rect(2); %% ���߳������Ǹ� error������ 4 ��Ϊ 2 ��!  

    %% ��ʼ�� cluster ����  
    NCLUST=0;  

    %% cl Ϊ������־���飬cl(i)=j ��ʾ�� i �����ݵ�����ڵ� j �� cluster  
    %% ��ͳһ�� cl ��ʼ��Ϊ -1  
%     cl=ones(ND)*(-1);
    for i=1:ND  
      cl(i)=-1;  
    end  

%     %% �ھ���������ͳ�����ݵ㣨���������ģ��ĸ���  
%     for i=1:ND  
%       %   if ( (rho(i)>rhomin) && (delta(i)>deltamin))
%       if(ismember(i,cccc)) 
%          NCLUST=NCLUST+1;  
%          cl(i)=NCLUST; %% �� i �����ݵ����ڵ� NCLUST �� cluster  
%          icl(NCLUST)=i;%% ��ӳ��,�� NCLUST �� cluster ������Ϊ�� i �����ݵ�  
%       end  
%     end  
    %ֱ������cccc�����ȡ���ĵ㣬�����ڵ�һ��,�����ķǾ������ĵ㶼��-1
    [~,NCLUST]=size(cccc);   %��Ҫ�У�ֻ��������
    for i=1:NCLUST
        cl(cccc(i))=i;       % ���������ĵ㸳��־��cccc(i)��ԭ���
        icl(i)=cccc(i);      % ��ӳ��,�� i ��cluster������Ϊ cccc(i)�� 
    end

%     fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);  
% 
%     disp('Performing assignation')  

    %% ���������ݵ���� (assignation)  
    for i=1:ND  
      if (cl(ordrho(i))==-1)  
        cl(ordrho(i))=cl(nneigh(ordrho(i)));    %����nneigh���������ܶȱ����ߵ�����㣬���԰����ܶ���ߵ���ͷ���͸պ�ÿ��δ������nneigh�������Ѿ�����ġ�
      end  
    end  
    %% �����ǰ��� rho ֵ�Ӵ�С��˳�����,ѭ��������, cl Ӧ�ö��������ֵ��.   

    %% ������ε㣬halo��δ���Ӧ���Ƶ� if (NCLUST>1) ��ȥ�ȽϺð�  
%     halo=zeros(ND);
    for i=1:ND  
      halo(i)=cl(i);  
    end  

    if (NCLUST>1)  

      % ��ʼ������ bord_rho Ϊ 0,ÿ�� cluster ����һ�� bord_rho ֵ  
%       bord_rho=zeros(NCLUST);
      for i=1:NCLUST  
        bord_rho(i)=0.;  
      end  

      % ��ȡÿһ�� cluster ��ƽ���ܶȵ�һ���� bord_rho  
      for i=1:ND-1    %��������������ǣ�
        for j=i+1:ND  
          %% �����㹻С��������ͬһ�� cluster �� i �� j  
          if ((cl(i)~=cl(j))&& (dist(i,j)<=dc))  
            rho_aver=(rho(i)+rho(j))/2.; %% ȡ i,j �����ƽ���ֲ��ܶ�  
            if (rho_aver>bord_rho(cl(i)))   
              bord_rho(cl(i))=rho_aver;  
            end  
            if (rho_aver>bord_rho(cl(j)))   
              bord_rho(cl(j))=rho_aver;  
            end  
          end  
        end  
      end  

      %% halo ֵΪ 0 ��ʾΪ outlier(��Ⱥ��)  
      for i=1:ND  
        if (rho(i)<bord_rho(cl(i)))  
          halo(i)=0;  
        end  
      end  

    end  

    %% ��һ����ÿ�� cluster  
    for i=1:NCLUST  
      nc=0; %% �����ۼƵ�ǰ cluster �����ݵ�ĸ���  
      nh=0; %% �����ۼƵ�ǰ cluster �к������ݵ�ĸ��� (����cluster ��ȥ����Ⱥ���ĸ��� ��
      for j=1:ND  
        if (cl(j)==i)   
          nc=nc+1;  
        end  
        if (halo(j)==i)   
          nh=nh+1;  
        end  
      end  
%��ʱ�����
%       fprintf('CLUSTER: %i CENTER: %i ELEMENTS: %i CORE: %i HALO: %i \n', i,icl(i),nc,nh,nc-nh);  

    end  

%     cmap=colormap; 
%     
    %% �������ͼ
%     for i=1:NCLUST
%        ic=int8((i*64.)/(NCLUST*1.));
%        subplot(2,1,1)
%        hold on
%        plot(rho(icl(i)),delta(icl(i)),'o','MarkerSize',8,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
%      end
%     subplot(2,1,2)
%     disp('Performing 2D nonclassical multidimensional scaling')
%     Y1 = mdscale(dist, 2, 'criterion','metricstress');
%     plot(Y1(:,1),Y1(:,2),'o','MarkerSize',2,'MarkerFaceColor','k','MarkerEdgeColor','k');
%     title ('2D Nonclassical multidimensional scaling','FontSize',15.0)
%     xlabel ('X')
%     ylabel ('Y')
%     for i=1:ND
%      A(i,1)=0.;
%      A(i,2)=0.;
%     end
%     for i=1:NCLUST
%       nn=0;
%       ic=int8((i*64.)/(NCLUST*1.));
%       for j=1:ND
%         if (halo(j)==i)
%           nn=nn+1;
%           A(nn,1)=Y1(j,1);
%           A(nn,2)=Y1(j,2);
%         end
%       end
%       hold on
%       plot(A(1:nn,1),A(1:nn,2),'o','MarkerSize',2,'MarkerFaceColor',cmap(ic,:),'MarkerEdgeColor',cmap(ic,:));
%     end
    %% ��ͼ����
 
%     faa = fopen('CLUSTER_ASSIGNATION', 'w');  
%     disp('Generated file:CLUSTER_ASSIGNATION')  
%     disp('column 1:element id')  
%     disp('column 2:cluster assignation without halo control')  
%     disp('column 3:cluster assignation with halo control')  
%     for i=1:ND  
%        fprintf(faa, '%i %i %i\n',i,cl(i),halo(i));  
%     end
%     save('cl.mat','cl');
%     save('halo.mat','halo');
    %% ����ͼƬ���ص�һ������е㣬����core��halo
%     %һ��ֻҪ�ж�ǰ���༴��
%     ret1=find(cl~=1);
%     ret2=find(cl~=2);
%     %���ĵ����Ƚ϶����,Ҳ����ʣ�µ����Ƚ��ٵ��࣬Ч���ȽϺã�����ǲ��Ǹ������е���룿������
%     %��Ե���й�ϵ�����ĵĿ϶��ǵ�һ��
%     if(length(ret1)<length(ret2))
%         ret=ret1;
%     else
%         ret=ret2;
%     end
    %% �ڶ�������жϵ�ʱ��ֱ�ӷ������ĵ㼰cluster��
    ret.icl=icl;
    ret.cl=cl;
    ret.gamma_sorted=gamma_sorted;
    ret.halo=halo;
    ret.delta=delta;
    ret.rho=rho;
    ret.nneigh=nneigh;
    ret.dc=dc;
end

