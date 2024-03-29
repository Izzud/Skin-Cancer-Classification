function [U, V] = dftuv(M, N)
% DFTUV Computes meshgrid frequency matrices
% [U, V] = DFTUV(M, N) computes meshgrid frequancy matrices U and
% V.U and V are usefull for computing frequency-domain filter
% function that can be used with DFTFILT. U and V are both M-by-N

% Set up range of variables.
u = 0:(M-1);
v = 0:(N-1);

% Compute the indeces for used in meshgrid
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;

% Compute the meshgrid arrays
[V, U] = meshgrid(v, u);