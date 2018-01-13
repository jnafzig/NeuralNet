function [ newnet ] = concat( net,varargin )
    %HORZCAT 
    layer = struct('wij',net.wij,...
                   'bi',net.bi,...
                   'activation',net.activation_fcn);
    nVarargs = length(varargin);
    for k = 1:nVarargs
        layer = [layer,struct('wij',varargin{k}.wij,...
                       'bi',varargin{k}.bi,...
                       'activation',varargin{k}.activation_fcn)];

    end
    
    newnet = NeuralNet(layer);
    
end

