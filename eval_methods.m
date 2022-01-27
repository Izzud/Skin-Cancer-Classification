clc
clear all
close all

name = '1_6';
path = 'D:\0Desktop\Raras 2015\Semester 2\PCD\Project\Program\Data\Segmen - Baru\';
saveto = 'D:\0Desktop\Raras 2015\Semester 2\PCD\Project\Program\Output\';
ori = imread([path name '.jpg']);
gt = imread([path name '_bw.jpg']);
gt = rgb2gray(gt);
gt = gt/255;

gray = rgb2gray(ori);
gray = im2double(gray);
[m, n] = size(gray);
[U, V] = dftuv(m, n);
dist = sqrt(U.^2 + V.^2);
cutoff = 7;
imFft = fft2(gray);
glpf = exp(-(dist.^2) ./ (2 *(cutoff.^2)));
imageGlpf = glpf .*imFft;
imResult = ifft2(imageGlpf);

% Proposed Method
[T, s] = globalthresh(imResult);
reg = zeros(size(imResult));
for i=1:size(s,1)
	reg = reg + regionGrowing(imResult, T, [s(i,1) s(i,2)], m, n);
end
reg = (reg>=1);

figure, imshow(gray); hold on;
plot (s(:,2), s(:,1), 'r*'); hold off;

imwrite(reg, [saveto name '_ar.jpg']);
[acc_ar, sen_ar, spe_ar] = segmen_eval(gt,reg);
fprintf('Automatic Region Growing\nAkurasi = %.3f%', acc_ar);
fprintf(' - Sensitivity = %.3f%', sen_ar);
fprintf(' - Specificity = %.3f%', spe_ar);
fprintf('\n');

% Region Growing
Tr = 0.18;
sr = [s(1,1) s(1,2)];
reg_grow = regionGrowing(imResult, Tr, [sr(1,1) sr(1,2)], m, n);
figure, imshow(gray); hold on;
plot (s(:,2), s(:,1), 'r*'); hold off;

imwrite(reg, [saveto name '_ar.jpg']);
[acc_ar, sen_ar, spe_ar] = segmen_eval(gt,reg);
fprintf('Automatic Region Growing\nAkurasi = %.3f%', acc_ar);
fprintf(' - Sensitivity = %.3f%', sen_ar);
fprintf(' - Specificity = %.3f%', spe_ar);
fprintf('\n');

figure, imshow(gray); hold on;
plot (sr(:,2), sr(:,1), 'r*'); hold off;

imwrite(reg_grow, [saveto name '_rg2.jpg']);
[acc_rg, sen_rg, spe_rg] = segmen_eval(gt,reg_grow);
fprintf('Region Growing\nAkurasi = %.3f%', acc_rg);
fprintf(' - Sensitivity = %.3f%', sen_rg);
fprintf(' - Specificity = %.3f%', spe_rg);
fprintf('\n');

% Otsu Thresholding
level = graythresh(imResult);
imbw = 1-im2bw(imResult, level);

% figure, imshow(imbw);
imwrite(imbw, [saveto name '_ot.jpg']);
[acc_ot, sen_ot, spe_ot] = segmen_eval(gt,imbw);
fprintf('Otsu Thresholding\nAkurasi = %.3f%', acc_ot);
fprintf(' - Sensitivity = %.3f%', sen_ot);
fprintf(' - Specificity = %.3f%', spe_ot);
fprintf('\n');


