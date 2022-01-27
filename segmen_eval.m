function [acc, sen, spe] = segmen_eval(img_gt, img_out)
% Input :
%   - img_gt = citra ground truth
%   - img_out = citra yang telah disegmentasi
%   - length, width = ukuran citra

tp = 0;
fp = 0;
fn = 0;
tn = 0;
% img_out = img_out;
assignin('base', 'imoutput', img_out);
assignin('base', 'imgt', img_gt);
[length, width] = size(img_gt);

for i=1:length
    for j=1:width
        if (img_gt(i,j) == img_out(i,j))
            if (img_gt(i,j) == 1)
                tp = tp+1;
            else
                tn = tn+1;
            end
        else
            if (img_gt(i,j) == 1)
                fn = fn+1;
            else
                fp = fp+1;
            end
        end
    end
end

% tp
% fp
% fn
% tn

% figure, imshow(img_gt==1);
% figure, imshow(img_out==1);
% figure, imshow(img_gt==img_out);

acc = (tp+tn) / (tp+tn+fn+fp);
sen = tp / (tp+fn);
spe = tn / (fp+tn);
        
end
