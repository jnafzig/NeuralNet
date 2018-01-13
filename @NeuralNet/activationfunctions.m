function [ activation_fh ] = activationfunctions( ~, activation )

    if isa(activation,'function_handle')
        activation_fh = activation;
        return;
    end
    
    switch lower(activation)
        case 'relu'
            activation_fh = @relufunc;
        case 'linear'
            activation_fh = @linearfunc;
        case 'leakyrelu'
            activation_fh = @leakyrelufunc;
        case 'tanh'
            activation_fh = @tanhfunc;
        case 'sigmoid'
            activation_fh = @sigmoidfunc;
        case 'softplus'
            activation_fh = @softplusfunc;
        otherwise
            error('Activation not recognized');
    end
    
    function [ output, doutput ] = relufunc(input)
        output = input;
        output(output<0) = 0;
        if nargout<2; return; end;
        doutput = heaviside(input);
    end
    
    function [ output, doutput ] = linearfunc(input)
        output = input;
        if nargout<2; return; end;
        doutput = ones(size(input));
    end

    function [ output, doutput ] = leakyrelufunc(input)
        output = input;
        output(output<0) = output(output<0)/100;
        if nargout<2; return; end;
        doutput = heaviside(input)+heaviside(-input)/100;
    end
    
    function [ output, doutput ] = tanhfunc(input)
        output = tanh(input);
        if nargout<2; return; end;
        doutput = 1-output.^2;
    end

    function [ output, doutput ] = sigmoidfunc(input)
        output = 1./(1+exp(-input));
        if nargout<2; return; end;
        doutput = output.*(1-output);
    end
    
    function [ output, doutput ] = softplusfunc(input)
        output = log(1+exp(input));
        if nargout<2; return; end;
        doutput = 1./(1+exp(-input));
    end

end

