function [stDevMasked] = ColourVariance(img_rgb, mask)
    [rows, columns, numberOfColorBands] = size(img_rgb);

    % Convert image from RGB colorspace to lab color space.
    cform = makecform('srgb2lab');
    lab_Image = applycform(im2double(img_rgb),cform);
        
    % Extract out the color bands from the original image
    % into 3 separate 2D arrays, one for each color component.
    LChannel = lab_Image(:, :, 1); 
    aChannel = lab_Image(:, :, 2); 
    bChannel = lab_Image(:, :, 3); 
        
    % Get the average lab color value.
    [LMean, aMean, bMean] = GetMeanLABValues(LChannel, aChannel, bChannel, mask);
        
    % Make uniform images of only that one single LAB color.
    LStandard = LMean * ones(rows, columns);
    aStandard = aMean * ones(rows, columns);
    bStandard = bMean * ones(rows, columns);
        
    % Create the delta images: delta L, delta A, and delta B.
    % (x - mean)
    deltaL = LChannel - LStandard;
    deltaa = aChannel - aStandard;
    deltab = bChannel - bStandard;
        
    % Create the an image that represents the color difference.
    % Delta E is the square root of the sum of the squares of the delta images.
    deltaE = sqrt(deltaL .^ 2 + deltaa .^ 2 + deltab .^ 2);
        
    % Get the standard deviation of the delta E in the mask region
    stDevMasked = std(deltaE(mask));
    return;
end

function [LMean, aMean, bMean] = GetMeanLABValues(LChannel, aChannel, bChannel, mask)
    LVector = LChannel(mask); % 1D vector of only the pixels within the masked area.
    LMean = mean(LVector);
    aVector = aChannel(mask); % 1D vector of only the pixels within the masked area.
    aMean = mean(aVector);
    bVector = bChannel(mask); % 1D vector of only the pixels within the masked area.
    bMean = mean(bVector);
    return
end