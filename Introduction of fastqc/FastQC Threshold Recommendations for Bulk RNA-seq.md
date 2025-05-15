# FastQC Threshold Recommendations for Bulk RNA-seq (Illumina / **Homo sapiens**)

> **Three priority tiers**  
> * 🟥 **Critical review** – keep default/recommended thresholds; any *WARN/FAIL* **needs special attention**  
> * 🟧 **Relaxed for RNA-seq** – warnings require contextual interpretation; thresholds can be loosened if biologically reasonable  
> * ⬜ **Can be ignored** – normally disabled; enable only for troubleshooting  

---

## 🟥 Critical review

### 1. Basic Statistics  <sup>[<a href="#ref2">2</a>][<a href="#ref13">13</a>]</sup>
* **Enabled** (no warn/error values)  
* **Rationale:** Summarizes read count, read length and GC %; quickly detects missing samples, insert-length mismatches or GC shifts. ENCODE recommends ≥ 30 M aligned reads per replicate for bulk RNA-seq.  
* **Action:** If read count is far below target or GC % deviates from the human average (~41 %) by > 10 pp, investigate immediately.  

### 2. Adapter Content  <sup>[<a href="#ref9">9</a>]</sup>
* **Thresholds:** `warn > 5 %`; `error > 10 %` (default)  
* **Rationale:** Residual adapters lower mapping rates and create false positives.  
* **Action:** Any *WARN* → trim adapters (Cutadapt/Trim Galore) and rerun QC.  

### 3. Per Base Sequence Quality  <sup>[<a href="#ref3">3</a>]</sup>
* **Thresholds:** Median < Q25 **or** lower-quartile < Q10 → *WARN*; Median < Q20 **or** LQ < Q5 → *FAIL*  
* **Rationale:** Ensures most cycles reach Q30; severe tail drop below Q20 should be trimmed.  
* **Action:** *FAIL* ⇒ quality trimming or resequencing.  

### 4. Per Sequence Quality Scores  <sup>[<a href="#ref4">4</a>][<a href="#ref16">16</a>]</sup>
* **Thresholds:** Mode < Q27 → *WARN*; Mode < Q20 → *FAIL*  
* **Rationale:** A low modal read quality signals global instrument or sample degradation.  

### 5. Per Base N Content  <sup>[<a href="#ref7">7</a>][<a href="#ref16">16</a>]</sup>
* **Thresholds:** Any position N > 5 % → *WARN*; > 20 % → *FAIL*  
* **Rationale:** Illumina reads should contain virtually no N; N peaks indicate sequencing-chemistry failure.  

### 6. Over-represented Sequences  <sup>[<a href="#ref8">8</a>]</sup>
* **Thresholds:** Single sequence > 0.1 % → *WARN*; > 1 % → *FAIL*  
* **Rationale:** Flags adapter dimers, rRNA contamination or foreign sequences.  
* **Action:** Identify the origin; remove technical sequences.  

---

## 🟧 Relaxed for RNA-seq

### 7. Sequence Duplication Levels  <sup>[<a href="#ref10">10</a>]</sup>
* **Thresholds:** *WARN* > 20 % / *FAIL* > 50 % (defaults, interpret flexibly)  
* **Rationale:** Highly expressed transcripts naturally create duplicates.  

### 8. Per Base Sequence Content  <sup>[<a href="#ref5">5</a>][<a href="#ref14">14</a>]</sup>
* **Thresholds:** Δ10 % → *WARN*; Δ20 % → *FAIL*  
* **Rationale:** Random hexamer priming causes A/T/C/G imbalance in the first 10–12 bp.  

### 9. Per Sequence GC Content  <sup>[<a href="#ref6">6</a>][<a href="#ref15">15</a>]</sup>
* **Thresholds:** 15 % deviation → *WARN*; 30 % → *FAIL*  
* **Rationale:** Bimodal or extreme GC shifts suggest contamination or fragment-selection bias.  

### 10. Sequence Length Distribution  <sup>[<a href="#ref11">11</a>]</sup>
* **Thresholds:** non-uniform length = *WARN*; 0-bp reads = *FAIL*  
* **Rationale:** Raw data should be fixed length; variable length is normal after trimming.  

---

## ⬜ Can be ignored

### 11. Per Tile Sequence Quality  <sup>[<a href="#ref12">12</a>][<a href="#ref17">17</a>]</sup>
* **Recommendation:** Minor tile deviations can be ignored; large, persistent failures should be escalated to the sequencing facility.  

### 12. K-mer Content  <sup>[<a href="#ref1">1</a>][<a href="#ref14">14</a>]</sup>
* **Recommendation:** Disabled by default; enable only for sleuthing unknown contaminants.  
* **Rationale:** 5′ bias from hexamer priming always triggers warnings; specificity is low.  

---

## Summary Table

