##### Presetting #####
rm(list = ls())  # Remove all objects from the current R environment
memory.limit(150000)  # Set memory limit

##### Load Packages #####
if(!require('tidyverse')) {install.packages('tidyverse'); library(tidyverse)}
if(!require('zip')) {install.packages('zip'); library(zip)}


##### Load Data #####
# Set the directory containing FastQC result files
# fastqc_dir <- "C:/Users/q2330/Dropbox/KGD_Lab/Dataset/20240920_Philippines/Trimmed_fastq/QC_Report"
# fastqc_dir <- "C:/Charlene/Dataset_KGD_Lab/Bulk RNA-seq/Dani_20250316/download_2025-03-26_10-03-24/FastQC"
fastqc_dir <- "C:/Charlene/Dataset_KGD_Lab/Bulk RNA-seq/Dani_20250316/download_2025-03-26_10-03-24/rawData/Trimmed_fastq/Output"

# Retrieve all .zip files in the directory
fastqc_files <- list.files(fastqc_dir, pattern = "_fastqc.zip$", full.names = TRUE)


#### Set Export ####
Set_Project <- "Trichoepitheliomas" # "CYLD"

# Generate unique export parameters
Name_time_wo_micro <- substr(gsub("[- :]", "", as.character(Sys.time())), 1, 10) # Generate a unique time-based ID
Name_FileID <- paste0(Name_time_wo_micro, paste0(sample(LETTERS, 3), collapse = ""))

## Construct Set_note
Set_note <- paste0(Name_FileID, "_", Set_Project)


Name_Export <- paste0(Name_FileID)
Name_ExportFolder <- paste0("Export_",Set_note)
# Create export folder if it does not exist
if (!dir.exists(Name_ExportFolder)){dir.create(Name_ExportFolder)}


##### Data Processing #####
# Function to parse summary.txt from FastQC results
parse_fastqc_summary <- function(zip_file) {
  # Create a temporary directory for extraction
  temp_dir <- file.path(tempdir(), gsub("_fastqc.zip", "", basename(zip_file)))
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)
  
  # Extract the zip file
  unzip(zip_file, exdir = temp_dir)
  
  # Locate the summary.txt file (usually inside a subfolder)
  summary_file <- list.files(temp_dir, pattern = "summary.txt$", full.names = TRUE, recursive = TRUE)
  
  if (length(summary_file) == 0) {
    return(NULL)  # Return NULL if summary.txt is not found
  }
  
  # Read summary.txt
  summary_data <- read.delim(summary_file[1], header = FALSE, sep = "\t", stringsAsFactors = FALSE)
  colnames(summary_data) <- c("Status", "Metric", "Filename")
  
  # Extract sample name from the file name
  sample_name <- gsub("_fastqc.zip", "", basename(zip_file))
  summary_data$Sample <- sample_name
  
  return(summary_data)
}

# Read and process all FastQC result files
fastqc_results <- lapply(fastqc_files, parse_fastqc_summary)

# Combine all results into a single dataframe
fastqc_summary_df <- bind_rows(fastqc_results)

# Reorder columns
fastqc_summary_df <- fastqc_summary_df %>%
  select(Sample, Metric, Status)

##### Wide Format Conversion #####
# Convert to wide format with Metrics as rows and Samples as columns
fastqc_summary_wide <- fastqc_summary_df %>%
  pivot_wider(names_from = Sample, values_from = Status)

# Display the first few rows
print(head(fastqc_summary_wide))

## Export
# Save the processed results to a CSV file
write.csv(fastqc_summary_wide, file = paste0(Name_ExportFolder,"/", Name_Export,"_FastQC_summary.csv"), row.names = FALSE)

################################################################################
#### Create colored.xlsx ####

# Install and load required package
if(!require("openxlsx")) install.packages("openxlsx"); library(openxlsx)

# Create a new workbook
wb <- createWorkbook()

# Add a worksheet
addWorksheet(wb, "FastQC Summary")

# Write the data to the worksheet
writeData(wb, "FastQC Summary", fastqc_summary_wide, rowNames = FALSE)

# Define styles for PASS, FAIL, and WARN
pass_style <- createStyle(fontColour = "#000000", bgFill = "#A3D977")  # Green
fail_style <- createStyle(fontColour = "#FFFFFF", bgFill = "#E06666")  # Red
warn_style <- createStyle(fontColour = "#000000", bgFill = "#FFA500")  # Orange

# Apply conditional formatting to all sample columns (excluding first column "Metric")
num_cols <- ncol(fastqc_summary_wide)

for (col in 2:num_cols) {  # Start from column 2 since column 1 is "Metric"
  col_letter <- int2col(col)  # Convert column index to Excel letter
  
  conditionalFormatting(wb, sheet = "FastQC Summary", cols = col, rows = 2:(nrow(fastqc_summary_wide) + 1), 
                        rule = "PASS", style = pass_style, type = "contains")
  
  conditionalFormatting(wb, sheet = "FastQC Summary", cols = col, rows = 2:(nrow(fastqc_summary_wide) + 1), 
                        rule = "FAIL", style = fail_style, type = "contains")
  
  conditionalFormatting(wb, sheet = "FastQC Summary", cols = col, rows = 2:(nrow(fastqc_summary_wide) + 1), 
                        rule = "WARN", style = warn_style, type = "contains")
}

## Save the workbook
saveWorkbook(wb, paste0(Name_ExportFolder,"/", Name_Export,"_FastQC_summary_colored.xlsx"), overwrite = TRUE)

print("Excel file with conditional formatting has been saved as FastQC_summary_colored.xlsx")



## Export session information 
writeLines(capture.output(sessionInfo()), paste0(Name_ExportFolder,"/", Name_Export,"_session_info.txt"))
# sessionInfo()




