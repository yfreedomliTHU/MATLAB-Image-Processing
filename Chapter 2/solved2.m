close all,clear all,clc;
load('hall.mat');
hall_part = hall_gray(11:18,21:28);
N = 8;
[M,N]=size(hall_part);
D = zeros(M,N);
for i = 1:N
    for j = 1:N
        if(i==1)
           D(i,j) = sqrt(1/N)*cos(pi*(i-1)*(2*j-1)/(2*N));  %����ʵ��ָ����ԭ��D�ĵ�һ��ϵ����Ӧ��ai=sqrt��1/N��
        else
           D(i,j) = sqrt(2/N)*cos(pi*(i-1)*(2*j-1)/(2*N));
        end     
    end
end
P = double(hall_part);
myDCT2 = D*P*D';
DCT2 = dct2(hall_part);