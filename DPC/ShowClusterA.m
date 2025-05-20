function  ShowClusterA( A,ctitle )
%SHOWCLUSTERA �˴���ʾ�йش˺�����ժҪ
%���ݸ�ʽΪ���У�ǰ�����Ƕ�ά���ݣ����һ�������  x,y,c  
%�����ʾ7�����ľ���

% colors=['r','g','b','y','m','c','k'];
[row,col]=size(A);
pointStyles=['+', '*', '.', 'x','o','s','d','p','h','>'];
L=unique(A(:,col));%������A�ĵ�col�е�Ψһֵ��ȡ������L��//
N=length(L);
lineStyles = linspecer(N);
lineStyles=[[1,1,1];lineStyles];
figure;
for i=1:N
    ir = find(A(:,col)==L(i,1));         % ����������
    if(~isempty(ir))
        if col>3
            scatter3(A(ir,1),A(ir,2),A(ir,3),'MarkerFaceColor',lineStyles(i+1,:),'MarkerEdgeColor',lineStyles(i+1,:));%,'Marker','.'
        else
            scatter(A(ir,1),A(ir,2),'MarkerFaceColor',lineStyles(i+1,:),'MarkerEdgeColor',lineStyles(i+1,:));          
            
        end
        hold on
    end
   
end
% hold off
title(ctitle);

end

