function processDirectory(indir, filestr, outdir, outext, fhandle, varargin)
% processDirectory(dirname, filestr, outdir, outext, fhandle, fargs)
%
% Calls fhandle for each file whose name matches filestr in directory
% indir and its subdirectories, if the corresponding file given by outdir
% and outext does not exist.  The arguments of fhandle are as follows:
% first, input filename; second, output filename; remaining fargs.  
%

%% Create output directory if necessary
if ~exist(outdir, 'file')
    mkdir(outdir);
end

%% Process each file in current directory
files = dir(fullfile(indir, filestr));
fn = {files.name};

for f = 1:numel(fn)

    inname = fullfile(indir, fn{f});
    outname = fullfile(outdir, [fn{f}(1:end-4) outext]);
        
    if ~exist(outname, 'file')        
%        try
            disp(' ');
            disp(['Processing ' num2str(f) ': ' inname]);
            system(['touch ' outname]);            
            fhandle(inname, outname, varargin{:});
%        catch
%           disp('!! Processing Failed !!');
%           disp(lasterr);
%           delete(outname);
%        end
    else
        %disp(['Skipping ' num2str(f) ': ' inname]);
    end
    
end

return;
disp('ok recursion')

%% Recursively call each subdirectory
files = dir(indir);
subdirs = {files([files.isdir]).name};

for f =1:numel(subdirs)

    if subdirs{f}(1)~='.' % ignore directories beginning with .
        nextdir = fullfile(indir, subdirs{f});
        disp(' ');
        disp(['Entering subdirectory: ' nextdir]);
        processDirectory(nextdir, filestr, fullfile(outdir, subdirs{f}), ...
            outext, fhandle, varargin{:});
    end
end
    
