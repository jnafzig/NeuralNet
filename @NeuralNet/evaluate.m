function [ output ] = evaluate( net, input, layers )
    if nargin <3 
        layers = 1:net.numlayers;
    end
    output = input;
    nsamples = size(input,2);
    for i = layers
        output = net.activation_fcn{i}(net.wij{i}*output+net.bi{i}(:,ones(1,nsamples)));
    end
end

