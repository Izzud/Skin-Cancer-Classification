function [MSE] = ImageSymmetry(img_masked, mask)
    [rows, columns, numberOfColorBands] = size(img_masked);
    
    % Extract the largest blob only.
    binaryImage = bwareafilt(mask, 1);

    % Find centroids
    props = regionprops(binaryImage, 'Centroid', 'Orientation');
    xCentroid = props.Centroid(1);
    yCentroid = props.Centroid(2);

    % Find the half way point of the image.
    middlex = columns/2;
    middley = rows/2;

    % Center the object to center
    deltax = middlex - xCentroid;
    deltay = middley - yCentroid;
    binaryImage = imtranslate(img_masked,  [deltax, deltay]);

    % Orient the object
    angle = -props.Orientation;
    rotatedImage = imrotate(binaryImage, angle, 'crop');

    MSE = immse(rotatedImage, fliplr(rotatedImage));

    return;
end