close all,clear all,clc;
img=imread('sample1.jpg');
[len,wide,high]=size(img);
%img=imrotate(img,90);%˳ʱ����ת90��
%img=imresize(img,[len,2*wide]);
%img = imadjust(img,[0.4 0.7],[]);
load('feature.mat');
L=3;v=v1;e=0.46;%�趨��ֵ
%L=4;v=v2;e=0.58;%�趨��ֵ
%L=5;v=v3;e=0.74;%�趨��ֵ
step_len=5;%��ʼ������
sepa_len=5*step_len;
mayface=zeros(len,wide);
isface=[];
for i=1:step_len:len-sepa_len
    for j=1:step_len:wide-sepa_len
        separate=img(i:i-1+sepa_len,j:j-1+sepa_len,:);
        u=getfeature(separate,L);
        distance=1-sum(sqrt(v.*u)); %��������������׼�ľ���
        if(distance<e)              %С����ֵ��������б�Ϊ����
            mayface(i,j)=1;%�Կ����������Ľ��б��
        end
    end
end
%ͨ����ǻ�ȡ����
for i=1:len
    for j=1:wide
        if(mayface(i,j)==1)
            isface=[isface,[i,i-1+sepa_len,j,j-1+sepa_len]'];%��ȡ����������������
        end
    end
end
m=1;
while(m<length(isface)) %�ϲ��ص�����
    for n=m+1:length(isface)
        L_len=min(abs(isface(2,m)-isface(1,m)),abs(isface(2,n)-isface(1,n)));
        W_len=min(abs(isface(4,m)-isface(3,m)),abs(isface(4,n)-isface(3,n)));
        flag=(abs(isface(1,m)-isface(1,n))>=L_len)||(abs(isface(3,m)-isface(3,n))>=W_len);
        if(~flag)
            isface(1,m)=min(isface(1,m),isface(1,n));
            isface(2,m)=max(isface(2,m),isface(2,n));
            isface(3,m)=min(isface(3,m),isface(3,n));
            isface(4,m)=max(isface(4,m),isface(4,n));
            isface(:,n)=isface(:,m);  %�úϲ����������滻֮ǰ�Ƚϵ��������������        
        end
    end
    m=m+1;
end
m=1;%��ʶ��������ú����
while(m<length(isface))
       for k=isface(1,m):isface(2,m)
           img(k,isface(3,m),:)=[255,0,0];
           img(k,isface(4,m),:)=[255,0,0];
       end
       for l=isface(3,m):isface(4,m)
           img(isface(1,m),l,:)=[255,0,0];
           img(isface(2,m),l,:)=[255,0,0];
       end   
    m=m+1;
end
imshow(img);
%imwrite(img,'rot90.jpg');
%imwrite(img,'WIDE2.jpg');
%imwrite(img,'changecolor.jpg');