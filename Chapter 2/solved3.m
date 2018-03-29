close all,clear all,clc;
load('hall.mat');
hall_part=hall_gray;
hall_dct=dct2(hall_part);
[leng,wide,rpg]=size(hall_dct);
dctr0(:,1:wide-4)=hall_dct(:,1:wide-4);
dctr0(:,wide-3:wide)=0;
dctl0(:,5:wide)=hall_dct(:,5:wide);
dct10(:,1:4)=0;
rightzero=idct2(dctr0)/256; %由于idct变换的结果为double型，需要归一化
leftzero=idct2(dctl0)/256;
subplot(1,3,1);imshow(hall_gray);title('原图');
subplot(1,3,2);imshow(rightzero);title('右边4列置0');
subplot(1,3,3);imshow(leftzero);title('左边4列置0');
imwrite(hall_gray,'hall_gray.jpg');
imwrite(rightzero,'rightzero.jpg');
imwrite(leftzero,'leftzero.jpg');