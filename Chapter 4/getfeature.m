function feature = getfeature(img,L)
   [len,wide,high] = size(img);
   feature = zeros(1,2^(3*L));%初始化
   range = 2^(8 - L); %计算每种颜色覆盖的数据范围
   image=floor(double(img)/range);
   NUM=image(:,:,1)*2^(2*L)+image(:,:,2)*2^L+image(:,:,3)+1;
   for i=1:len
       for j=1:wide
           feature(NUM(i,j))=feature(NUM(i,j))+1; % 得到图像中各颜色出现的次数
       end
   end
   feature = feature/(len*wide); % 计算各颜色出现的频率
end

