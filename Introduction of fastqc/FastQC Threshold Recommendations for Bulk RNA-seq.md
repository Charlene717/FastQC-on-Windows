# FastQC Threshold Recommendations for Bulk RNA-seq (Illumina / **Homo sapiens**)

> **Three priority tiers**  
  > * 🟥 **Critical review** – keep default/recommended thresholds; any *WARN/FAIL* demands immediate action  
> * 🟧 **Relaxed for RNA-seq** – warnings require contextual interpretation; thresholds can be loosened if biologically reasonable  
> * ⬜ **Can be ignored** – normally disabled; enable only for troubleshooting  

---
  
  ## 🟥 Critical review
  
  ### 1. Basic Statistics   <sup>[2]</sup><sup>, [7]</sup>
  * **Enabled** (no warn/error values)  
* **Rationale:** Summarizes read count, read length, GC %, etc., letting you quickly detect missing samples, insert-length mismatches, or GC shifts. ENCODE recommends ≥ 30 M aligned reads per replicate for bulk RNA-seq.  
* **Action:** If read count is far below target or GC % deviates from the human average (~41 %) by > 10 pp, investigate immediately.  

### 2. Adapter Content   <sup>[6]</sup>
* **Thresholds:** `warn > 5 %`; `error > 10 %` (default)  
* **Rationale:** Residual adapters lower mapping rates and create false positives.  
* **Action:** Any *WARN* → trim adapters (Cutadapt/Trim Galore) and rerun QC.  

### 3. Per Base Sequence Quality   <sup>[2]</sup><sup>, [3]</sup>
* **Thresholds:** Median < Q25 **or** lower-quartile < Q10 → *WARN*; Median < Q20 **or** LQ < Q5 → *FAIL*  
  * **Rationale:** Ensures most cycles reach Q30; severe tail drop below Q20 should be trimmed.  
* **Action:** *FAIL* ⇒ quality trimming or resequencing.  

### 4. Per Sequence Quality Scores   <sup>[2]</sup><sup>, [10]</sup>
* **Thresholds:** Mode < Q27 → *WARN*; Mode < Q20 → *FAIL*  
  * **Rationale:** Low modal read quality signals global instrument or sample degradation.  

### 5. Per Base N Content   <sup>[2]</sup><sup>, [10]</sup>
* **Thresholds:** Any position N > 5 % → *WARN*; > 20 % → *FAIL*  
  * **Rationale:** Illumina reads should contain virtually no N; N peaks indicate sequencing chemistry failure.  

### 6. Over-represented Sequences   <sup>[5]</sup>
* **Thresholds:** Single sequence > 0.1 % → *WARN*; > 1 % → *FAIL*  
  * **Rationale:** Flags adapter dimers, rRNA contamination, or foreign sequences.  
* **Action:** Identify the origin; remove technical sequences.  

---
  
  ## 🟧 Relaxed for RNA-seq
  
  ### 7. Sequence Duplication Levels   <sup>[4]</sup>
  * **Thresholds:** *WARN* > 20 % / *FAIL* > 50 % (defaults, interpret flexibly)  
* **Rationale:** Highly expressed transcripts naturally create duplicates.  

### 8. Per Base Sequence Content   <sup>[3]</sup><sup>, [8]</sup>
* **Thresholds:** Δ10 % → *WARN*; Δ20 % → *FAIL*  
  * **Rationale:** Random hexamer priming causes A/T/C/G imbalance in the first 10–12 bp.  

### 9. Per Sequence GC Content   <sup>[3]</sup><sup>, [9]</sup>
* **Thresholds:** 15 % deviation → *WARN*; 30 % → *FAIL*  
  * **Rationale:** Bimodal or extreme GC shifts suggest contamination or fragment-selection bias.  

### 10. Sequence Length Distribution   <sup>[2]</sup>
* **Thresholds:** non-uniform length = *WARN*; 0-bp reads = *FAIL*  
  * **Rationale:** Raw data should be fixed-length; variable length is normal after trimming.  

