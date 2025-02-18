# How to Operate FastQC on Windows

## 1. Download FastQC and Java
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

## 3. Analyzing an Entire Folder of FASTQ Files
If you have an R script in **this repository** named `RUN_FastQC_Windows.R` that runs FastQC on all FASTQ files within a specified folder:

1. **Open the script `RUN_FastQC_Windows.R`** in any text editor (e.g., RStudio or Notepad).

2. **Modify the following within the script**:
   - **FastQC executable path**: Ensure the script points to the `fastqc.exe` file inside your extracted FastQC folder.  
     ```r
     fastqc_path <- "C:/Tools/FastQC/fastqc.exe"
     ```
   - **Target folder path**: Update the folder path containing your FASTQ files.  
     ```r
     data_folder <- "C:/Data/FASTQ_Files/"
     ```

3. **Run the script** in R or RStudio (or use `Rscript` from the command line):
   ```bash
   Rscript RUN_FastQC_Windows.R

This script will execute FastQC on every `.fastq.gz` file found in the designated folder.

---

## 4. Summarizing Results with `Sum_FastQC.R`
After running FastQC on all your FASTQ files, use the script `Sum_FastQC.R` to consolidate the results.

1. **Open `Sum_FastQC.R`** in your text editor or RStudio.  
2. **Run the script** (via RStudio or `Rscript`). It will:
   - Check each FASTQ file’s FastQC outputs.
   - Gather various quality control (QC) indicators (e.g., per-base quality, adapter content).
   - Report which files have passed or failed each QC indicator.

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


