# TB-Profiler-Workshop
A hands-on TB-Profiler workshop materials for genomic drug resistance prediction, lineage assignment, surveillance and bioinformatics training on *Mycobacterium tuberculosis*.

- This training material was first developed for the PANGenS consortium https://pangens.org/ 
  
---

## Learning Objectives

By the end of this workshop participants will be able to:

- Install TB-Profiler
- Download sequencing data from NCBI/ENA
- Run TB-Profiler on WGS datasets
- Interpret lineage assignments
- Interpret drug resistance predictions
- Understand WHO confidence categories
- Generate summary reports
- Perform batch analyses

---

## Overview
To maximize hands-on training time during the workshop, all participants are requested to complete the software installation steps before the training session.

Please complete the installation at least 2–3 days before the workshop so that any issues can be resolved in advance.

---

# 1. System Requirements

| Component | Minimum | Recommended |
|------------|------------|------------|
| RAM | 8 GB | 16 GB+ |
| Disk Space | 50 GB | 100 GB+ |
| Internet | Stable | High Speed |
| OS | Windows/Linux/macOS | Latest Version |

## Important Notes
- Administrative privileges may be required for software installation.
- Ensure your computer can remain connected to the internet during installation.
- Windows users should install WSL (Windows Subsystem for Linux).
- Linux and macOS users may proceed directly to Section 2.2.

---

# 2. Installation Guide

## 2.1 Windows Users

Install WSL:

Open PowerShell as Administrator and copy past the command below. Hit the enter key to run the command.

```bash
wsl --install
```

This will automatically install:
- Windows Subsystem for Linux
- Ubuntu Linux
- Required virtualization components


Restart your computer.

A restart is required after installation.

Launch Ubuntu:

Open Ubuntu from the Start Menu.
You will be prompted to create:
- Linux username
- Linux password
Keep these credentials safe.


Verify:

```bash
wsl --status
```

You should see information indicating that WSL has been installed successfully.

---

## 2.2 Install Miniforge (Recommended)

Download:

```bash
wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh
```

Install:

```bash
bash Miniforge3-Linux-x86_64.sh
```

Accept the default options and answer:
yes
when prompted.

Restart Terminal

```bash
exit
```

Open a new terminal.


Configure channels:

```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
```

---

## 2.3 Install Mamba if you already have miniconda and are not willing to install miniforge from above 

```bash
conda install -n base -c conda-forge mamba
```

---

## 2.4 Install TB-Profiler

Create environment:

```bash
mamba create -n tbprofiler -c conda-forge -c bioconda tb-profiler
```

Activate:

```bash
conda activate tbprofiler
```

Verify:

```bash
tb-profiler
```

Update database:

```bash
tb-profiler update_tbdb
```

You can check the version of the database with the below command:

```bash
tb-profiler list_db
```

Deactivate tbprofiler:

```bash
mamba deactivate
```

---

## 2.5 Navigate to your working directory/folder

### Navigate to your “Documents” folder and start working.
#### Replace “<insert-pc-user-name>” with your pc name or user name.

```bash
cd /mnt/c/Users/<insert-pc-user-name>/Documents/
```

#### Once in your Documents folder, make/create a directory/folder called “tbdr_profiling” and navigate into that folder

```bash
mkdir tbdr_profiling
cd tbdr_profiling
```

## 2.6 Install SRA Tools

Create Environment:

```bash
mamba create -n sra -c bioconda sra-tools pigz parallel
```

Activate:

```bash
mamba activate sra
```

Verify:

```bash
fasterq-dump --help
```

---

# 3. Download Example Genomes

Create file:

samples.txt

Example:

```text
ERR2704679
ERR5987300
ERR6362078
```

Create directory:

```bash
mkdir fastq
```

Download:

```bash
cat samples.txt | parallel -j 10 \
'fasterq-dump {} --split-files --threads 4 -O fastq/'
```

Compress:

```bash
pigz fastq/*.fastq
```

Deactivate sra:

```bash
mamba deactivate sra
```

---

# 4. Run TB-Profiler

Create results folder:

```bash
mkdir tbprofiler_results
```

Activate TB-Profiler:

```bash
mamba activate tbprofiler
```

## 4.1 Run TB-Profiler on 1 sample

```bash
tb-profiler profile \
-1 fastq/ERR5987300_1.fastq.gz \
-2 fastq/ERR5987300_2.fastq.gz \
-p ERR5987300 \
--csv \
--txt \
--dir tbprofiler_results/
```

---

## 4.2 Run TB-Profiler on Multiple Samples Using Batch Analysis

### 4.2.1 First create a Sample Sheet from the downloaded FASTQ Files

Bash Method:

```bash
echo "id,read1,read2" > samplesheet.csv

for i in fastq/*_1.fastq.gz
do
sample=${i%_1.fastq.gz}
echo "$sample,$(readlink -f $i),$(readlink -f ${sample}_2.fastq.gz)" >> samplesheet.csv
done
```

Python Method. Download the python script here:

```bash
python3 fastq_dir_to_samplesheet.py ./fastq samplesheet.csv
```

Run batch TB-Profiler:

```bash
tb-profiler batch \
--csv samplesheet.csv \
--jobs 4 \
--threads_per_job 8 \
--dir tbprofiler_results/
```

---

# 5 Summarize TB-Profiler Results

## 5.1 Create summary directory and navigate into it.

```bash
cd tbprofiler_results
mkdir summary
cd summary
```

## 5.2 Simple summary:

```bash
tb-profiler collate \
--prefix tbprofiler_collate \
--dir ../
```

## 5.3 Extended summary:

```bash
tb-profiler collate \
--prefix tbprofiler_collate_full \
--dir ../ \
--full \
--all_variants \
--mark_missing
```

### 5.4 Generate iTOL Files

```bash
tb-profiler collate --itol
```

---

# 6. Common Problems

`Command not found`

Restart terminal and reactivate environment.
conda activate tbprofiler

`Conda not recognized`

Restart terminal after installation.

`WSL installation fails`

Ensure virtualization is enabled in BIOS.

`Out of disk space`

Remove unnecessary files and ensure >50 GB free space.

---

# 7. What to Bring to the Workshop

- Laptop with or without completed installation
- Administrator access to your computer
- Charger and power adapter
- Stable internet connection
- Example FASTQ files (if available)

---

# 8. Expected Outcome
Before arriving at the workshop, every participant should be able to run:
tb-profiler --help
without errors.

---

# 9. Useful Links

- TB-Profiler Documentation: https://jodyphelan.github.io/tb-profiler-docs/
- TB-Profiler GitHub: https://github.com/jodyphelan/TBProfiler
- Bioconda: https://bioconda.github.io/
- Conda Forge: https://conda-forge.org/

---

# 10. Instructor

Dr. Prince Asare  
Department of Bacteriology  
Noguchi Memorial Institute for Medical Research, College of Health Sciences, 
University of Ghana
