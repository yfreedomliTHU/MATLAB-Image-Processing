close all,clear all,clc;
load('hall.mat');
[leng,wide,rbg]=size(hall_color);
hall_b = hall_color;
for i = 1:8                                 %遍历
    for j = 1:8
        if(mod(i+j,2)==0)
        %若所在方格为黑，则将方格内的所有点置为黑色   
        for m=(i-1)*(leng/8)+1:i*(leng/8)
            for n=(j-1)*(wide/8)+1:j*(wide/8)
                hall_b(m,n,:)=[0,0,0];
            end
        end
        end
    end
end
imshow(hall_b);
imwrite(hall_b,'hall_b.jpg');