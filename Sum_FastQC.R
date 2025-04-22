## Ref: https://chatgpt.com/share/680499ed-1b60-8002-abf0-0dbf20ae2f7b
## https://chatgpt.com/g/g-p-67b46db7124c8191900f83011a09eeaa-charlene-fastqc/c/680488c2-2944-8002-bd30-0a3a75c74d3c

##### Presetting #####
rm(list = ls())  # Remove all objects from the current R environment
memory.limit(150000)  # Set memory limit

##### Load Packages #####
if(!require('tidyverse')) {install.packages('tidyverse'); library(tidyverse)}
if(!require('zip')) {install.packages('zip'); library(zip)}


##### Load Data #####
# Set the directory containing FastQC result files
# fastqc_dir <- "C:/Charlene/Dataset_KGD_Lab/Bulk RNA-seq/Dani_20250316/download_2025-03-26_10-03-24/FastQC"
# fastqc_dir <- "C:/Charlene/Dataset_KGD_Lab/Bulk RNA-seq/Dani_20250316/download_2025-03-26_10-03-24/rawData/Trimmed_fastq/Output"
# fastqc_dir <- "C:/Charlene/Dataset_KGD_Lab/Bulk RNA-seq/Dani_20250316/download_2025-03-26_10-03-24/rawData/Trimmed_fastq/Output_20250412_ChatGPTDR"
fastqc_dir <- "C:/Charlene/Dataset_KGD_Lab/Bulk RNA-seq/Dani_20250316/download_2025-03-26_10-03-24/rawData/Trimmed_fastq/Output_20250421_ChatGPTDR"

# Retrieve all .zip files in the directory
fastqc_files <- list.files(fastqc_dir, pattern = "_fastqc.zip$", full.names = TRUE)


#### Set Export ####
Set_Project <- "Trichoepitheliomas_ChatGPTDR" # "CYLD"

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


###############################################################################
##### 依FastQC結果上色 #####
###############################################################################

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
fail_style <- createStyle(fontColour = "#FFFFFF", bgFill = "#d17b7b")  # Red    # "#E06666"
warn_style <- createStyle(fontColour = "#000000", bgFill = "#e8bd6f")  # Orange # "#FFA500"

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

# ## Save the workbook
# saveWorkbook(wb, paste0(Name_ExportFolder,"/", Name_Export,"_FastQC_summary_colored.xlsx"), overwrite = TRUE)
# 
# print("Excel file with conditional formatting has been saved as FastQC_summary_colored.xlsx")


###############################################################################
##### 依 Bulk RNA‑seq 重要性排序並為指標列上色 #####
###############################################################################

##── 1. 自訂三大類指標 ------------------------------------------------------##
critical_metrics <- c("Basic Statistics",
                      "Adapter Content",
                      "Per base sequence quality",
                      "Per sequence quality scores",
                      "Per base N content",
                      "Overrepresented sequences")

relax_metrics    <- c("Sequence Duplication Levels",
                      "Per base sequence content",
                      "Per sequence GC content",
                      "Sequence Length Distribution")

ignore_metrics   <- c("Kmer Content",
                      "Per tile sequence quality")

# 若未列入者保持原順序 (e.g. 新版 FastQC 模組名稱可能不同)
metric_order <- c(critical_metrics, relax_metrics, ignore_metrics,
                  setdiff(fastqc_summary_wide$Metric, 
                          c(critical_metrics, relax_metrics, ignore_metrics)))

##── 2. 依重要性排序 DataFrame ------------------------------------------------##
fastqc_summary_wide <- fastqc_summary_wide %>% 
  mutate(Metric = factor(Metric, levels = metric_order)) %>% 
  arrange(Metric)

##── 3. 建立三種底色 Style ----------------------------------------------------##
## 建議改用 fgFill 並同時指定 fontColour
style_critical <- createStyle(fontColour = "#000000", fgFill = "#6dbf92") # 深紅底白字
style_relax    <- createStyle(fontColour = "#000000", fgFill = "#ffbe5c") # 橘黃底黑字
style_ignore   <- createStyle(fontColour = "#000000", fgFill = "#e0e0e0") # 淺灰底黑字


##── 4. 重新寫入工作表 (取代先前 writeData) -----------------------------------##
# 若你已在上方寫過 once，可以先 removeWorksheet 或重新建 wb
removeWorksheet(wb, "FastQC Summary")
addWorksheet(wb, "FastQC Summary")
writeData(wb, "FastQC Summary", fastqc_summary_wide, rowNames = FALSE)

##── 5. 先套用 PASS / FAIL / WARN 條件式格式 (與你原碼相同) ------------------##
num_cols <- ncol(fastqc_summary_wide)
for (col in 2:num_cols) {
  conditionalFormatting(wb, "FastQC Summary", cols = col,
                        rows = 2:(nrow(fastqc_summary_wide) + 1),
                        rule = "PASS", style = pass_style, type = "contains")
  conditionalFormatting(wb, "FastQC Summary", cols = col,
                        rows = 2:(nrow(fastqc_summary_wide) + 1),
                        rule = "FAIL", style = fail_style, type = "contains")
  conditionalFormatting(wb, "FastQC Summary", cols = col,
                        rows = 2:(nrow(fastqc_summary_wide) + 1),
                        rule = "WARN", style = warn_style, type = "contains")
}

##── 6. 針對整列再疊加背景色 (stack = TRUE) ----------------------------------##
for (i in seq_len(nrow(fastqc_summary_wide))) {
  metric <- fastqc_summary_wide$Metric[i]
  row_id <- i + 1  # +1 因為第 1 列是標題
  
  if (metric %in% critical_metrics) {
    addStyle(wb, "FastQC Summary", style = style_critical,
             rows = row_id, cols = 1:num_cols, gridExpand = TRUE, stack = TRUE)
  } else if (metric %in% relax_metrics) {
    addStyle(wb, "FastQC Summary", style = style_relax,
             rows = row_id, cols = 1:num_cols, gridExpand = TRUE, stack = TRUE)
  } else if (metric %in% ignore_metrics) {
    addStyle(wb, "FastQC Summary", style = style_ignore,
             rows = row_id, cols = 1:num_cols, gridExpand = TRUE, stack = TRUE)
  }
}

##── 7. 儲存 Excel -----------------------------------------------------------##
saveWorkbook(wb,
             file = paste0(Name_ExportFolder,"/", Name_Export,
                           "_FastQC_summary_colored_metrics_order.xlsx"),
             overwrite = TRUE)



## Export session information 
writeLines(capture.output(sessionInfo()), paste0(Name_ExportFolder,"/", Name_Export,"_session_info.txt"))
# sessionInfo()




