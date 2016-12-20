# ACQ-to-MAT

12/20/2016 Samantha Kumarasena

Modified acq2mat.m to allow user to specify which channels of the ACQ file will be loaded and saved. Made these modifications because of memory issues. 

Renamed load_acq.m to load_acq_chan.m. 

Edited load_acq() and read_acq(), creating new versions of these functions (load_acq_chan() and read_acq_chan() respectively). 

User can modify the "chindices" vector in acq2mat.m to specify the indices (1-indexed) of the channels they would like to save. 

Output: acq struct containing "data", a matrix of doubles containing the data from the specified channels.