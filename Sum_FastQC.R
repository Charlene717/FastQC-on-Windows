# 載入必要的套件
library(tidyverse)
library(zip)

# 設定 FastQC 結果所在的資料夾
fastqc_dir <- "C:/Users/q2330/Dropbox/KGD_Lab/20250120_QC_CYLD Cutaneous Syndrome/Fastqc_QC_Report"

# 取得所有 .zip 檔案的路徑
fastqc_files <- list.files(fastqc_dir, pattern = "_fastqc.zip$", full.names = TRUE)

# 解析 summary.txt 的函數
parse_fastqc_summary <- function(zip_file) {
  # 建立暫存目錄
  temp_dir <- file.path(tempdir(), gsub("_fastqc.zip", "", basename(zip_file)))
  dir.create(temp_dir, showWarnings = FALSE, recursive = TRUE)
  
  # 解壓縮完整 zip
  unzip(zip_file, exdir = temp_dir)
  
  # 找到 summary.txt 的實際路徑 (通常在子資料夾內)
  summary_file <- list.files(temp_dir, pattern = "summary.txt$", full.names = TRUE, recursive = TRUE)
  
  if (length(summary_file) == 0) {
    return(NULL)  # 若找不到，返回 NULL
  }
  
  # 讀取 summary.txt
  summary_data <- read.delim(summary_file[1], header = FALSE, sep = "\t", stringsAsFactors = FALSE)
  colnames(summary_data) <- c("Status", "Metric", "Filename")
  
  # 取得樣本名稱
  sample_name <- gsub("_fastqc.zip", "", basename(zip_file))
  summary_data$Sample <- sample_name
  
  return(summary_data)
}

# 讀取所有 FastQC 的 QC 結果
fastqc_results <- lapply(fastqc_files, parse_fastqc_summary)

# 合併成一個 dataframe
fastqc_summary_df <- bind_rows(fastqc_results)

# 重新排列欄位順序
fastqc_summary_df <- fastqc_summary_df %>%
  select(Sample, Metric, Status)

# 將整理後的結果輸出
write.csv(fastqc_summary_df, file = file.path(fastqc_dir, "FastQC_summary.csv"), row.names = FALSE)

# 顯示前幾行
print(head(fastqc_summary_df))
