function [T s] = globalthresh(iminp)
  % Convert all N-D arrays into a single column.  Convert to uint8 for
  % fastest histogram computation.
  I = im2uint8(iminp(:));
  num_bins = 256;
  counts = imhist(I,num_bins);
  
  % Variables names are chosen to be similar to the formulas in
  % the Otsu paper.
  p = counts / sum(counts);
  omega = cumsum(p);
  mu = cumsum(p .* (1:num_bins)');
  mu_t = mu(end);
  
  sigma_b_squared = (mu_t * omega - mu).^2 ./ (omega .* (1 - omega));

  % Find the location of the maximum value of sigma_b_squared.
  % The maximum may extend over several bins, so average together the
  % locations.  If maxval is NaN, meaning that sigma_b_squared is all NaN,
  % then return 0.
  maxval = max(sigma_b_squared);
  isfinite_maxval = isfinite(maxval);
  if isfinite_maxval
    idx = mean(find(sigma_b_squared == maxval));
    % Normalize the threshold to the range [0, 1].
    level = (idx - 1) / (num_bins - 1);
  else
    level = 0.0;
  end
  
  assignin('base', 'imprep', iminp);
  
  minval = min(iminp(:));
  avgval = minval + (level-minval)/2;
  T = (level-avgval);
  
  status = 1;
  var = 100000;
  while (status==1)
      flavg = floor(avgval*var)/var;
      ceavg = ceil(avgval*var)/var;
      [s_x s_y] = find(iminp <= ceavg & iminp >= flavg);
      s = [s_x s_y];
      
      if ~isempty(s)
          status = 0;
      end
      var = var/10;
  end
      
      
  
end