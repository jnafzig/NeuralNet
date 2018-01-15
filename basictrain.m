clear;

allimages = loadMNISTImages('train-images.idx3-ubyte');
alllabels = loadMNISTLabels('train-labels.idx1-ubyte');

testimages = loadMNISTImages('t10k-images.idx3-ubyte');
testlabels = loadMNISTLabels('t10k-labels.idx1-ubyte');

images = allimages;
labels = alllabels;

testsetsize = numel(testlabels);
trainingsetsize = size(images,2);

target = full(sparse(labels+1,1:trainingsetsize,1,10,trainingsetsize));

% Probably the simplest neural network for mnist: single layer with ten neurons;
numneurons = [784,10];

i = 1;
layer(i).wij = rand(numneurons(i+1),numneurons(i))/sqrt(numneurons(i));
layer(i).bi = zeros(numneurons(i+1),1);
layer(i).activation = 'sigmoid';

net = NeuralNet(layer, 'l2', 2e-3, 'l1', 2e-4);

learning_rate = 1;
maxepoch = 1;
batchsize = 200;

tic;
fprintf(' iter       cost        performance\n');
fprintf(' ----------------------------------\n');
epoch = 1; 
framenumber = 0;
while epoch<=maxepoch;
    trainingregimen = randperm(trainingsetsize);
    averagecost = 0;
    for batchstart = 1:batchsize:trainingsetsize
        traininggroup = trainingregimen((1:batchsize)+batchstart-1);
        traininginput = images(:,traininggroup);
        trainingoutput = target(:,traininggroup);
        [ cost, dcost_dwij, dcost_dbi ] = ...
            backprop( net, traininginput, trainingoutput);
        for i = 1:net.numlayers
            net.wij{i} = net.wij{i} - learning_rate*dcost_dwij{i};
            net.bi{i} = net.bi{i} - learning_rate*dcost_dbi{i};
        end
        averagecost = averagecost + cost*batchsize/trainingsetsize;
        
        plotmnist(net.wij{1}'); 
        set(gca,'YTickLabel',[]);
        set(gca,'XTickLabel',[]);
        drawnow();
%         framenumber = framenumber+1;
%         print(sprintf('video/%04d.png',framenumber),'-dpng')

    end
    [~,id]=max(net.evaluate(testimages));
    netlabels = id'-1;

    testperformance = sum(testlabels==netlabels);

    fprintf('   %i    %e    %i/%i\n',epoch,averagecost,testperformance,...
                                     testsetsize);
    epoch = epoch+1;   
end

toc;
