function [ red, green, blue ] = colorfeatures( iminp, imbw )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

red = 0;
green = 0;
blue = 0;
iminp = im2double(iminp);
[length, width] = size(imbw);

for i=1:length
    for j=1:width
        if (imbw(i,j) == 1)
            red = red + iminp(i,j,1);
            green = green + iminp(i,j,2);
            blue = blue + iminp(i,j,3);
        end
    end
end

area = sum(imbw(:)==1);

red = red/area;
green = green/area;
blue = blue/area;

end
