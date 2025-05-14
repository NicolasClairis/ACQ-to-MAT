
% 12/20/16, Samantha Kumarasena
% Modified version of ACQ2MAT: will save only the channels specified by the
% vector "chindices" below. 
% 
% Modify the vector to change the indices of the channels to be saved.


% --------------------------------------------------------------------
%  ACQ2MAT:  This script will automatically convert all ACQ files to MAT
%  files in all specified folders. You can simply let it run overnight.
%  The reason to do so is because it could be very time consuming to load
%  ACQ files, and to load corresponding MAT files will be much quicker.
%
%  i.e. In your MATLAB code,
%	instead of using:  acq = load_acq('MyGSR.acq');
%	you can now use:   load('MyGSR.mat');
%
%  Usage:  Please update the acq_folder list below


acq_folder = {pwd};
%acq_folder = [acq_folder {'C:\GSR\1001'}];	% uncomment it if necessary
%acq_folder = [acq_folder {'C:\GSR\1002'}];	% uncomment it if necessary

chindices = [5 6];  % SPECIFY CHANNEL(S) TO SAVE
                    % [1 2] for BM40, [5 6] for BM51, BM54


%%%%%%%  Please specify all ACQ folders above   %%%%%%%


%%%%%%%  Please do not modify any code below   %%%%%%%

for i=1:length(acq_folder)
   fn_lst = dir(fullfile(acq_folder{i}, '*.acq'));

   for j=1:length(fn_lst)
      acq_fn = fullfile(acq_folder{i}, fn_lst(j).name);
      [p f] = fileparts(acq_fn);
      suffix = ['-Channels-' mat2str(chindices)];
      mat_fn = fullfile(acq_folder{i}, [f suffix '.mat']);

      if ~exist(mat_fn,'file')
                            
          acq = load_acq_chan(acq_fn, chindices);

         v7 = version;
         if str2double(v7(1))<7
            save(mat_fn, 'acq');
         else
            save(mat_fn, '-V6', 'acq');
         end
      end
   end
end

