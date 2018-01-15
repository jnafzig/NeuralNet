function [ cost_fh ] = costfunctions( ~, cost )

    if isa(cost,'function_handle')
        cost_fh = cost;
        return;
    end
    
    switch lower(cost)
        case 'quadratic'
            cost_fh = @quadraticfunc;
        otherwise
            error('Cost function not recognized');
    end
    
    function [ cost, dcost_doutput ] = quadraticfunc(output, targetoutput )
        nsamples = size(output,2);
        dcost_doutput = (output-targetoutput);
        cost = 1/2*sum(sum(dcost_doutput.^2))/nsamples;
    end

end

