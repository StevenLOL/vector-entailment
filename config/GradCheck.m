function [ hyperParams, options, wordMap, relationMap ] = GradCheck(transDepth, topDepth, composition, summing, trainwords, fastemb, multipleClassSets, sentiment)
% Set up a gradient check for the main learned parameters.

[hyperParams, options] = Defaults();

if composition == -1
	hyperParams.useThirdOrderComposition = 0;
	hyperParams.useThirdOrderMerge = 0;
	hyperParams.useSumming = 1;
elseif composition < 2
	hyperParams.useThirdOrderComposition = composition;
	hyperParams.useThirdOrderMerge = composition;
elseif composition == 2
	hyperParams.lstm = 1;
	hyperParams.useTrees = 0;
	hyperParams.eyeScale = 0;
	hyperParams.useThirdOrderComposition = 0;
	hyperParams.useThirdOrderMerge = 1;
	hyperParams.parensInSequences = 0;
elseif composition == 3
	hyperParams.lstm = 0;
	hyperParams.useTrees = 0;
	hyperParams.useThirdOrderComposition = 0;
	hyperParams.useThirdOrderMerge = 1;
	hyperParams.parensInSequences = 0;
elseif composition == 4
	hyperParams.usePyramids = 1;
	hyperParams.lstm = 0;
	hyperParams.useTrees = 0;
	hyperParams.useThirdOrderComposition = 0;
	hyperParams.useThirdOrderMerge = 1;
	hyperParams.parensInSequences = 0;
elseif composition == 5
	hyperParams.usePyramids = 1;
	hyperParams.lstm = 0;
	hyperParams.useTrees = 0;
	hyperParams.useThirdOrderComposition = 0;
	hyperParams.useThirdOrderMerge = 1;
	hyperParams.parensInSequences = 0;
end

% Add identity matrices where appropriate in initiazilation.
hyperParams.eyeScale = hyperParams.eyeScale;

hyperParams.name = 'gradcheck';

% The dimensionality of the word/phrase vectors.
hyperParams.dim = 3;
hyperParams.embeddingDim = 3;

% The dimensionality of the comparison layer(s).
hyperParams.penultDim = 3;

hyperParams.testFraction = 0.33;

% Test text file loading, rather than importing preprocessed data.
hyperParams.ignorePreprocessedFiles = true;

% The number of embedding transform layers. transDepth > 0 means NN layers will be
% added above the embedding matrix. This is likely to only be useful when
% learnWords is false, and so the embeddings do not exist in the same space
% the rest of the constituents do.
hyperParams.embeddingTransformDepth = transDepth;

hyperParams.topDepth = topDepth;

% If set, store embedding matrix gradients as spare matrices, and only apply regularization
% to the parameters that are in use at each step.
hyperParams.fastEmbed = fastemb;

% Turn off gradient/delta clipping, since that distrorts gradients.
hyperParams.clipGradients = false;
hyperParams.maxGradNorm = inf;
hyperParams.maxDeltaNorm = inf;

% Turn off regularization to more clearly show patterns in the main gradinets.
hyperParams.lambda = 0;

% Hack: -1 => always drop out the same one unit.
hyperParams.bottomDropout = -1;
hyperParams.topDropout = -1;

% Use a simple summing layer function for composition (implemented in Tree).
hyperParams.useSumming = summing;

hyperParams.loadWords = false;
hyperParams.trainWords = trainwords;

hyperParams.minFunc = true;

%%% minFunc options:
global options
options.Method = 'lbfgs';
options.MaxFunEvals = 1000;
options.Display = 'full';
options.numDiff = 0;
options.LS_init = '2';
options.PlotFcns = [];
options.DerivativeCheck = 'on';

wordMap = InitializeMaps('./quantifiers/wordlist.tsv'); 
hyperParams.vocabName = 'quantifiers';

if sentiment 
	hyperParams.sentimentMode = 1;
	wordMap = InitializeMaps('./sst-data/gradcheckwords.txt');
	hyperParams.vocabName = 'sst-gc'; 

	hyperParams.numRelations = [5];

	hyperParams.relations = {{'0', '1', '2', '3', '4'}};
	relationMap = cell(1, 1);
	relationMap{1} = containers.Map(hyperParams.relations{1}, 1:length(hyperParams.relations{1}));

	hyperParams.trainFilenames = {};    
	hyperParams.splitFilenames = {'./sst-data/gradcheckfile.txt'};    
	hyperParams.testFilenames = {};
else
	if ~multipleClassSets
		hyperParams.relations = {{'#', '=', '>', '<', '|', '^', 'v'}};
		hyperParams.numRelations = [7];
		relationMap = cell(1, 1);
		relationMap{1} = containers.Map(hyperParams.relations{1}, 1:length(hyperParams.relations{1}));

		hyperParams.splitFilenames = {'./quantifiers/test_file.tsv'};
		hyperParams.trainFilenames = {};
		hyperParams.testFilenames = {};
	else
		hyperParams.relations = {{'#', '=', '>', '<', '|', '^', 'v'},
								 {'a', 'b', 'c', '#', '=', '>', '<', '|', '^', 'v'}};
		hyperParams.numRelations = [7, 10];
		hyperParams.relationIndices = [0, 0; 0, 0; 1, 2];
	    hyperParams.testRelationIndices = [1, 2];

		relationMap = cell(2, 1);
		relationMap{1} = containers.Map(hyperParams.relations{1}, 1:length(hyperParams.relations{1}));
		relationMap{2} = containers.Map(hyperParams.relations{2}, 1:length(hyperParams.relations{2}));

		hyperParams.splitFilenames = {'./quantifiers/test_file.tsv', './quantifiers/test_file_2.tsv'};
		hyperParams.trainFilenames = {};
		hyperParams.testFilenames = {};
	end
end

end
