% function focal_point_blur_3D

    % Takes as input an image, its corresponding depth map,
    % depth-to-planar spatial ratio, and blur radius range
    
    % Outputs an image blurred to input specifications

    %%

    clear
    clc
    
    %% Inputs
    
    filename = 'pigeons';
    
    format_in  = 'png';
    format_out = 'png';
    downsampling = 1; % skip every indices
    
    DP_spatial_ratio = 1; % depth-to-planar spatial ratio; low=shallow, 1=equal, high=deep
    radius = [0 20]; % px
    
    %% Load images
    
    filename_image_in = [filename '_ER_L'];
    filename_DM_in    = [filename '_ER_dps_L'];
    
    I = imread([filename_image_in '.' format_in]);
    Z = imread([filename_DM_in    '.' format_in]);
    
    if size(I,1)~=size(Z,1) || size(I,2)~=size(Z,2)
        error('Size of image and depth map are mismatched')
    end
    
    I = I(1:downsampling:size(I,1), 1:downsampling:size(I,2),:);
    Z = Z(1:downsampling:size(Z,1), 1:downsampling:size(Z,2));
    
    %% Show inputs
    
    ax_dim = [0.18 0.80]; % axis width
    spac = 0.20;
    spq = 4; % subplot quantity
    
    figure(1)
        clf
        set(gcf,'color','white')
        drawnow
    
    subplot(1,4,2)
        pcolor(flipud(Z))
        shading flat
        colormap gray
        colorbar
        axis equal
        axis tight
        title('Depth Map')
        drawnow
    
    subplot(1,4,1)
        image(I)
        hold on
        title('\rmClick the desired focal point...')
        axis equal
        axis tight
        FP = ginput(1);
        title([]) % clear title
        FP = [FP(1)/size(I,2), 1-FP(2)/size(I,1)]; % normalized [x, y]
        FP_norm = FP; % save the raw input for later
        FP = [round(size(I,1)-FP(2)*size(I,1)), round(FP(1)*size(I,2))]; % convert FP from normalized coordinates to indices
        scatter(FP(2),FP(1),100,'s','MarkerEdgeColor','k','MarkerFaceColor','w')
        scatter(FP(2),FP(1),200,'kx')%,'MarkerEdgeColor','k','MarkerFaceColor','w')
        title('Original')
        drawnow

    
    %% Parse inputs
    
    [X, Y] = meshgrid(1:size(I,2), 1:size(I,1));
    Z = double(Z(:,:,1));
    
    geo_mean = sqrt(size(I,1)*size(I,2)); % geometric mean of image dimensions

    Z = (Z ./ max(Z(:))) .* (geo_mean*DP_spatial_ratio); % qualitatively scale the depth
    FP(3) = Z(FP(1),FP(2));
    
    % FP format: row index, column index, depth value
    
    %% Determine radius for each pixel relative to Focal Point (FP)
    
    R = zeros(size(Z)); % radius matrix
    
    for y = 1:size(R,1)
        
        % Calculate pixel weights
        for x = 1:size(R,2)
            
            z = Z(y,x); % get this pixel's depth
            R(y,x) = norm([ FP(2)-x, FP(1)-y, FP(3)-z ]);
            
        end

    end
    
    R = (R-min(R(:)))/(max(R(:))-min(R(:))); % scale 0-1
    R = R .* (max(radius)-min(radius)) + min(radius); % map linearly to radius range
    R = round(R);
    
    subplot(1,4,3)
        pcolor(flipud(R))
        colormap gray
        shading flat
        axis equal
        axis tight
        colorbar
        title('Blur Radius Map')
        drawnow
    
    %% Perform blur
    
    B = median_blur(I,R,1);
    
    %% Show results
    
    B = uint8(B);
    
    subplot(1,4,4)
        image(B)
        axis equal
        axis tight
        title('After Blur')
        drawnow

    % Equalize size, adjust spacing
    for sp = 1:spq
        subplot(1,spq,sp)
        axis tight
        axis equal
        pos = get(gca,'position');
        set(gca,'position',[pos(1)+(pos(1)-0.5)*spac pos(2) ax_dim])
        drawnow
    end
    
    %% Output results
    
    suffix = ['_downsampling_' num2str(downsampling) '_FP_' num2str(round(FP_norm(1)*100)) '_x_' num2str(round(FP_norm(2)*100)) '_DW_ratio_' num2str(DP_spatial_ratio) '_rad_min_' num2str(min(R(:))) '_rad_max_' num2str(max(R(:))) ];
    
    % Create an image of the radius map
    RI = zeros(size(R,1),size(R,2),3);
    R_min = min(R(:));
    R_max = max(R(:));
    for cc = 1:3
        RI(:,:,cc) = (R-R_min)./(R_max-R_min) .* 255;
    end
    
    % Create a comparison image
    Spacer = zeros(size(I,1),10,3);
    for cc = 1:3
        Spacer(:,:,cc) = zeros(size(Spacer,1),size(Spacer,2))+255;
    end
    C = [I, Spacer, B];
    
    current_folder = pwd;
    cd([current_folder '\results'])
    
    imwrite(double(B) /255,[filename_image_in '_output' suffix '.' format_out])
    imwrite(double(I) /255,[filename_image_in '_input'  suffix '.' format_out])
    imwrite(double(C) /255,[filename_image_in '_compr'  suffix '.' format_out])
    imwrite(double(RI)/255,[filename_image_in '_radmap'  suffix '.' format_out])
    
    cd(current_folder)
    
% end


















































