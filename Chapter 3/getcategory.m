function [leng,category] = getcategory( tempDC,DCTAB )
   for i=1:size(DCTAB,2)
        leng=DCTAB(i,1);  %得到当前huffman编码的长度
         %根据扫描huffman编码得到category
        if(DCTAB(i,2:DCTAB(i,1)+1)==tempDC(1:DCTAB(i,1)))    
            category=i-1;
            return;
        end
   end
end

