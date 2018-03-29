close all,clear all,clc;
load('hall.mat');
[leng,wide,rbg]=size(hall_color);
circlecenter = [leng/2,wide/2];                 %�ҳ�Բ��
max_r=min(circlecenter(1),circlecenter(2));     %ȷ���뾶��Χ
hall_a = hall_color;
for i = 1:leng                                  %����
    for j = 1:wide
        r=sqrt((i-circlecenter(1))^2 + (j-circlecenter(2))^2); %���㵽Բ�ĵľ���
        if(r<=max_r)
            hall_a(i,j,:)=[255,0,0];            %�����뾶��Χ�ڣ�����ɫ��Ϊ��ɫ      
        end
    end
end
imshow(hall_a);
imwrite(hall_a,'hall_a.jpg');