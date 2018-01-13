function [ newnet ] = split( net, index )
    %SPLIT 
    layer = struct('wij',net.wij(index),...
                   'bi',net.bi(index),...
                   'activation',net.activation_fcn(index));
    newnet = NeuralNet(layer);
    
end

