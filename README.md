# How to Operate FastQC on Windows

## 1. Download FastQC and Java
1. **Download FastQC** from the official website:  
   [https://www.bioinformatics.babraham.ac.uk/projects/fastqc/](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)  
2. **Install a suitable Java Runtime Environment (JRE)**. You can find a link to a suitable Java version on the FastQC website, or you can install any standard JRE (version 1.8 or above should work).

## 2. Manual File Import and Execution
1. **Extract the FastQC zip file** to any convenient location on your computer.  
   For example: `C:\Tools\FastQC`
2. Inside the extracted folder, you will see a file named `fastqc` (or `fastqc.exe`) along with other supporting files.
3. You can run FastQC on a single file or multiple files by opening **Command Prompt** (or **PowerShell**), navigating to the FastQC directory, and entering a command such as:
   ```bash
   fastqc C:\path\to\your\data\sample1.fastq C:\path\to\your\data\sample2.fastq
