function [Seq, N] = loadFiles(listOfImages, directory, increment)
    list = cellstr(listOfImages);
    N = length(list);
    %if there is a list of images, load them into cell array
    if N > 1

        for i = 1:N
            f = fullfile('.\hotel\',char(list(i)));
            Seq{i} = imread(f);
        end
    
    
    else %if there is no list of images, load the test folder into cell array
       
       srcFiles = dir(directory);  % the folder in which ur images exists
   
       Seq = cell(1,floor(length(srcFiles)/increment));
       
       k = 1;
       for i = 1 : length(srcFiles)
            filename = strcat('.\testImages\',srcFiles(i).name);
            if mod(i,increment)==0 %skip pictures if necessary...if no skipping needed then set to mod(i,i)
                Seq{k} = imread(filename);
                N = N+1; %increment counter of total # of pics
                k = k+1; 
            end
        end

    end

    
end