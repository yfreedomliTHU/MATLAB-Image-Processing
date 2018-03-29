function feature = getfeature(img,L)
   [len,wide,high] = size(img);
   feature = zeros(1,2^(3*L));%��ʼ��
   range = 2^(8 - L); %����ÿ����ɫ���ǵ����ݷ�Χ
   image=floor(double(img)/range);
   NUM=image(:,:,1)*2^(2*L)+image(:,:,2)*2^L+image(:,:,3)+1;
   for i=1:len
       for j=1:wide
           feature(NUM(i,j))=feature(NUM(i,j))+1; % �õ�ͼ���и���ɫ���ֵĴ���
       end
   end
   feature = feature/(len*wide); % �������ɫ���ֵ�Ƶ��
end

