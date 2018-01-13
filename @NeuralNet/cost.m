function [ cost, dcost_doutput ] = cost( ~, output, targetoutput )
    
    nsamples = size(output,2);
    dcost_doutput = (output-targetoutput);
    cost = 1/2*sum(sum(dcost_doutput.^2))/nsamples;
        
end


