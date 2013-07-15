%% display_elapsed_time
% Display the time elapsed since tic was last called.
% 
function display_elapsed_time
    t = datestr(datenum(0,0,0,0,0,toc),'HH:MM:SS');
    fprintf('Elapsed time: %s\n\n', t);
end
