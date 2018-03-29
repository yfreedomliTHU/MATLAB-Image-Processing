close all,clear all,clc;
load('hall.mat');
hall_part=hall_gray(1:100,1:100);
hall_dct=dct2(hall_part);
[leng,wide]=size(hall_dct);
hall_rt=hall_dct';
hall_rot90=rot90(hall_dct);
hall_rot180=rot90(rot90(hall_dct));
RT=idct2(hall_rt)/256;      %由于idct变换的结果为double型，需要归一化
ROT90=idct2(hall_rot90)/256;
ROT180=idct2(hall_rot180)/256;
subplot(2,2,1);imshow(hall_part);title('原图区域');
subplot(2,2,2);imshow(RT);title('转置');
subplot(2,2,3);imshow(ROT90);title('旋转90度');
subplot(2,2,4);imshow(ROT180);title('旋转180度');
imwrite(RT,'RT.jpg');
imwrite(ROT90,'R0T90.jpg');
imwrite(ROT180,'ROT180.jpg');