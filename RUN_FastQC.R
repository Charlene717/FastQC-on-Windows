# ---------------------------------------------------------------
# R Script: Batch-run FastQC on FASTQ files in a specified folder
# ---------------------------------------------------------------

# Set the working directory to the folder containing FastQC.
# This ensures that the relative paths used by 'run_fastqc.bat'
# (particularly the CLASSPATH and Java calls) will be recognized correctly.
setwd("C:/Charlene/fastqc_v0.12.1/FastQC")

# Define the FastQC batch file name or path.
# For Windows, this is typically 'run_fastqc.bat'.
# If you have 'fastqc.exe' instead, specify it here.
fastqc_exe <- "run_fastqc.bat"

# Specify the folder that contains your .fastq.gz files.
# Please adjust the path below to the location of your input files.
input_folder <- "C:/Charlene/Code_GitHub_BioInport2025/Sum_FastQC/Input"

# Specify the folder where FastQC output (HTML and ZIP files) will be saved.
# If the folder does not exist, it will be created automatically.
output_folder <- "C:/Charlene/Code_GitHub_BioInport2025/Sum_FastQC/Output"
if (!dir.exists(output_folder)) {
  dir.create(output_folder, recursive = TRUE)
}

# Generate a list of all files in 'input_folder' that match the pattern ".fastq.gz".
# The parameter 'full.names = TRUE' returns the full path for each file.
file_list <- list.files(
  path = input_folder,
  pattern = "\\.fastq\\.gz$",
  full.names = TRUE
)

# Loop through each file in 'file_list' and run FastQC.
for (f in file_list) {
  
  # Construct the command line string to be executed.
  # It includes:
  # 1. The FastQC batch file (or executable).
  # 2. The '--outdir' option pointing to the output folder.
  # 3. The full path of the current FASTQ file.
  cmd <- paste(
    shQuote(fastqc_exe),
    "--outdir", shQuote(output_folder),
    shQuote(f)
  )
  
  # Display the constructed command in the R console for reference.
  message("Executing command: ", cmd)
  
  # Execute the FastQC command via the system shell.
  system(cmd)
}

# Print a final message in the console to indicate completion of the FastQC process.
message("FastQC processing is complete!")
