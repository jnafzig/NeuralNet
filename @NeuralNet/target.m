function [cost,dcost_dinput] = target( net, input, targetoutput)
    
    [a, da_dz ] = net.feedforward( input );
    [cost, dcost_doutput] = net.cost(a{end},targetoutput);
    [~, ~,dcost_da] = net.feedbackward( dcost_doutput, a, da_dz);
    dcost_dinput = dcost_da{1};
end

