clc
clear all
close all

train_folder = 'D:\0Desktop\Raras 2015\Semester 2\PCD\Project\Program\Data\Train All';
num = 30;
data = zeros(2*num,5,'double');
kelas = zeros(2*num,1);

for im1=1:2
    for im2=1:num
        idx = (im1-1)*num + im2;
        ori=imread(strcat(train_folder, '\',num2str(im1-1),'_',num2str(im2),'.jpg'));
        gray=rgb2gray(ori);
        gray = im2double(gray);
        [m, n] = size(gray);
        [U, V] = dftuv(m, n);
        dist = sqrt(U.^2 + V.^2);
        cutoff = 7;
        imFft = fft2(gray);
        glpf = exp(-(dist.^2) ./ (2 *(cutoff.^2)));
        imageGlpf = glpf .*imFft;
        imResult = ifft2(imageGlpf);

        [T, s] = globalthresh(imResult);
        reg = zeros(size(imResult));
        for i=1:size(s,1)
            reg = reg + regionGrowing(imResult, T, [s(i,1) s(i,2)], m, n);
        end
        reg = (reg>=1);

        area = sum(reg(:)==1)/(size(reg,1)*size(reg,2));
        [red, green, blue] = colorfeatures(ori, reg);
        perim = bwperim(reg, 8);
        perimeter = sum(perim(:)==1)/sum(reg(:)==1);
        data(idx,:) = [area, perimeter, red, green, blue];
        kelas(idx) = im1-1;
    end
end

[row, col] = size(data);

% melakukan normalisasi (agar rentang nilai tiap fitur sama = 0-1)
for i = 1 : col
    data(:,i) = mat2gray(data(:,i));
end;

% menggunakan k-fold cross validation
folds = 5;                                                       % folds = 2, 5, atau 10

% List out the category values in use.
categories = [0; 1];                    

% Get the number of vectors belonging to each category.
vecsPerCat = getVecsPerCat(data, kelas, categories);

% Compute the fold sizes for each category.
foldSizes = computeFoldSizes(vecsPerCat, folds);

% Randomly sort the vectors in X, then organize them by category.
[X_sorted, y_sorted] = randSortAndGroup(data, kelas, categories);

total_akurasi = 0;
total_sensitivity = 0;
total_specificity = 0;
for roundNumber = 1 : folds
    [X_train, y_train, X_val, y_val] = getFoldVectors(X_sorted, y_sorted, categories, vecsPerCat, foldSizes, roundNumber);
    fprintf('\nK = %d\nData training = %d - Data Testing = %d', roundNumber, size(X_train,1), size(X_val,1));
    fprintf('\n');
    
    % melakukan klasifikasi dengan SVM
    model = svmtrain(X_train, y_train);
    result = svmclassify(model, X_val) ;

    % menghitung akurasi
    tp = 0;
    fp = 0;
    fn = 0;
    tn = 0;
    
    for i=1 : size(y_val,1)
        if (y_val(i) == result(i))
            if (y_val(i) == 1)
                tp = tp+1;
            else
                tn = tn+1;
            end
        else
            if (y_val(i) == 1)
                fn = fn+1;
            else
                fp = fp+1;
            end
        end
    end
    
    akurasi = (tp+tn) / (tp+tn+fn+fp);
    sensitivity = tp / (tp+fn);
    specificity = tn / (fp+tn);
    fprintf('Akurasi = %.3f%', akurasi);
    fprintf(' - Sensitivity = %.3f%', sensitivity);
    fprintf(' - Specificity = %.3f%', specificity);
    fprintf('\n');
    
    total_akurasi = total_akurasi + akurasi;
    total_sensitivity = total_sensitivity + sensitivity;
    total_specificity = total_specificity + specificity;
end

total_akurasi = total_akurasi / folds;
total_sensitivity = total_sensitivity / folds;
total_specificity = total_specificity / folds;
fprintf('\nTotal Akurasi = %.3f%', total_akurasi);
fprintf(' - Total Sensitivity = %.3f%', total_sensitivity);
fprintf(' - Total Specificity = %.3f%', total_specificity);
fprintf('\n');