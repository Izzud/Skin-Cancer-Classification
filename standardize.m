function [trainData] = standardize(trainData)
    %{ 
        DESCRIPTION
            standardize the training data and testing data
              [trainData, testData] = standardize(trainData, testData)
        INPUT
          trainData            training data (N*d)
                               N: number of samples
                               d: number of features
        OUTPUT
          trainData            standardized training data
        Created on 1st December 2019 by Kepeng Qiu.
        -------------------------------------------------------------%
    %}
    % standardize trainData
    X_mu = mean(trainData);
    X_std = std(trainData);
    trainData = zscore(trainData);

end