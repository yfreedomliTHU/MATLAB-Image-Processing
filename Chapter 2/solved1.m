close all,clear all,clc;
load('hall.mat');
hall_part=hall_gray(11:20,11:20);
hall_1=hall_part-128;
temp_dct = dct2(hall_part);
temp_dct(1) = temp_dct(1) -128/(1/10);
hall_2=idct2(temp_dct);