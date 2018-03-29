close all,clear all,clc;
img=imread('sample1.jpg');
[len,wide,high]=size(img);
%img=imrotate(img,90);%顺时针旋转90度
%img=imresize(img,[len,2*wide]);
%img = imadjust(img,[0.4 0.7],[]);
load('feature.mat');
L=3;v=v1;e=0.46;%设定阈值
%L=4;v=v2;e=0.58;%设定阈值
%L=5;v=v3;e=0.74;%设定阈值
step_len=5;%初始化步长
sepa_len=5*step_len;
mayface=zeros(len,wide);
isface=[];
for i=1:step_len:len-sepa_len
    for j=1:step_len:wide-sepa_len
        separate=img(i:i-1+sepa_len,j:j-1+sepa_len,:);
        u=getfeature(separate,L);
        distance=1-sum(sqrt(v.*u)); %计算与与人脸标准的距离
        if(distance<e)              %小于阈值，则可以判别为人脸
            mayface(i,j)=1;%对可能是人脸的进行标记
        end
    end
end
%通过标记获取坐标
for i=1:len
    for j=1:wide
        if(mayface(i,j)==1)
            isface=[isface,[i,i-1+sepa_len,j,j-1+sepa_len]'];%获取可能是人脸的坐标
        end
    end
end
m=1;
while(m<length(isface)) %合并重叠部分
    for n=m+1:length(isface)
        L_len=min(abs(isface(2,m)-isface(1,m)),abs(isface(2,n)-isface(1,n)));
        W_len=min(abs(isface(4,m)-isface(3,m)),abs(isface(4,n)-isface(3,n)));
        flag=(abs(isface(1,m)-isface(1,n))>=L_len)||(abs(isface(3,m)-isface(3,n))>=W_len);
        if(~flag)
            isface(1,m)=min(isface(1,m),isface(1,n));
            isface(2,m)=max(isface(2,m),isface(2,n));
            isface(3,m)=min(isface(3,m),isface(3,n));
            isface(4,m)=max(isface(4,m),isface(4,n));
            isface(:,n)=isface(:,m);  %用合并的新坐标替换之前比较的两个区域的坐标        
        end
    end
    m=m+1;
end
m=1;%将识别的区域用红框框出
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