---
  
  ## ⬜ Can be ignored
  
  ### 11. Per Tile Sequence Quality   <sup>[2]</sup><sup>, [11]</sup>
  * **Recommendation:** Minor tile deviations can be ignored; large, persistent failures should be escalated to the sequencing facility.  

### 12. K-mer Content   <sup>[1]</sup><sup>, [8]</sup>
* **Recommendation:** Disabled by default; enable only for sleuthing unknown contaminants.  
* **Rationale:** 5′ bias from hexamer priming always trips warnings; specificity is low.  

---
  
  ## Summary Table
  
  | Module | Tier | Recommended Setting (ignore / warn / error) | Key Rationale |
  |---|---|---|---|
  | Basic Statistics | 🟥 Critical review | Enable; no thresholds | Core summary: reads & GC % |
  | Adapter Content | 🟥 | 0 / 5 % / 10 % | Adapters hurt mapping |
  | Per Base Seq Quality | 🟥 | 0 / Q10·25 / Q5·20 | Cycle-level quality |
  | Per Sequence Qual Scores | 🟥 | 0 / Q27 / Q20 | Read-level quality |
  | Per Base N Content | 🟥 | 0 / 5 % / 20 % | N = signal failure |
  | Over-represented Seqs | 🟥 | 0 / 0.1 % / 1 % | Contaminants/adapters |
  | Sequence Duplication | 🟧 Relaxed | 0 / 20 % / 50 % | Highly expressed genes |
  | Per Base Seq Content | 🟧 | 0 / Δ10 % / Δ20 % | Hexamer bias |
  | Per Seq GC Content | 🟧 | 0 / 15 % / 30 % | GC bimodality |
  | Seq Length Dist. | 🟧 | 0 / 1 / 1 | Variable after trimming |
  | Per Tile Seq Quality | ⬜ Ignore | 1 (ignore) | Minor tile issues |
  | K-mer Content | ⬜ | 1 (ignore) | Low specificity |
    
  ---
    
  ## References
    
  1. Andrews S. **FastQC – A Quality Control Tool for High Throughput Sequence Data** (2010). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/>  
  2. Babraham Bioinformatics. **FastQC Documentation – Basic & Quality Modules** (accessed 2025-05-15). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/>  
  3. Babraham Bioinformatics. **FastQC Documentation – Per Base/Sequence Content & GC** (accessed 2025-05-15). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/>  
  4. Babraham Bioinformatics. **FastQC Documentation – Sequence Duplication Levels** (accessed 2025-05-15). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/>  
  5. Babraham Bioinformatics. **FastQC Documentation – Overrepresented Sequences** (accessed 2025-05-15). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/>  
  6. Babraham Bioinformatics. **FastQC Documentation – Adapter Content** (accessed 2025-05-15). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/>  
  7. ENCODE Consortium. **ENCODE4 Bulk RNA-seq Data Standards and Pipeline** (2021). <https://www.encodeproject.org/about/experiment-guidelines/>  
  8. Hansen KD *et al.* Biases in Illumina transcriptome sequencing caused by random hexamer priming. *Nucleic Acids Res.* 2010;38:e131. doi:[10.1093/nar/gkq224](https://doi.org/10.1093/nar/gkq224)  
  9. Conesa A *et al.* A survey of best practices for RNA-seq data analysis. *Genome Biol.* 2016;17:13. doi:[10.1186/s13059-016-0881-8](https://doi.org/10.1186/s13059-016-0881-8)  
  10. Sheng Q *et al.* Multi-perspective quality control of Illumina RNA sequencing data. *Brief. Bioinform.* 2017;18:434-443. doi:[10.1093/bib/bbw073](https://doi.org/10.1093/bib/bbw073)  
  11. Dragana D *et al.* Demystification of RNA-seq Quality Control. *Journal of IT and Applications* 2021;11:73-86. <https://doi.org/10.5281/zenodo.5075546>
    