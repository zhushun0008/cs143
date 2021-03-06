function pb = detect_sketch_tokens(img, forest, feature_params)

% 'img' is a test image.
% 'forest' is the structure returned by 'forestTrain'.

% 'pb' is the probability of boundary for every pixel.

%feature_params.CR = radius of the channel-derived patches. E.g. radius of
%7 would imply 15x15 features. The other entries of feature_params are for
%calling 'compute_daisy', which you probably don't need here (unless you've
%decided to use the DAISY descriptor as an image feature, which might be a
%decent idea).

[height, width, cc] = size(img);
% pb  = zeros(height, width);
num_sketch_tokens = max(forest(1).hs) - 1; %-1 for background class

% img = single(img);
% Pad the current image and then call 'channels = get_channels(cur_img)'
img = imPad(img, (feature_params.CR), 'replicate');
% imshow(img);
% beep;
% waitforbuttonpress;
channels = get_channels(img);
% Stack all of the image features into one matrix. This will be redundant
% (a single pixel will appear in many patches) but it will be faster than
% calling 'forestApply' for every single pixel.
imsize = size(img);
feat_size = 14 * 15 * 15;
ysize=imsize(1);
xsize=imsize(2);
all_token_grid = zeros([ysize, xsize, feat_size], 'single');
radius = feature_params.CR;
for x=1:xsize
    for y=1:ysize
        if x<radius+1 || x>xsize-radius || y<radius+1 || y>ysize-radius
            continue;
        end
        token = channels(y-radius:y+radius, x-radius:x+radius, :);
        all_token_grid(y, x, :) = reshape(token, 1, []);
    end
end
stacked = reshape(all_token_grid, [ysize*xsize feat_size]);
% size(stacked)
% Call 'forestApply', use the resulting probabilities to build the output
% 'pb'
[categories, probabilities] = forestApply(stacked, forest);

% rev_confidences = probabilities(:,2)-0.5;
shapedConf = reshape(probabilities, [ysize, xsize, 2]);
shapedConf = imPad(shapedConf, -feature_params.CR, 'replicate');
mygauss = fspecial('Gaussian', 3);
confs = 1-shapedConf(:,:,1);
pb = imfilter(confs, mygauss, 'symmetric');
% beep;
% imshow(shapedConf(:, :, 1));
% waitforbuttonpress;
% imshow(shapedConf(:, :, 2));
% waitforbuttonpress;
% imshow(shapedConf);
% beep;
% waitforbuttonpress;
% imshow(img);
% beep;
% waitforbuttonpress;
% my_ones = ones(size(shapedConf));
% imshow(pb);
% waitforbuttonpress;
% imshow(pb);
% waitforbuttonpress;


