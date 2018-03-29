close all,clear all,clc;
load('hall.mat');
load('JpegCoeff.mat');
[leng,wide]=size(hall_gray);
temp=double(hall_gray)-128;  %预处理
Len=leng/8;
Wid=wide/8;
img=zeros(64,Len*Wid);
col=1;
%分块，DCT，量化
for i=1:Len
    for j=1:Wid              %按8*8的规模分块处理
        tempdct=dct2(temp(8*i-7:8*i,8*j-7:8*j));
        tempdct=round(tempdct ./ QTAB);
        img(:,col)=zigzag(tempdct);
        col=col+1;
    end
end
save('img.mat');