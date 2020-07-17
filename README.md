# CheckMedia
Batch script to print MD5 hash of each file in the same directory recursively. The script also verifies the result by comparing with the MD5 hash master file.


## Usage
1. Put CheckMedia.bat into the target root directory.
2. Run the CheckMedia.bat (with aboslute path or relative path - both works).
3. The initial result shows "CheckMediaMaster.txt is not found", and copy "CheckMediaResult.txt" from %TEMP% into the same directory and rename it as "CheckMediaMaster.txt".
4. Run the CheckMedia.bat again. It shows "PASSED" if it matches.
