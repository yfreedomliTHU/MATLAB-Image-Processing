close all,clear all,clc;
load('hall.mat');
load('img.mat');
load('JpegCoeff.mat');
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
save('jpegcodes.mat','DC1','AC1','L','W');
