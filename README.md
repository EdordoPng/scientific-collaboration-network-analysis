# scientific-collaboration-network
Analisi della Rete di Collaborazioni Scientifiche (arXiv General Relativity)

# Analisi della Rete di Collaborazioni Scientifiche
Analisi della Rete di Collaborazioni Scientifiche (arXiv General Relativity)

│
├── README.md                           # Descrizione progetto, setup, istruzioni
├── .gitignore                          # File da ignorare (data/, output/, cache/)
├── LICENSE                             # MIT o altra licenza
│
├── data/                               # Cartella dati (aggiunta a .gitignore)
│   ├── raw/                            # Dati originali scaricati
│   │   └── ca-GrQc.txt                 # File edge list da SNAP
│   └── processed/                      # Dati processati/salvati
│       ├── network.rds                 # Oggetto igraph salvato
│       └── centrality_results.csv      # Risultati centralità
│
├── scripts/                            # Script R riutilizzabili
│   ├── 00_setup.R                      # Installa pacchetti, carica librerie
│   └── 01_download_data.R              # Download automatico dataset
│
├── analysis/                           # File R Markdown per ogni RQ
│   ├── 01_data_preparation.Rmd         # Caricamento e esplorazione dati
│   ├── 02_centrality_analysis.Rmd      # RQ1: Centralità (Degree, PageRank, etc.)
│   ├── 03_community_detection.Rmd      # RQ2: Community detection
│   ├── 04_resilience_analysis.Rmd      # RQ3: Percolation e resilience
│   ├── 05_small_world_analysis.Rmd     # RQ4: Small-world properties
│   ├── 06_similarity_analysis.Rmd      # RQ5: Similarity e heterogeneity
│   ├── 07_assortativity_analysis.Rmd   # RQ6: Assortativity
│   └── 08_power_law_analysis.Rmd       # RQ7: Power-law distribution
│
├── output/                             # Cartella output (aggiunta a .gitignore)
│   ├── figures/                        # Grafici salvati (.png, .pdf)
│   │   ├── network_plot.png
│   │   ├── centrality_comparison.png
│   │   └── community_detection.png
│   ├── tables/                         # Tabelle risultati (.csv)
│   │   ├── top_authors_centrality.csv
│   │   └── community_sizes.csv
│   └── reports/                        # HTML knittati da Rmd
│       ├── 01_data_preparation.html
│       ├── 02_centrality_analysis.html
│       └── ...
│
├── docs/                               # Documentazione extra
│   ├── project_plan.md                 # Piano progetto dettagliato
│   ├── research_questions.md           # Descrizione RQ e metodi
│   └── references.bib                  # Bibliografia (opzionale)
│
└── presentations/                      # Slide o report finale (opzionale)
    ├── final_presentation.Rmd          # Presentazione beamer/xaringan
    └── final_report.pdf                # Report finale knittato


# Scientific Collaboration Network Analysis

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Project Overview

This project analyzes the **arXiv General Relativity collaboration network** using network science methods to understand patterns of scientific collaboration.

**Dataset**: [SNAP ca-GrQc](https://snap.stanford.edu/data/ca-GrQc.html)  
**Period**: 1993-2003  
**Nodes**: 5,242 authors  
**Edges**: 14,496 collaborations

---

## Research Questions

1. **RQ1**: Who are the most influential researchers? (Centrality analysis)
2. **RQ2**: Are there distinct research communities? (Community detection)
3. **RQ3**: Is the network resilient to removal of key researchers? (Percolation)
4. **RQ4**: Does the network exhibit small-world properties? (Geodesic distances)
5. **RQ5**: Do researchers with similar collaboration patterns exist? (Similarity)
6. **RQ6**: Do highly connected researchers collaborate preferentially? (Assortativity)
7. **RQ7**: Does the degree distribution follow a power-law? (Scale-free networks)

---

## Project Structure

scientific-collaboration-network/
├── data/ # Raw and processed data
├── scripts/ # Setup and data download scripts
├── analysis/ # R Markdown analysis files (one per RQ)
├── output/ # Figures, tables, HTML reports
└── docs/ # Documentation


---

## Setup Instructions

### Prerequisites
- R (>= 4.0)
- RStudio (recommended)
- Required packages: `igraph`, `dplyr`, `ggplot2`, `tidyr`, `knitr`

### Installation

Clone repository
git clone https://github.com/yourusername/scientific-collaboration-network.git
cd scientific-collaboration-network

Install required packages
source("scripts/00_setup.R")

Download data
source("scripts/01_download_data.R")


---

## Usage

Run analyses in order:

1. Data preparation
rmarkdown::render("analysis/01_data_preparation.Rmd")

2. Centrality analysis
rmarkdown::render("analysis/02_centrality_analysis.Rmd")

... continue with other analyses


Or knit each `.Rmd` file individually in RStudio.

---

## Key Results

*(To be filled after analysis)*

- **Most influential authors**: [IDs from centrality analysis]
- **Number of communities detected**: [X communities]
- **Network resilience**: [Results from percolation]
- **Small-world coefficient**: [Value]

---

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file.

---

## Acknowledgments

- Dataset: Stanford Network Analysis Project (SNAP)
- Course: Advanced Data Science - Network Analysis
- Instructor: [Professor Name]

---

## Contact

**Author**: Edoardo Diana  
**Email**: your.email@example.com  
**GitHub**: [@yourusername](https://github.com/yourusername)
