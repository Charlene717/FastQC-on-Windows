# ---------------------------------------------------------------
# R script: 批次對指定資料夾下的 FASTQ 檔案執行 FastQC
# ---------------------------------------------------------------

# 設定包含 FASTQ 檔的資料夾路徑 (請自行修改為正確的路徑)
fastq_dir <- "C:/path/to/your/fastq/files"

# 若您要使用 run_fastqc.bat，請指定其絕對路徑
fastqc_path <- "C:/Charlene/fastqc_v0.12.1/FastQC/run_fastqc.bat"

# 設定 FastQC 報告輸出資料夾。若此資料夾不存在，會自動建立
output_dir <- file.path(fastq_dir, "fastqc_results")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# 尋找指定資料夾內以 .fastq 或 .fq 結尾的檔案 (大小寫不分)
fastq_files <- list.files(
  path        = fastq_dir,
  pattern     = "\\.(fastq|fq)$",
  full.names  = TRUE,
  ignore.case = TRUE
)

# 檢查是否找到任何 FASTQ 檔案
if (length(fastq_files) == 0) {
  stop("在指定的資料夾中未找到任何 FASTQ 檔案，請檢查路徑或檔名是否正確。")
}

# 使用 system2 執行 run_fastqc.bat
for (fq in fastq_files) {
  message("正在處理：", fq)
  
  # FastQC 常用參數：
  #   -o       指定輸出資料夾
  #   --threads  指定要使用多少 CPU 執行
  # 您可依實際需求增減或調整參數
  cmd_args <- c("-o", output_dir, "--threads", "2", fq)
  
  # 執行 FastQC
  system2(command = fastqc_path, args = cmd_args, wait = TRUE)
}

message("FastQC 分析已完成，結果存放於：", output_dir)
