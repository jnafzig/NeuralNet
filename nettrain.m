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

% two-layer 300 hidden units -> trains to a little above 2% error rate on
% test set after 100 training epochs
numneurons = [784,144,10];

i = 1;
layer(i).wij = randn(numneurons(i+1),numneurons(i))/sqrt(numneurons(i));
layer(i).bi = zeros(numneurons(i+1),1);
layer(i).activation = 'sigmoid';

i = 2;
layer(i).wij = randn(numneurons(i+1),numneurons(i))/sqrt(numneurons(i));
layer(i).bi = zeros(numneurons(i+1),1);
layer(i).activation = 'sigmoid';

net = NeuralNet(layer, 'l2', 0, 'l1', 0);

learning_rate = 2.0;
maxepoch = 100;
batchsize = 200;

% plot settings
set(gcf, 'Position', [100, 100, 800, 800]);
hpadding = .025;
vpadding = .025;

framesperepoch = trainingsetsize/batchsize;
numframes = framesperepoch*maxepoch;

costbyframe = nan(numframes,1);
dmagnitude = nan(numframes,1);
daverage = nan(numframes,1);
dstddev = nan(numframes,1);

tic;
fprintf(' iter       cost        performance\n');
fprintf(' ----------------------------------\n');
epoch = 1; 
framenumber = 1;
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
        
        costbyframe(framenumber) = cost;
        dmagnitude(framenumber) = sqrt(sum(sum(dcost_dwij{1}.^2)));
        
        daverage(framenumber) = mean(mean(dcost_dwij{1}));
        dstddev(framenumber) = std(std(dcost_dwij{1}));
        
        if mod(framenumber,10) == 0 
            subplot(2,2,1);

            plotmnist(net.wij{1}'); 
            set(gca,'YTickLabel',[]);
            set(gca,'XTickLabel',[]);

            pos = get(gca, 'Position');
            pos(1) = hpadding;
            pos(3) = 0.5 - 2 * hpadding;
            pos(2) = 0.5 + vpadding;
            pos(4) = 0.5 - 2 * vpadding;
            set(gca, 'Position', pos);

            subplot(2,2,3);

            plotmnist(dcost_dwij{1}'); 
            set(gca,'YTickLabel',[]);
            set(gca,'XTickLabel',[]);

            pos = get(gca, 'Position');
            pos(1) = hpadding;
            pos(3) = 0.5 - 2 * hpadding;
            pos(2) = vpadding;
            pos(4) = 0.5 - 2 * vpadding;
            set(gca, 'Position', pos);

            subplot(2,2,2);

            plot(1:numframes, [daverage,dstddev]);xlim([0,numframes]);ylim([-1,2]*1e-4);


            subplot(2,2,4);

            plot(1:numframes, [costbyframe,dmagnitude]);ylim([0,.6]);xlim([0,numframes]);

            drawnow();
        end        
%         print(sprintf('video/%04d.png',framenumber),'-dpng')

        framenumber = framenumber+1;
        
    end
    [~,id]=max(net.evaluate(testimages));
    netlabels = id'-1;

    testperformance = sum(testlabels==netlabels);

    fprintf('   %i    %e    %i/%i\n',epoch,averagecost,testperformance,...
                                     testsetsize);
    epoch = epoch+1;   
end

toc;
