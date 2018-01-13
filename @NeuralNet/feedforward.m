function [a, da_dz ] = feedforward( net, input )
    nsamples = size(input,2);
    nlayers = numel(net.wij);
    
    a = cell(nlayers+1,1);
    da_dz = cell(nlayers+1,1);
    a{1} = input;
    
    for i = 1:nlayers
        [a{i+1},da_dz{i+1}] = net.activation_fcn{i}(...
            net.wij{i}*a{i} + net.bi{i}(:,ones(1,nsamples)));
    end
    
end

