function [ dcost_dwij, dcost_dbi, dcost_da ] = feedbackward( net, dcost_doutput, a, da_dz  )
    nsamples = size(dcost_doutput,2);
    nlayers = numel(net.wij);
    
    dcost_da = cell(nlayers+1,1);
    dcost_dwij = cell(nlayers,1);
    dcost_dbi = cell(nlayers,1);

    dcost_da{end} = dcost_doutput;
        
    for i = nlayers:-1:1
        dcost_dz = dcost_da{i+1}.*da_dz{i+1};
        
        dcost_dwij{i} = dcost_dz*a{i}'/nsamples;        
        dcost_dbi{i} = sum(dcost_dz,2)/nsamples;
        
        dcost_da{i} = net.wij{i}'*dcost_dz;
    end

end

