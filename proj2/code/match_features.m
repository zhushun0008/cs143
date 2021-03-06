% Local Feature Stencil Code
% CS 143 Computater Vision, Brown U.
% Written by James Hays

% 'features1' and 'features2' are the n x feature dimensionality features
%   from the two images.
% If you want to include geometric verification in this stage, you can add
% the x and y locations of the features as additional inputs.
%
% 'matches' is a k x 2 matrix, where k is the number of matches. The first
%   column is an index in features 1, the second column is an index
%   in features2. 
% 'Confidences' is a k x 1 matrix with a real valued confidence for every
%   match.
% 'matches' and 'confidences' can empty, e.g. 0x2 and 0x1.
function [matches, confidences] = match_features(features1, features2)

% This function does not need to be symmetric (e.g. it can produce
% different numbers of matches depending on the order of the arguments).

% To start with, simply implement the "ratio test", equation 4.18 in
% section 4.1.3 of Szeliski. For extra credit you can implement various
% forms of spatial verification of matches.

% Placeholder that you can delete. Random matches and confidences
num_features1 = size(features1, 1);
num_features2 = size(features2, 1);
f2s = [ 1:num_features2 ]';
% matches = zeros(num_features1, 2);
% matches(:,1) = randperm(num_features1);
% matches(:,2) = randperm(num_features2);

[ nearest dists ] = knnsearch(features1, features2, 'K', 2);
f1s=nearest(:, 1);
confidences = 3-( dists(:, 1) ./ dists(:, 2));
matches = [f1s f2s];
matches_w_confidences = [matches confidences];
sorted = sortrows(matches_w_confidences, -3);
top = 100;
matches = sorted(1:top, 1:2);
confidences = sorted(1:top, 3)


% Sort the matches so that the most confident onces are at the top of the
% list. You should probably not delete this, so that the evaluation
% functions can be run on the top matches easily.
% [confidences, ind] = sort(confidences(1:20), 'descend');
% matches = matches(ind,:);