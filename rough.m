results = {};

for i=1:length(posts)
	if(length(posts{i}{3})>2)
		results{end+1, 1} = sprintf('%d \t %s \t %d\n', i, posts{i}{2}, posts{i}{1});
		break
	end
end