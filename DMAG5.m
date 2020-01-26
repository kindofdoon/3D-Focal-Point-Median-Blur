% function DMAG5

    % Wrapper for Ugo Capeto's DMAG5
    % http://3dstereophoto.blogspot.com/2014/05/depth-map-automatic-generator-5-dmag5.html

    % Function sequence:
        % 1. prepare_studio_image.m
        % 2. ER9b
        % 3. DMAG5
        % 4. focal_point_blur_3D.m

    %%
    
    clear
    clc
    
    %% Inputs
    
    filename = 'yacht';
    format_in = 'png';

    dsp                        = [-18 0]; % Minimum and maximum disparity
    window_radius              = 128;      % Window radius
    alpha                      = 0.9;     % Alpha
    truncation_color           = 10;      % Truncation value (color cost)
    truncation_gradient        = 10;      % Truncation value (gradient cost)
    epsilon                    = 4;       % Epsilon
    dsp_tol                    = 5;       % Disparity tolerance
    radius_occlusion_smoothing = 9;       % Radius (occlusion smoothing)
    sigma_space                = 9;       % Sigma space (occlusion smoothing)
    sigma_color                = 25.5;    % Sigma color (occlusion smoothing)
    downsampling               = 1;       % Downsampling factor
    
    %% Default values - read only
    
%     dsp                        = [-12 123]; % Minimum and maximum disparity
%     window_radius              = 16;      % Window radius
%     alpha                      = 0.9;     % Alpha
%     truncation_color           = 30;      % Truncation value (color cost)
%     truncation_gradient        = 10;      % Truncation value (gradient cost)
%     epsilon                    = 4;       % Epsilon
%     dsp_tol                    = 0;       % Disparity tolerance
%     radius_occlusion_smoothing = 9;       % Radius (occlusion smoothing)
%     sigma_space                = 9;       % Sigma space (occlusion smoothing)
%     sigma_color                = 25.5;    % Sigma color (occlusion smoothing)
%     downsampling               = 3;       % Downsampling factor
    
    %%
    
    filename = [filename '_ER'];
    
    IL = imread([filename '_L.' format_in]);
    IR = imread([filename '_R.' format_in]);
    
    filename_dps_L = [filename '_dps_L.png'];
    filename_dps_R = [filename '_dps_R.png'];
    filename_occ_L = [filename '_occ_L.png'];
    filename_occ_R = [filename '_occ_R.png'];
    
    fileID = fopen('dmag5_input.txt','w');
    newline = '\n';
    fprintf(fileID,[filename '_L.' format_in            newline]); % Name of image 1 (left image):                                        000_l.tif
    fprintf(fileID,[filename '_R.' format_in            newline]); % Name of image 2 (right image):                                       000_r.tif
    fprintf(fileID,[num2str(min(dsp))                   newline]);
    fprintf(fileID,[num2str(max(dsp))                   newline]);
    fprintf(fileID,[filename_dps_L                      newline]);  % Name of depth/disparity map for image 1 (left depth/disparity map):  dps_l.tif
    fprintf(fileID,[filename_dps_R                      newline]);  % Name of depth/disparity map for image 2 (right depth/disparity map): dps_r.tif
    fprintf(fileID,[filename_occ_L                      newline]);  % Name of occlusion map for image 1 (left occlusion map):              occ_l.tif
    fprintf(fileID,[filename_occ_R                      newline]);  % Name of occlusion map for image 2 (right occlusion map):             occ_r.tif
    fprintf(fileID,[num2str(window_radius)              newline]);
    fprintf(fileID,[num2str(alpha)                      newline]);
    fprintf(fileID,[num2str(truncation_color)           newline]);
    fprintf(fileID,[num2str(truncation_gradient)        newline]);
    fprintf(fileID,[num2str(epsilon)                    newline]);
    fprintf(fileID,[num2str(dsp_tol)                    newline]);
    fprintf(fileID,[num2str(radius_occlusion_smoothing) newline]);
    fprintf(fileID,[num2str(sigma_space)                newline]);
    fprintf(fileID,[num2str(sigma_color)                newline]);
    fprintf(fileID,[num2str(downsampling)               newline]);
    fclose(fileID);
    
    %%
    
    system('dmag5.bat &');
    while exist(filename_dps_L)==0 || exist(filename_dps_R)==0 || exist(filename_occ_L)==0 || exist(filename_occ_R)==0
        % Wait
    end

% end


















































