close all,clear all,clc;
load('hall.mat');
load('jpegcodes.mat');
[len,wid]=size(hall_gray);
input=len*wid*8;
output=length(DC1)+length(AC1);
ratio=input/output;