% function compare_images

    % Generates GIF to compare two images of the same size
    
    %%
    
    clear
    clc
    
    %% Inputs
    
    filename_I1 = 'good_match1.tiff';
    filename_I2 = 'good_match2.tiff';
    
    frame_duration = 0.5; % sec
    
    %% Load inputs
    
    I1 = imread(filename_I1);
    I2 = imread(filename_I2);
    
    if size(I1,1)~=size(I2,1) || size(I1,2)~=size(I2,2) || size(I1,3)~=size(I2,3)
        error('Images sizes are mismatched')
    end
    
    % Remove transparency and other unnecessary channels
    for cc = size(I1,3):-1:1
        if cc > 3
            I1(:,:,cc) = [];
            I2(:,:,cc) = [];
        end
    end
    
    %% Prepare figure
    
    current_folder = pwd;
    cd([current_folder '\results'])
    
    filename_out = [regexprep(filename_I1,'\..+','') '_' regexprep(filename_I2,'\..+','') '_compr.GIF'];
    
    figure(1)
        clf
        set(gcf,'color','white')
        axis off
        set(gca,'position',[0 0 1 1])
        set(gcf,'position',[100 100 size(I1,2) size(I1,1)])

        
    %% Create animation

    whos I1
    
        image(I1)
            axis tight
            axis equal
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            drawnow
            frame = getframe(gcf); 
            im = frame2im(frame); 
            [imind,cm] = rgb2ind(im,256);
            imwrite(imind,cm,filename_out,'gif', 'Loopcount',inf,'DelayTime',frame_duration); 
        image(I2)
            axis tight
            axis equal
            set(gca,'xtick',[])
            set(gca,'ytick',[])
            drawnow
            frame = getframe(gcf); 
            im = frame2im(frame); 
            [imind,cm] = rgb2ind(im,256);
            imwrite(imind,cm,filename_out,'gif','WriteMode','append','DelayTime',frame_duration);
            
    %% Finalize

    cd(current_folder)

% end



















































