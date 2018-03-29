close all,clear all,clc;
load('hall.mat');
load('JpegCoeff.mat');
subplot(1,2,1);imshow(hall_gray);title('ԭͼ');
doc='MATLAB is very interesting!'; %��������
data=dec2bin(double(doc));%����Ҫ���ص���Ϣת��Ϊ����������
ascii_code=reshape(data',1,numel(data));%��numel�����õ������Ԫ�ظ���
ascii_len=length(ascii_code);
count=1;
for i=1:size(hall_gray,1)
    for j=1:size(hall_gray,2)
        if(count<=ascii_len)
            hall_bin=dec2bin(hall_gray(i,j));%�滻��λΪ������Ϣ
            hall_gray(i,j)=hall_gray(i,j)-hall_bin(end)+ascii_code(count);
            count=count+1;
        end
    end
end
%run JPEG;%JPEG�����
%��ȡ������Ϣ
count=1;
getinfo=zeros(1,ascii_len);
for i=1:size(hall_gray,1)
    for j=1:size(hall_gray,2)
        if(count<=ascii_len)
            hall_bin=dec2bin(hall_gray(i,j));%�滻��λΪ������Ϣ
            getinfo(count)= hall_bin(end)-'0';%��ȡ��Ϣ
            count=count+1;
        end
    end
end
info=[];
for i=1:length(doc)
     info2str=num2str(getinfo(7*i-6:7*i));
     tempinfo=bin2dec(info2str);
     info=[info,tempinfo];
end
subplot(1,2,2);imshow(hall_gray);title('����������Ϣ���ͼ');
imwrite(hall_gray,'hall_hide1.jpg');
char(info)

