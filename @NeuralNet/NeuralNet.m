classdef NeuralNet

    properties
        wij;
        bi;
        activation_fcn;
        cost_fcn;
        l1;
        l2;
    end
    properties (Dependent)
       numlayers;
       numinputs;
       numoutputs;
    end
    
    methods
        function net = NeuralNet(layer,varargin)
            if (nargin~=0)
                
                p = inputParser;
                addParamValue(p,'cost','quadratic');
                addParamValue(p,'l1',0);
                addParamValue(p,'l2',0);
                
                parse(p,varargin{:});
          
                net.cost_fcn = net.costfunctions(p.Results.cost);
           
                net.l1 = p.Results.l1;
                net.l2 = p.Results.l2;
                
                net.wij = {layer.wij};
                net.bi = {layer.bi};
                net.activation_fcn = cell(size(layer));

                for i = 1:numel(layer)
                    if isfield(layer(i),'activation') && ...
                            ~isempty(layer(i).activation)
                        net.activation_fcn{i} = ...
                            net.activationfunctions(layer(i).activation);
                    else
                        net.activation_fcn{i} = ...
                            net.activationfunctions('sigmoid');
                    end
                end
                
                checkbiases(net);
                checklayers(net);
                
            end
            
        end
        
        function checklayers(obj)
            for i = 1:obj.numlayers-1
                assert(size(obj.wij{i+1},2)==size(obj.wij{i},1),...
                    'Layer output size must match next layer input');
            end
        end
        
        function checkbiases(obj)
            for i = 1:obj.numlayers
                    assert(size(obj.bi{i},2)==1,...
                        'Bias should be column vector');
                    assert(size(obj.bi{i},1)==size(obj.wij{i},1),...
                        'Size of bias vector must match weights');
            end
        end
        
        function numlayers = get.numlayers(obj)
            numlayers = numel(obj.wij);
        end

        function numinputs = get.numinputs(obj)
            numinputs = size(obj.wij{1},2);
        end

        function numoutputs = get.numoutputs(obj)
            numoutputs = size(obj.wij{end},1);
        end
    end
    
end

