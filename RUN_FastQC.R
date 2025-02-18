# ---------------------------------------------------------------
# R script: 批次對指定資料夾下的 FASTQ 檔案執行 FastQC
# ---------------------------------------------------------------

# 請將此設定為您放置 FASTQ 檔案的資料夾路徑 (Windows 須注意反斜線替換):
fastq_dir <- "C:/path/to/your/fastq/files"

# (選擇性) 若無法使用 fastqc，請將 fastqc_path 設為 fastqc.exe 的路徑
# 例如: fastqc_path <- "C:/Program Files/FastQC/fastqc.exe"
# 如果您已將 fastqc.exe 加入 PATH，則只需: 
fastqc_path <- "fastqc"

# 設定輸出報告存放的資料夾，如沒有此資料夾則會自動建立
output_dir <- file.path(fastq_dir, "fastqc_results")
if (!dir.exists(output_dir)) {
  dir.create(output_dir, recursive = TRUE)
}

# 尋找指定資料夾內以 .fastq 或 .fq 結尾的檔案
fastq_files <- list.files(
  path        = fastq_dir,
  pattern     = "\\.(fastq|fq)$",
  full.names  = TRUE,
  ignore.case = TRUE
)

# 確認是否有找到任何 FASTQ 檔案
if (length(fastq_files) == 0) {
  stop("在指定的資料夾中未找到任何 FASTQ 檔案，請檢查路徑或檔名是否正確。")
}

# 對每個 fastq 檔案依序執行 FastQC
for (fq in fastq_files) {
  message("正在處理：", fq)
  
  # system2 可讓我們分開指定指令與參數
  # -o 指定輸出資料夾
  # --threads 可指定使用多少 CPU 執行 (可視機器資源調整)
  cmd_args <- c("-o", output_dir, "--threads", "2", fq)
  
  # 執行 FastQC
  system2(command = fastqc_path, args = cmd_args, wait = TRUE)
}

message("FastQC 分析已完成，結果存放於：", output_dir)
