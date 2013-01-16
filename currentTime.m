function [timeStr] = currentTime()
	% get current time in concatenated string format

	c = fix(clock);
	timeStr = '';
	for i=1:length(c)
		timeStr = strcat(timeStr, num2str(c(i)));
	end

end

