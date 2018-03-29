close all,clear all,clc;
L=[3,4,5];imgnum=33;
v1=zeros(1,2^(3*L(1)));
v2=zeros(1,2^(3*L(2)));
v3=zeros(1,2^(3*L(3)));
for count=1:imgnum
    img=imread([num2str(count),'.bmp']);
    v1=v1+getfeature(img,L(1))/imgnum;
    v2=v2+getfeature(img,L(2))/imgnum;
    v3=v3+getfeature(img,L(3))/imgnum;
 end
subplot(3,1,1);plot(v1);title('L=3');
subplot(3,1,2);plot(v2);title('L=4');
subplot(3,1,3);plot(v3);title('L=5');
save('feature.mat','v1','v2','v3');
