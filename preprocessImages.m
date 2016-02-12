function [images_proc] = preprocessImages(images, outputSize)

    N = length(images);
    images_proc = images; % cell(size(images));
    
    %resize images
%     for i = 1:N
%         images_proc{i} = imresize(images_proc{i},outputSize);
%     end
%     
    
    %Check if images need to be converted to gray scale
    [m,n,k] = size(images{1})
    if k == 3
        for i = 1:N
            
            images_proc{i} = rgb2gray(images_proc{i});
        end
    end
    
    for i=1:length(images_proc)
        images_proc{i} = (images_proc{i});
    end
end