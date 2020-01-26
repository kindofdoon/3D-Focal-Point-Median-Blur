% function ER9b

    % Wrapper for Ugo Capeto's ER9b
    % http://3dstereophoto.blogspot.com/2016/02/epipolar-rectification-9b-er9b.html
    
    % Function sequence:
        % 1. prepare_studio_image.m
        % 2. ER9b
        % 3. DMAG5
        % 4. focal_point_blur_3D.m
    
    %%
    
    clear
    clc
    
    %% Inputs
    
    filename_prefix = 'yacht';
    
    format_in  = 'png';
    format_out = 'png';
    
    %% Load data
    
    filename_L = [filename_prefix '_L.' format_in];
    filename_R = [filename_prefix '_R.' format_in];
    
    filename_ER_L = [filename_prefix '_ER_L.' format_in];
    filename_ER_R = [filename_prefix '_ER_R.' format_in];
    
    IL = imread(filename_L);
    IR = imread(filename_R);
    
    %% Downsample and convert
    
    IL_orig = IL;
    IR_orig = IR;
    
    imwrite(IL,filename_L)
    imwrite(IR,filename_R)
    
    %%
    
    disp('Rectifying...')
    
    % Prepare the input file
    fileID = fopen('er9b_input.txt','w');
    newline = '\n';
    fprintf(fileID,[filename_L    newline]);
    fprintf(fileID,[filename_R    newline]);
    fprintf(fileID,[filename_ER_L newline]);
    fprintf(fileID,[filename_ER_R newline]);
    fprintf(fileID,['10000' newline]);
    fprintf(fileID,['1000.0' newline]);
    fclose(fileID);
    
    system('er9b.bat &');
    while exist(filename_ER_L)==0 || exist(filename_ER_R)==0 || exist('duh1.tif')==0 || exist('duh1.png')==0 || exist('duh2.tif')==0 || exist('duh2.png')==0
        % Wait
    end
    
    %% Compare results
    
    return
    
    figure(2)
    set(gcf,'color','white')
    
    pd = 0.25; % pause duration
    
    while 1==1
    
        subplot(1,2,1)
            image(IL_orig)
            axis tight
            axis equal
        subplot(1,2,2)
            image(IL_crop)
            axis tight
            axis equal

        figure(2)
        drawnow
        pause(pd)
        
        subplot(1,2,1)
            image(IR_orig)
            axis tight
            axis equal
        subplot(1,2,2)
            image(IR_crop)
            axis tight
            axis equal
            
        figure(2)
        drawnow
        pause(pd)
        
    end
    
    
% end



















































