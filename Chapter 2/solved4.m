close all,clear all,clc;
load('hall.mat');
hall_part=hall_gray(1:100,1:100);
hall_dct=dct2(hall_part);
[leng,wide]=size(hall_dct);
hall_rt=hall_dct';
hall_rot90=rot90(hall_dct);
hall_rot180=rot90(rot90(hall_dct));
RT=idct2(hall_rt)/256;      %����idct�任�Ľ��Ϊdouble�ͣ���Ҫ��һ��
ROT90=idct2(hall_rot90)/256;
ROT180=idct2(hall_rot180)/256;
subplot(2,2,1);imshow(hall_part);title('ԭͼ����');
subplot(2,2,2);imshow(RT);title('ת��');
subplot(2,2,3);imshow(ROT90);title('��ת90��');
subplot(2,2,4);imshow(ROT180);title('��ת180��');
imwrite(RT,'RT.jpg');
imwrite(ROT90,'R0T90.jpg');
imwrite(ROT180,'ROT180.jpg');