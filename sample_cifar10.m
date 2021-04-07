addpath('datasets');
addpath('funcs');

reqToolboxes = {'Deep Learning Toolbox'};
if( ~checkToolboxes(reqToolboxes) )
 msg = 'It requires:';
 for i=1:numel(reqToolboxes)
  msg = [msg, reqToolboxes{i}, ', ' ];
 end
 msg = [msg, 'Please install these toolboxes.'];
 error(msg);
end

% help
% https://mathworks.com/help/deeplearning/ref/classify.html

if( ~exist( 'train1000', 'var' ) )
    train1000 = true;
end

if( train1000 )
 [XTrain, YTrain, XTest, YTest] = load_train1000('cifar10');
else
 [XTrain, YTrain, XTest, YTest] = load_dataset('cifar10');
end

nb_classes = 10;
layers = [ ...
    imageInputLayer([32 32 3])
    
    convolution2dLayer(3, 32, 'padding', 'same')
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3, 64, 'padding', 'same')
    reluLayer

    fullyConnectedLayer(128)    
    reluLayer

    dropoutLayer(0.5)
    
    fullyConnectedLayer(nb_classes)    
    softmaxLayer
    classificationLayer];

options = trainingOptions('adam', ...
    'Shuffle','every-epoch', ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 100, ...
    'ValidationData',{XTest, YTest}, ...
    'ValidationFrequency', 10, ...
    'Plots','training-progress');

net = trainNetwork(XTrain, YTrain,layers,options);

YPred = predict(net,XTrain);
acc = mean_accuracy( YTrain, YPred );
ce = mean_cross_entropy( YTrain, YPred );
fprintf( 'Train mean accuracy: %g\n', acc );
fprintf( 'Train mean cross entropy: %g\n\n', ce );

YPred = predict(net,XTest);
acc = mean_accuracy( YTest, YPred );
ce = mean_cross_entropy( YTest, YPred );
fprintf( 'Test mean accuracy: %g\n', acc );
fprintf( 'Test mean cross entropy: %g\n\n', ce );

if( train1000 )
 disp( '********** ********** ********** **********' );
 disp( '* It was trained with just 1000 samples.' );
 disp( '* Please visit train with 1000 project page: <a href="http://www.ok.sc.e.titech.ac.jp/~mtanaka/proj/train1000/">http://www.ok.sc.e.titech.ac.jp/~mtanaka/proj/train1000/</a>' );
 disp( '* ' );
 disp( '* If you want to train with full size of training data, please run as follow:' );
 disp( '* >> train1000 = false; sample_cifar10;' );
 disp( '********** ********** ********** **********' );
end

saveasbytestream( 'net.bytestream', net );
