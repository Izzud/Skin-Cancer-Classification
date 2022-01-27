function out=neighbours(s1,s2,r,c)
    out=[];
    if(s2>1),  out=[out;s1,s2-1];   end
    if(s1>1),  out=[out;s1-1,s2];   end
    if(s1<r),  out=[out;s1+1,s2];   end
    if(s2<c),  out=[out;s1,s2+1];   end
end