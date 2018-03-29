close all,clear all,clc;
load('hall.mat');
load('JpegCoeff.mat');
QTAB=QTAB/2;
[leng,wide]=size(hall_gray);
temp=double(hall_gray)-128;  %Ԥ����
Len=leng/8;
Wid=wide/8;
img=zeros(64,Len*Wid);
col=1;
%�ֿ飬DCT������
for i=1:Len
    for j=1:Wid              %��8*8�Ĺ�ģ�ֿ鴦��
        tempdct=dct2(temp(8*i-7:8*i,8*j-7:8*j));
        tempdct=round(tempdct ./ QTAB);
        img(:,col)=zigzag(tempdct);
        col=col+1;
    end
end
[L,W]=size(hall_gray);
image=size(img);
tempDC=img(1,:);
%DC����
for i=2:image(2)                       %��ֱ���
    tempDC(i)=img(1,i-1)-img(1,i);
end
DC1=[];
category = ceil(log2(abs(tempDC)+1));  %ȷ��category��ֵ
 for k=1:image(2)
    huffman = DCTAB(category(k)+1, 2:1+DCTAB(category(k)+1,1));
    Magnitude = str2num((dec2bin(abs(tempDC(k))))')';%�ַ���ת��Ϊ������
    if(tempDC(k)<0) %�Ը������в��봦��
       Magnitude=~Magnitude;
    end
     DC1=[DC1,huffman,Magnitude];    
 end 
%AC����
AC1=[];
tempAC=img(2:64,:);
EOB=[1,0,1,0];%�Կ��������
ZRL=[1,1,1,1,1,1,1,1,0,0,1];
Run=0;%�г�
for i = 1:image(2)
    position = find(tempAC(:,i)~=0);%�ҵ���������λ��
    len=length(position);
    if(len)
        prepos = 1;
        for j = 1:len
            Run = position(j)-prepos;%�����г�
            prepos = position(j) + 1;%����ǰһ����0��������
            count=floor(Run/16);     %�����ж��ٸ�16��0��������� 
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
    AC1=[AC1,EOB];%�����
end
Len=L/8;Wid=W/8;
%DCdecode
DC_decode=[];tempDC=DC1;
while(length(tempDC)~=0)
    [huff_len,category]=getcategory(tempDC,DCTAB); %��ȡcategory��ֵ
    tempDC(1:huff_len)=[];  %ȡ��category�󽫶�Ӧ��huffman������tempDC��ȥ��
    if(category==0)
        DC_decode=[DC_decode,0];%ֱ�Ӳ�0
        tempDC(1)=[];
    else
        Magnitude=tempDC(1:category);%����categoryȡ����Ӧ��Magnitude
        tempDC(1:category)=[];
        if(Magnitude(1)==0) %�Ը���ȡ����,����Ƿ���Ϊ��
            Magnitude=~Magnitude;
            signal=-1;
        else
            signal=1;
        end   
        error = bin2dec(num2str(Magnitude)); %��Magnitudeת��Ϊʮ���Ƶ�Ԥ�����
        if(signal==-1)
            error=-error;
        end
        DC_decode=[DC_decode,error]; 
    end
end
for i=2:length(DC_decode)
    DC_decode(i)=DC_decode(i-1)-DC_decode(i);   %�ɲ�ַ��̵õ�������
end
%ACdecode
EOB=[1,0,1,0];ZRL=[1,1,1,1,1,1,1,1,0,0,1];
tempAC=AC1;col_vector=[];%������
AC_decode=[];
ZRLzero=zeros(1,16);
while(length(tempAC)~=0)
    if(tempAC(1:4)==EOB) %�����뵽�������EOB��ʱ
        addzero=zeros(1,63-length(col_vector)); %ֱ��ĩβ��0
        Col_vector=[col_vector,addzero]';
        tempAC(1:4)=[]; %�Ѿ�������Ķ����
        AC_decode=[AC_decode,Col_vector];
        col_vector=[];%������һ��ǰע������
    elseif(tempAC(1:11)==ZRL) %�����뵽��ZRL��ʱ
        col_vector=[col_vector,ZRLzero]; %��16��0
        tempAC(1:11)=[]; %�Ѿ�������Ķ����
    else
        [Run,Size,Huff_len ] = getsizerun(tempAC,ACTAB);
        Runzero=zeros(1,Run);%���г̶�Ӧ������0д��������
        col_vector=[col_vector,Runzero];
        tempAC(1:Huff_len)=[];
        Amplitude=tempAC(1:Size);%ȡ��Amplitude
        if(Amplitude(1)==0)   %�жϵ�һλ�Ƿ�Ϊ0���Ը���ȡ����
            Amplitude=~Amplitude;
            signal=-1;
        else
            signal=1;
        end
        error = bin2dec(num2str(Amplitude)); %��Amplitudeת��Ϊʮ���Ƶ�Ԥ�����
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
for i=1:Len  %������
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
subplot(1,2,1);imshow(hall_gray);title('ԭͼ');
subplot(1,2,2);imshow(hall_decode);title('������ָ�ͼ');
imwrite(hall_decode,'hall_deode12.jpg');
MSE=sum(sum((double(hall_decode)-double(hall_gray)).^2))/L/W;
PSNR=10*log10(255^2/MSE)

