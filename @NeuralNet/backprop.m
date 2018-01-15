function [ cost, dcost_dwij, dcost_dbi, dcost_dinput, output ] = backprop( net, input, targetoutput)
    
    [a, da_dz ] = net.feedforward( input );
    [cost, dcost_doutput] = net.cost_fcn(a{end},targetoutput);
    [dcost_dwij, dcost_dbi, dcost_da] = net.feedbackward( dcost_doutput, a, da_dz);
    dcost_dinput = dcost_da{1};
    output = a{end};
    
end

