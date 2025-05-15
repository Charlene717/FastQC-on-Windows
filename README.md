# How to Operate FastQC on Windows

## 1. Download FastQC
1. **Download FastQC** from the official website:  
   [https://www.bioinformatics.babraham.ac.uk/projects/fastqc/](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)  
2. **Install a suitable Java Runtime Environment (JRE)**. You can find a link to a suitable Java version on the FastQC website, or you can install any standard JRE (version 1.8 or above should work).

---

## 2. Manual File Import and Execution
1. **Extract the FastQC zip file** to any convenient location on your computer.  
   For example: `C:\Tools\FastQC`

2. **Run FastQC via the GUI (using `run_fastqc.bat`)**:  
   - In the extracted FastQC folder, look for a `.bat` file named `run_fastqc.bat` (or `fastqc.bat` in some distributions).  
   - Double-click this `.bat` file to launch a simple graphical interface.  
   - You can then manually select one or more FASTQ files to analyze.

3. **Run FastQC via command line (using `fastqc.exe`)**:  
   - Inside the extracted folder, you will see a file named `fastqc.exe` (or `fastqc`).  
   - Open **Command Prompt** (or **PowerShell**), navigate to the FastQC directory, and enter a command such as:
     ```bash
     fastqc C:\path\to\your\data\sample1.fastq C:\path\to\your\data\sample2.fastq
     ```
     **Note**: On Windows, you might need to run `fastqc.exe` directly, or include the `.exe` extension if it’s not recognized automatically.

---

## 3. Analyzing an Entire Folder of FASTQ Files with `RUN_FastQC_Windows.R`
Use the R script in **this repository** named `RUN_FastQC_Windows.R` that runs FastQC on all FASTQ files within a specified folder:

1. **Open the script `RUN_FastQC_Windows.R`** in any text editor (e.g., RStudio or Notepad).

2. **Modify the following within the script**:
   - **FastQC executable path**: Point this variable to the location of **your** `fastqc.exe`.  
     *(The path below is **only an example**; replace it with the actual location of the FastQC executable on your system.)*
     ```r
     fastqc_path <- "C:/Tools/FastQC/fastqc.exe"   # ← example path
     ```

   - **Target folder path**: Update the folder path containing your FASTQ files.  
     ```r
     data_folder <- "C:/Data/FASTQ_Files/"  # ← example path
     ```

   - **(Optional) Customise FastQC thresholds**:  
     To adjust the **PASS / WARN / FAIL cut-offs** used by FastQC, edit  
     `C:/Tools/FastQC/Configuration/limits.txt`  
     (i.e. the **`limits.txt`** file inside `<FastQC_install_dir>\Configuration`).  
     Save the file and rerun FastQC to apply the new thresholds.
     

3. **Run the script** in R or RStudio (or use `Rscript` from the command line):
   ```bash
   Rscript RUN_FastQC_Windows.R

This script will execute FastQC on every `.fastq.gz` file found in the designated folder.

---

## 4. Summarizing Results with `Sum_FastQC.R`
After running FastQC on all your FASTQ files, you can use the script `Sum_FastQC.R` to **automatically parse** each `_fastqc.zip` result, extract the **`summary.txt`** files inside, and **consolidate** all QC metrics into a single table. The script then:

- **Transforms** the data into a *wide-format* spreadsheet (with metrics as rows and sample names as columns).  
- **Exports** a standard CSV file (e.g., `FastQC_summary.csv`) for easy viewing.  
- **Generates** a color-coded Excel file (e.g., `FastQC_summary_colored.xlsx`) where **PASS**, **FAIL**, and **WARN** cells are highlighted in different colors (green, red, and orange, respectively).  

This consolidated summary allows you to quickly assess each QC metric’s status across all samples, without having to open individual FastQC reports.

<img src="https://github.com/Charlene717/FastQC-on-Windows/blob/main/www/2025021705QRF_FastQC_summary_colored_Cut.png?raw=true" alt="FastQC_summary_colored" width="1000"/>

If you set `Set_DataType` to **`"Bulk RNA-seq"`**, the script will also generate a table that **categorizes and ranks FastQC metrics by their importance for Bulk RNA-seq experiments**, making it easier for users to interpret QC priorities at a glance.  
For the recommended thresholds and the rationale behind the importance ranking of each FastQC metric in Bulk RNA-seq, please refer to:  
[FastQC Threshold Recommendations for Bulk RNA-seq ↗][bulk]

---

## 5. Adjusting Thresholds in `limits.txt`
If you need to change the default thresholds for QC indicators (e.g., minimum quality score, adapter contamination limits), you can modify the `limits.txt` file:

1. **Locate the configuration folder** in your FastQC installation. It may be at:
   ```ruby
   C:\Tools\FastQC\fastqc_v0.12.1\FastQC\Configuration\limits.txt
(Adjust the path as needed, depending on where you extracted FastQC.)

2. Open `limits.txt` in a text editor.  
3. Find the parameter(s) you need to change and edit their values (e.g., minimum per-base quality, maximum adapter contamination threshold).  
4. Save the file, and re-run FastQC to apply the new thresholds.

---

## 6. Additional Tips
- **Check Java installation**: If FastQC fails to launch, verify that Java is installed and that its path is correctly set in your system environment variables.
- **GUI mode (optional)**: In some FastQC distributions for Windows, there is a `.bat` file (e.g., `fastqc.bat`). Double-clicking this can open a simple graphical interface, which allows you to select files manually.
- **FastQC outputs**: By default, FastQC creates a `*_fastqc.html` summary report and a `*_fastqc.zip` file for each input FASTQ. You can open the `.html` in any web browser to see the graphical summary.

<!-- ------ 連結集中放在文末 ------ -->
[bulk]: https://github.com/Charlene717/FastQC-on-Windows/blob/main/Introduction%20of%20fastqc/FastQC%20Threshold%20Recommendations%20for%20Bulk%20RNA-seq.md
