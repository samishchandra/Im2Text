
Use the following funciton to get both Object and Scene Probabilities

[objProb, objResult, sceneProb, sceneResult] = GetObjSceneProbabilities(imgDir, postsFilenames, qPostsFilenames)

Input
-----
imgDir - Directory path for the images
postsFilenames - cell array of dimensions {n, 1} containing urls
qPostsFilenames - cell array of dimensions {m, 1} containing urls

Output
------
objProb is 
	list of cell array of 
	{
	    probability,
	    objName,
	    filename,
	    postId
	}

objResult is 
	sorted list of cell array of 
	{
	    concatenated objProb cell values
	}

sceneProb is 
	list of cell array of 
	{
	    probability,
	    filename,
	    postId
	}

sceneResult is 
	sorted list of cell array of 
	{
	    concatenated sceneProb cell values
	}







