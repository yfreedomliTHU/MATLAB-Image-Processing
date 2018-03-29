close all,clear all,clc;
load('hall.mat');load('img.mat');
load('jpegcodes.mat');
load('JpegCoeff.mat');
Len=L/8;Wid=W/8;
%DCdecode
DC_decode=[];tempDC=DC1;
while(length(tempDC)~=0)
    [huff_len,category]=getcategory(tempDC,DCTAB); %获取category的值
    tempDC(1:huff_len)=[];  %取得category后将对应的huffman编码在tempDC中去除
    if(category==0)
        DC_decode=[DC_decode,0];%直接补0
        tempDC(1)=[];
    else
        Magnitude=tempDC(1:category);%根据category取出对应的Magnitude
        tempDC(1:category)=[];
        if(Magnitude(1)==0) %对负数取补码,并标记符号为负
            Magnitude=~Magnitude;
            signal=-1;
        else
            signal=1;
        end   
        error = bin2dec(num2str(Magnitude)); %将Magnitude转化为十进制的预测误差
        if(signal==-1)
            error=-error;
        end
        DC_decode=[DC_decode,error]; 
    end
end
for i=2:length(DC_decode)
    DC_decode(i)=DC_decode(i-1)-DC_decode(i);   %由差分方程得到解码结果
end
%ACdecode
EOB=[1,0,1,0];ZRL=[1,1,1,1,1,1,1,1,0,0,1];
tempAC=AC1;col_vector=[];%列向量
AC_decode=[];
ZRLzero=zeros(1,16);
while(length(tempAC)~=0)
    if(tempAC(1:4)==EOB) %当解码到块结束（EOB）时
        addzero=zeros(1,63-length(col_vector)); %直接末尾补0
        Col_vector=[col_vector,addzero]';
        tempAC(1:4)=[]; %已经解码过的都清除
        AC_decode=[AC_decode,Col_vector];
        col_vector=[];%解码下一列前注意清零
    elseif(tempAC(1:11)==ZRL) %当解码到（ZRL）时
        col_vector=[col_vector,ZRLzero]; %补16个0
        tempAC(1:11)=[]; %已经解码过的都清除
    else
        [Run,Size,Huff_len ] = getsizerun(tempAC,ACTAB);
        Runzero=zeros(1,Run);%将行程对应个数的0写入列向量
        col_vector=[col_vector,Runzero];
        tempAC(1:Huff_len)=[];
        Amplitude=tempAC(1:Size);%取出Amplitude
        if(Amplitude(1)==0)   %判断第一位是否为0，对负数取补码
            Amplitude=~Amplitude;
            signal=-1;
        else
            signal=1;
        end
        error = bin2dec(num2str(Amplitude)); %将Amplitude转化为十进制的预测误差
        if(signal==-1)
            error=-error;
        end
        col_vector=[col_vector,error];
        tempAC(1:Size)=[];
    end
end
recovery=zeros(L,W);
re_img=[DC_decode;AC_decode];
Col=1;
for i=1:Len  %反量化
    for j=1:Wid
        rezigzag=re_img(:,Col);
        b=antizigzag(rezigzag);
        Dct=b.*QTAB;
        recovery(8*i-7:8*i,8*j-7:8*j)=idct2(Dct);
        Col=Col+1;
    end
end
recovery=recovery+128;
hall_decode=uint8(recovery);
subplot(1,2,1);imshow(hall_gray);title('原图');
subplot(1,2,2);imshow(hall_decode);title('反编码恢复图');
imwrite(hall_decode,'hall_deode11.jpg');
MSE=sum(sum((double(hall_decode)-double(hall_gray)).^2))/L/W;
PSNR=10*log10(255^2/MSE)

