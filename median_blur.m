function B = median_blur(I,R,downsampling)

    % Performs median blur (aka filter) for RGB images.

    % Differs from built-in medfilt2 in that the blur radius is individually
    % defined for each pixel. If all radii are equal, then functionality is
    % similar to medfilt2.
    
    % Uses a circular kernel/neighborhood
    
    % Inputs:
        % I: RGB image
        % R: blur radius matrix
        % downsampling: increment between samples (leave as 1 to not downsample)
        
    % Outputs:
        % B: image after median blur
    
    %% Check inputs
    
    if size(I,1)~=size(R,1) || size(I,2)~=size(R,2)
        error('Image size mismatched with blur map')
    end
    
    %% Parse inputs
    
    % Downsample
    I = I(1:downsampling:size(I,1), 1:downsampling:size(I,2), :);
    R = R(1:downsampling:size(R,1), 1:downsampling:size(R,2));

    %% Initialize
    
    B = zeros(size(I)); % result
    
    IR = I(:,:,1);
    IG = I(:,:,2);
    IB = I(:,:,3);
    
    R = round(R);
    
    %% Prepare kernels
    
    rad_val = min(R(:)):max(R(:));
    
    % Kernel format:
        % Column 1: ER
        % Column 2: boolean matrix of kernel
        % Column 3: relative row indices
        % Column 4: relative col indices
    
    Kernel = cell(length(rad_val),4);
    
    for r = 1:size(Kernel,1)
        
        Kernel{r,1} = rad_val(r);
        
        if rad_val(r) == 0
            Kernel(r,2:4) = num2cell(NaN);
            continue
        end
        
        K = zeros(rad_val(r)*2+1);
        [X, Y] = meshgrid(1:size(K,2), 1:size(K,1));
        center = ceil(size(K,1)/2);
        
        for row = 1:size(K,1)
            for col = 1:size(K,2)
                
                if norm([X(row,col),Y(row,col)]-center) <= rad_val(r)
                    K(row,col) = 1;
                end
                
            end
        end
        
        Kernel{r,2} = K;
        
        is_active = find(Kernel{r,2});
        Kernel{r,3} = Y(is_active) - (rad_val(r)+1);
        Kernel{r,4} = X(is_active) - (rad_val(r)+1);
        
    end
    
    %% Perform blur
    
    tic
    msg = 'Performing median blur...';
    h = waitbar(0,msg);
    
    for y = 1:size(I,1)
        
        status = y/size(I,1);
        tr = toc/status*(1-status); % sec, time remaining
        mr = floor(tr/60); % minutes remaining
        sr = floor(tr-mr*60); % sec remaining
        waitbar(status,h,[msg num2str(mr) ':' num2str(sr) ' remaining'])
        
        for x = 1:size(I,2)
            
            r = R(y,x);
            ki = find(r==rad_val); % retrieve kernel
            
%             disp(['Now on pixel ' num2str(y) ', ' num2str(x)])
%             disp(['  Blur value: ' num2str(B(y,x))])
%             disp(['  Corresponding ER: ' num2str(r) ])
%             disp(['  Kernel cell array row: ' num2str(ki)])
            
            if r == 0
                for cc = 1:3
                    B(y,x,cc) = I(y,x,cc);
                end
                continue
            end
            
            row = y + Kernel{ki,3};
            col = x + Kernel{ki,4};
            
            ind = [row, col];
            
            % Find indices that are out of bounds
            row_OOB = find(row<1 | row>size(I,1));
            col_OOB = find(col<1 | col>size(I,2));
            
            ind([row_OOB; col_OOB],:) = [];

            ind = ind(:,1) + (ind(:,2)-1)*size(I,1); % faster version of built-in sub2ind

            B(y,x,1) = median(IR(ind));
            B(y,x,2) = median(IG(ind));
            B(y,x,3) = median(IB(ind));
            
        end
    end
    
    B = uint8(B);
    
    close(h)
    
%     figure(1)
%     clf
%     hold on
%     set(gcf,'color','white')
%     subplot(1,3,1)
%         image(I)
%         axis tight
%         axis equal
%         title('Original')
%     subplot(1,3,2)
%         pcolor(flipud(B))
%         shading flat
%         colormap gray
%         axis tight
%         axis equal
%         title('Blur Radius')
%         colorbar
%     subplot(1,3,3)
%         image(B)
%         axis tight
%         axis equal
%         title('After Median Blur')
    
end



















































