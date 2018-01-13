function plotmnist(images)

Nimages = size(images,2);

p = floor(sqrt(Nimages));
q = ceil(Nimages/p);

imgarray = zeros(p*28,q*28);

for i = 1:Nimages
    neuronimg = reshape(images(:,i),28,28);
    [j,k] = ind2sub([p,q],i);
    imgarray((1:28)+(j-1)*28,(1:28)+(k-1)*28) = neuronimg;
end


imagesc(imgarray);colormap(gray);
end