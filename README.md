# Operating FastQC on Windows

This guide provides step-by-step instructions for downloading, installing, and running FastQC on a Windows system. It also explains how to batch-process multiple FASTQ files and summarize results, as well as how to adjust quality control thresholds according to your needs.

---

## 1. Prerequisites

- **FastQC**: Download from the official website:  
  [https://www.bioinformatics.babraham.ac.uk/projects/fastqc/](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)
- **Java Runtime Environment (JRE)**: Ensure you have a suitable Java Runtime Environment installed. FastQC generally requires Java 11 or later, though newer versions are usually compatible. Check your Java version by opening a terminal (Command Prompt) and typing:
  ```bash
  java -version
