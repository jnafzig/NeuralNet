function [ cost, dcost_dwij, dcost_dbi ] = numbackprop(net, input, targetoutput, cost_fcn)

nsamples = size(input,2);
if nargin < 4
    cost_fcn = @(output,targetoutput) ...
        1/2*sum(sum((output-targetoutput).^2))/nsamples;
end

cost = cost_fcn(net.evaluate(input), targetoutput );
dcost_dwij = cell(size(net.wij));
dcost_dbi = cell(size(net.bi));

delta = 10^-6;

for i = 1:numel(net.wij)
    dcost_dwij{i} = zeros(size(net.wij{i}));
    for j = 1:numel(net.wij{i})
        x = net.wij{i}(j);
        net.wij{i}(j) = x + delta; 
        cost1 = cost_fcn(net.evaluate(input), targetoutput );
        net.wij{i}(j) = x - delta; 
        cost2 = cost_fcn(net.evaluate(input), targetoutput );
        dcost_dwij{i}(j) = (cost1 - cost2)/(2*delta);
        net.wij{i}(j) = x;
    end
end

for i = 1:numel(net.bi)
    dcost_dbi{i} = zeros(size(net.bi{i}));
    for j = 1:numel(net.bi{i})
        x = net.bi{i}(j);
        net.bi{i}(j) = x + delta; 
        cost1 = cost_fcn(net.evaluate(input), targetoutput );
        net.bi{i}(j) = x - delta; 
        cost2 = cost_fcn(net.evaluate(input), targetoutput );
        dcost_dbi{i}(j) = (cost1 - cost2)/(2*delta);
        net.bi{i}(j) = x;
    end
end

end
