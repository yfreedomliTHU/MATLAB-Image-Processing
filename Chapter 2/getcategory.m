function [leng,category] = getcategory( tempDC,DCTAB )
   for i=1:size(DCTAB,2)
        leng=DCTAB(i,1);  %�õ���ǰhuffman����ĳ���
         %����ɨ��huffman����õ�category
        if(DCTAB(i,2:DCTAB(i,1)+1)==tempDC(1:DCTAB(i,1)))    
            category=i-1;
            return;
        end
   end
end

