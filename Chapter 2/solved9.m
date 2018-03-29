close all,clear all,clc;
load('hall.mat');
load('img.mat');
load('JpegCoeff.mat');
[L,W]=size(hall_gray);
image=size(img);
tempDC=img(1,:);
%DC编码
for i=2:image(2)                       %差分编码
    tempDC(i)=img(1,i-1)-img(1,i);
end
DC1=[];
category = ceil(log2(abs(tempDC)+1));  %确定category的值
 for k=1:image(2)
    huffman = DCTAB(category(k)+1, 2:1+DCTAB(category(k)+1,1));
    Magnitude = str2num((dec2bin(abs(tempDC(k))))')';%字符型转换为常数型
    if(tempDC(k)<0) %对负数进行补码处理
       Magnitude=~Magnitude;
    end
     DC1=[DC1,huffman,Magnitude];    
 end 
%AC编码
AC1=[];
tempAC=img(2:64,:);
EOB=[1,0,1,0];%对块结束编码
ZRL=[1,1,1,1,1,1,1,1,0,0,1];
Run=0;%行程
for i = 1:image(2)
    position = find(tempAC(:,i)~=0);%找到非零数的位置
    len=length(position);
    if(len)
        prepos = 1;
        for j = 1:len
            Run = position(j)-prepos;%计算行程
            prepos = position(j) + 1;%更新前一个非0数的坐标
            count=floor(Run/16);     %计算有多少个16个0连续的情况 
            Run=Run-16*count;
            while(count>0)
                AC1 = [AC1,ZRL];
                count = count - 1;
            end
            ac = tempAC(position(j),i);
            Size= ceil(log2(abs(ac)+1));
            Ampli = str2num((dec2bin(abs(ac)))')';
            if(ac<0)
                Ampli = ~Ampli;
            end
            Huffman = ACTAB(Run*10+Size,4:ACTAB(Run*10+Size,3)+3);
            AC1 = [AC1,Huffman,Ampli];
        end
    end
    AC1=[AC1,EOB];%块结束
end
save('jpegcodes.mat','DC1','AC1','L','W');
