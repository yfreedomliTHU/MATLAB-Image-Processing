function [Run,Size,Huff_len ] = getsizerun(tempAC,ACTAB)
   add_zero=zeros(1,12);
   tempAC=[tempAC,add_zero];
   for k=1:160
            Huff_len=ACTAB(k,3);  %ȡ����Ӧ��huffman����ĳ���
            if(ACTAB(k,4:3+Huff_len)==tempAC(1:Huff_len))
                Run=ACTAB(k,1);
                Size=ACTAB(k,2);
                break;
            end
   end

end

