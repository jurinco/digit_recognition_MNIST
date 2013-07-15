%% deskew_image_dataset
% 
% INPUTS:
%   Data: matrix with each row representing a separate instance aka observation
% 
% OUTPUTS:
%   DeskewedData: deskewed image matrix
% 

function DeskewedData = deskew_image_data(Data)
    n = length(Data);
    
    DeskewedData = zeros(size(Data));
    nfeatures = length(Data(1,:));
    
    % Deskew each image and save it to a row in DeskewedImages

    
    p = 0;   % Current percent complete
    fprintf('Progress: 0%%');
    for i = 1:n
        % Display the current progress in percentages
        if (i/n*100) >= (p + 1)
            fprintf(repmat('\b',1,length(num2str(p))+1));   % Clear the last percentage
            p = p + 1;
            fprintf(1,'%d%%',p);
            if p == 100
                fprintf('\n')
            end
        end
        
        instance_vector = Data(i,:);
        Image = vector_to_image(instance_vector);
        DeskewedImage = deskew_grayscale_image(Image);
        
        deskewed_instance = reshape(DeskewedImage', 1, nfeatures);
        DeskewedData(i,:) = deskewed_instance;
    end
end
