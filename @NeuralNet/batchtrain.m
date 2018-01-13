function [ net ] = batchtrain( net, input, targetoutput, batchsize, lambda, cost_fcn )
    %BATCHTRAIN Summary of this function goes here
    %   Detailed explanation goes here
    
    if nargin < 4
        cost_fcn = @(output,targetoutput) ...
            1/2*sum(sum((output-targetoutput).^2))/nsamples;
    end

    
end

