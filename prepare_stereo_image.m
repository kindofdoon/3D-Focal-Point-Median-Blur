% function prepare_stereo_image

    % Takes as input a single image with a left and right sub-image
    
    % Splits input image into left/right sub-images, crops and downsamples
    % them as specified, then saves the sub-images as standalone files for
    % later use
    
    % Function sequence:
        % 1. prepare_studio_image.m
        % 2. ER9b
        % 3. DMAG5
        % 4. focal_point_blur_3D.m
        
    %%

    clear
    clc
    
    %% Inputs
    
    filename   = 'yacht';
    format_in  = 'jpg';
    format_out = 'png';
    
    crop = [0 0 0 0]; % px, [top bottom left right]
    
    max_dim = 1000; % px, downsample so that image width and height do not exceed this value
    
    %% Load, split, and crop
    
    I = imread([filename '.' format_in]);
    
    if size(I,2)/2 ~= round(size(I,2)/2) % if not evenly divisible
        I(:,end,:) = []; % strip off a single column
    end
    
    ind_split = round(size(I,2)/2);
    
    IL = I(:,1:ind_split,:);
    IR = I(:,ind_split+1:end,:);
    
    col = crop(1)+1:size(IL,1)-crop(2);
    row = crop(3)+1:size(IL,2)-crop(4);
    
    IL = IL(col,row,:);
    IR = IR(col,row,:);
    
    %% Downsample
    
    downsampling = 1;
    while length(1:downsampling:size(IL,1))>max_dim || length(1:downsampling:size(IL,2))>max_dim
        downsampling = downsampling+1;
    end
    
    IL = IL(1:downsampling:size(IL,1),1:downsampling:size(IL,2),:);
    IR = IR(1:downsampling:size(IR,1),1:downsampling:size(IR,2),:);
    
    %% Export results
    
    imwrite(IL,[filename '_L.' format_out])
    imwrite(IR,[filename '_R.' format_out])
    
    %% Show results
    
    figure(1)
    clf
    hold on
    set(gcf,'color','white')
    
    subplot(1,2,1)
        image(IL)
        axis tight
        axis equal
    subplot(1,2,2)
        image(IR)
        axis tight
        axis equal

% end



















































