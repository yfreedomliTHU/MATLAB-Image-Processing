close all,clear all,clc;
load('hall.mat');
load('JpegCoeff.mat');
subplot(1,2,1);imshow(hall_gray);title('原图');
doc='MATLAB is very interesting!'; %输入文字
data=dec2bin(double(doc));%将需要隐藏的信息转化为二进制码流
ascii_code=reshape(data',1,numel(data));%由numel函数得到矩阵的元素个数
ascii_len=length(ascii_code);
count=1;
for i=1:size(hall_gray,1)
    for j=1:size(hall_gray,2)
        if(count<=ascii_len)
            hall_bin=dec2bin(hall_gray(i,j));%替换低位为隐藏信息
            hall_gray(i,j)=hall_gray(i,j)-hall_bin(end)+ascii_code(count);
            count=count+1;
        end
    end
end
%run JPEG;%JPEG编解码
%获取隐藏信息
count=1;
getinfo=zeros(1,ascii_len);
for i=1:size(hall_gray,1)
    for j=1:size(hall_gray,2)
        if(count<=ascii_len)
            hall_bin=dec2bin(hall_gray(i,j));%替换低位为隐藏信息
            getinfo(count)= hall_bin(end)-'0';%获取信息
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
subplot(1,2,2);imshow(hall_gray);title('加入隐藏信息后的图');
imwrite(hall_gray,'hall_hide1.jpg');
char(info)

