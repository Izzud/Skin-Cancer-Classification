function region = regionGrowing(im,T,s,r,c)
    region=zeros(r,c); % segmented mask
    F=[]; % frontier list
%     s=[s(2),s(1)];      % [row,col]
    region(s(1),s(2))=1;
    F=[F;s];
    while(~isempty(F)) % if frontier is empty
        n=neighbours(F(1,1),F(1,2),r,c);   % 4 neighbourhood
        for i=1:size(n,1)
            if(abs(im(s(1),s(2))-im(n(i,1),n(i,2)))<T && region(n(i,1),n(i,2))~=1)% less than threshold & not already segmented
%             if(abs(im(F(1,1),F(1,2))-im(n(i,1),n(i,2)))<T && region(n(i,1),n(i,2))~=1)% less than threshold & not already segmented
                region(n(i,1),n(i,2))=1;
                F=[F;n(i,1),n(i,2)];
            end
        end
        F(1,:)=[];
    end
end
