function [cost, dcost_dwij, dcost_dbi] = regularize(net, cost, dcost_dwij, dcost_dbi)
    if (net.l1 == 0 && net.l2 == 0), return; end
    
    reg_cost = 0;
    for i = 1:net.numlayers
        reg_cost = reg_cost + net.l2 * sum(sum(net.wij{i}.^2/2)) + net.l1 * sum(sum(abs(net.wij{i})));
        dcost_dwij{i} = dcost_dwij{i} + net.l2 * net.wij{i} + net.l1 * sign(net.wij{i});
    end
    cost = cost + reg_cost;
end

