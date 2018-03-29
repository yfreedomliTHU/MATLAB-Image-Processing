close all,clear all,clc;
load('hall.mat');
[leng,wide,rbg]=size(hall_color);
circlecenter = [leng/2,wide/2];                 %找出圆心
max_r=min(circlecenter(1),circlecenter(2));     %确定半径范围
hall_a = hall_color;
for i = 1:leng                                  %遍历
    for j = 1:wide
        r=sqrt((i-circlecenter(1))^2 + (j-circlecenter(2))^2); %计算到圆心的距离
        if(r<=max_r)
            hall_a(i,j,:)=[255,0,0];            %在最大半径范围内，将颜色变为红色      
        end
    end
end
imshow(hall_a);
imwrite(hall_a,'hall_a.jpg');