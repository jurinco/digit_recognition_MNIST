% SPHOG: Spatial Pyramid Histograms of Oriented Gradients
function sphog_feats = compute_sphog_features(orig_feats)
    global config;
    blocks = config.BLOCKS;
    W = config.PATCH_W;
    H = config.PATCH_H;
    
    [gw,gh,level_weights] = get_sampling_grid(W,H,blocks,config.DO_OVERLAP);
    
    param.nori = config.NORI; 
    param.ww = W;
    param.hh = H;
    
    dim = 0;
    for i = 1:length(gw)
        dim = dim + (size(gw{i},1)-1) * (size(gw{i},2)-1) * param.nori;
    end
    fprintf('features are %i dimensional.\n',dim);
    
    sphog_feats = zeros(size(orig_feats,1),dim);
    
    p = 0;   % Current percent complete
    fprintf('Progress: 0%%');
    n = size(orig_feats,1);
    for i = 1:n
        sphog_feats(i,:) = make_sphog_features(orig_feats(i,:),param,gw,gh,level_weights);
        
        % Display the current progress in percentages
        if (i/n*100) >= (p + 1)
            fprintf(repmat('\b',1,length(num2str(p))+1));   % Clear the last percentage
            p = p + 1;   % Increment the completed percentage
            fprintf(1,'%d%%',p);
            if p == 100
                fprintf('\n\n')
            end
        end
    end
end

function f = make_sphog_features(x,param,gw,gh,level_weights)
    I  = reshape(x,param.ww,param.hh);
    f = compute_features(I,param,gw,gh,1,level_weights);
end