| Module | Tier | Recommended Setting (ignore / warn / error) | Key Rationale |
|---|---|---|---|
| Basic Statistics | 🟥 Critical review | Enable; no thresholds | Core summary: reads & GC % |
| Adapter Content | 🟥 | 0 / 5 % / 10 % | Adapters hurt mapping |
| Per Base Seq Quality | 🟥 | 0 / Q10·25 / Q5·20 | Cycle-level quality |
| Per Sequence Qual Scores | 🟥 | 0 / Q27 / Q20 | Read-level quality |
| Per Base N Content | 🟥 | 0 / 5 % / 20 % | N = chemistry failure |
| Over-represented Seqs | 🟥 | 0 / 0.1 % / 1 % | Contaminants/adapters |
| Sequence Duplication | 🟧 Relaxed | 0 / 20 % / 50 % | Highly expressed genes |
| Per Base Seq Content | 🟧 | 0 / Δ10 % / Δ20 % | Hexamer bias |
| Per Seq GC Content | 🟧 | 0 / 15 % / 30 % | GC bimodality |
| Seq Length Dist. | 🟧 | 0 / 1 / 1 | Variable after trimming |
| Per Tile Seq Quality | ⬜ Ignore | 1 (ignore) | Minor tile issues |
| K-mer Content | ⬜ | 1 (ignore) | Low specificity |

---

## References

<a id="ref1"></a>1. Andrews S. **FastQC – A Quality Control Tool for High Throughput Sequence Data** (2010). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/>  

<a id="ref2"></a>2. Babraham Bioinformatics. **FastQC – Basic Statistics** (Module 1). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/1%20Basic%20Statistics.html>  

<a id="ref3"></a>3. Babraham Bioinformatics. **FastQC – Per Base Sequence Quality** (Module 2). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/2%20Per%20Base%20Sequence%20Quality.html>  

<a id="ref4"></a>4. Babraham Bioinformatics. **FastQC – Per Sequence Quality Scores** (Module 3). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/3%20Per%20Sequence%20Quality%20Scores.html>  

<a id="ref5"></a>5. Babraham Bioinformatics. **FastQC – Per Base Sequence Content** (Module 4). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/4%20Per%20Base%20Sequence%20Content.html>  

<a id="ref6"></a>6. Babraham Bioinformatics. **FastQC – Per Sequence GC Content** (Module 5). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/5%20Per%20Sequence%20GC%20Content.html>  

<a id="ref7"></a>7. Babraham Bioinformatics. **FastQC – Per Base N Content** (Module 6). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/6%20Per%20Base%20N%20Content.html>  

<a id="ref8"></a>8. Babraham Bioinformatics. **FastQC – Overrepresented Sequences** (Module 14). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/14%20Overrepresented%20Sequences.html>  

<a id="ref9"></a>9. Babraham Bioinformatics. **FastQC – Adapter Content** (Module 10). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/10%20Adapter%20Content.html>  

<a id="ref10"></a>10. Babraham Bioinformatics. **FastQC – Sequence Duplication Levels** (Module 12). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/12%20Sequence%20Duplication%20Levels.html>  

<a id="ref11"></a>11. Babraham Bioinformatics. **FastQC – Sequence Length Distribution** (Module 7). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/7%20Sequence%20Length%20Distribution.html>  

<a id="ref12"></a>12. Babraham Bioinformatics. **FastQC – Per Tile Sequence Quality** (Module 11). <https://www.bioinformatics.babraham.ac.uk/projects/fastqc/Help/3%20Analysis%20Modules/11%20Per%20Tile%20Sequence%20Quality.html>  

<a id="ref13"></a>13. ENCODE Consortium. **ENCODE4 Bulk RNA-seq Data Standards and Pipeline** (2021). <https://www.encodeproject.org/about/experiment-guidelines/>  

<a id="ref14"></a>14. Hansen KD *et al.* **Biases in Illumina transcriptome sequencing caused by random hexamer priming**. *Nucleic Acids Res.* 2010;38:e131. doi:[10.1093/nar/gkq224](https://doi.org/10.1093/nar/gkq224)  

<a id="ref15"></a>15. Conesa A *et al.* **A survey of best practices for RNA-seq data analysis**. *Genome Biol.* 2016;17:13. doi:[10.1186/s13059-016-0881-8](https://doi.org/10.1186/s13059-016-0881-8)  

<a id="ref16"></a>16. Sheng Q *et al.* **Multi-perspective quality control of Illumina RNA sequencing data**. *Brief. Bioinform.* 2017;18:434-443. doi:[10.1093/bib/bbw073](https://doi.org/10.1093/bib/bbw073)  

<a id="ref17"></a>17. Dragana D *et al.* **Demystification of RNA-seq Quality Control**. *Journal of IT and Applications* 2021;11:73-86. <https://doi.org/10.5281/zenodo.5075546>
