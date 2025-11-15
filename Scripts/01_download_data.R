# ==============================================================================
# Script 01: Download and Filter AMiner Citation Network Dataset
# Creates a manageable co-authorship network from selected venues
# ==============================================================================

library(dplyr)
library(tidyr)
library(jsonlite)
library(readr)
library(stringr)

cat("=== Downloading AMiner Citation Network Dataset ===\n\n")

# Create directories
cat("Checking directory structure...\n")
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)
cat("✓ Directories ready\n\n")

# ==============================================================================
# STEP 1: Download AMiner V1 dataset (DBLP subset)
# ==============================================================================

url <- "https://lfs.aminer.cn/lab-datasets/citation/dblp.v8.json"
dest_file <- "data/raw/dblp_v8.json"

if (!file.exists(dest_file)) {
  cat("📥 Downloading AMiner DBLP dataset...\n")
  cat("   URL:", url, "\n")
  cat("   Warning: Large file (~1.5 GB), may take 5-15 minutes\n\n")
  
  tryCatch({
    download.file(url, dest_file, mode = "wb", quiet = FALSE)
    cat("✓ Download complete\n\n")
  }, error = function(e) {
    cat("❌ Download failed:", e$message, "\n")
    cat("Please download manually from: https://www.aminer.org/citation\n")
    stop("Cannot proceed without data file")
  })
} else {
  cat("✓ Dataset already downloaded\n\n")
}

# ==============================================================================
# STEP 2: Parse JSON and filter by venue
# ==============================================================================

cat("📖 Reading and filtering dataset...\n")
cat("   This may take 3-5 minutes for large file\n\n")

# Define target venues for diversity
selected_venues <- c(
  # AI/ML (top tier)
  "NIPS", "NeurIPS", "ICML", "ICLR", "CVPR", "ICCV",
  
  # NLP
  "ACL", "EMNLP", "NAACL",
  
  # Database
  "VLDB", "SIGMOD",
  
  # Theory
  "STOC", "FOCS",
  
  # Systems
  "OSDI", "SOSP"
)

# Time window
year_start <- 2015
year_end <- 2020

cat("Filtering criteria:\n")
cat("  Venues:", paste(selected_venues, collapse = ", "), "\n")
cat("  Years:", year_start, "-", year_end, "\n\n")

# Read JSON line by line (memory efficient)
papers_filtered <- data.frame()
n_lines <- 0
n_kept <- 0

tryCatch({
  con <- file(dest_file, "r")
  
  while(TRUE) {
    line <- readLines(con, n = 1, warn = FALSE)
    if(length(line) == 0) break
    
    n_lines <- n_lines + 1
    
    # Progress indicator
    if(n_lines %% 10000 == 0) {
      cat("\r   Processed:", n_lines, "papers | Kept:", n_kept, "      ")
      flush.console()
    }
    
    # Parse JSON
    tryCatch({
      paper <- fromJSON(line, simplifyVector = FALSE)
      
      # Check venue and year
      venue <- ifelse(is.null(paper$venue), "", paper$venue)
      year <- ifelse(is.null(paper$year), 0, as.integer(paper$year))
      
      if(venue %in% selected_venues && year >= year_start && year <= year_end) {
        # Extract relevant fields
        paper_data <- data.frame(
          paper_id = ifelse(is.null(paper$id), NA, paper$id),
          title = ifelse(is.null(paper$title), NA, paper$title),
          year = year,
          venue = venue,
          n_citation = ifelse(is.null(paper$n_citation), 0, paper$n_citation),
          stringsAsFactors = FALSE
        )
        
        # Extract authors (list of IDs and names)
        if(!is.null(paper$authors) && length(paper$authors) > 0) {
          author_ids <- sapply(paper$authors, function(a) {
            ifelse(is.null(a$id), paste0("temp_", a$name), a$id)
          })
          author_names <- sapply(paper$authors, function(a) {
            ifelse(is.null(a$name), "Unknown", a$name)
          })
          
          paper_data$authors <- I(list(author_ids))
          paper_data$author_names <- I(list(author_names))
          
          papers_filtered <- rbind(papers_filtered, paper_data)
          n_kept <- n_kept + 1
        }
      }
    }, error = function(e) {
      # Skip malformed lines
    })
  }
  
  close(con)
  cat("\n✓ Filtering complete\n\n")
  
}, error = function(e) {
  cat("\n❌ Error reading file:", e$message, "\n")
  stop("Cannot parse dataset")
})

cat("Dataset statistics:\n")
cat("  Total papers processed:", n_lines, "\n")
cat("  Papers in selected venues/years:", nrow(papers_filtered), "\n\n")

if(nrow(papers_filtered) == 0) {
  stop("❌ No papers found matching criteria. Check venue names or year range.")
}

# Save filtered papers
saveRDS(papers_filtered, "data/processed/papers_filtered.rds")
cat("✓ Filtered papers saved to: data/processed/papers_filtered.rds\n\n")

# ==============================================================================
# STEP 3: Extract active authors (≥3 papers)
# ==============================================================================

cat("📊 Identifying active authors...\n\n")

# Unnest authors
authors_papers <- papers_filtered %>%
  select(paper_id, authors) %>%
  unnest(authors) %>%
  rename(author_id = authors)

# Count papers per author
author_counts <- authors_papers %>%
  group_by(author_id) %>%
  summarise(n_papers = n_distinct(paper_id), .groups = "drop") %>%
  arrange(desc(n_papers))

cat("Author productivity distribution:\n")
cat("  Total unique authors:", nrow(author_counts), "\n")
cat("  Authors with ≥10 papers:", sum(author_counts$n_papers >= 10), "\n")
cat("  Authors with ≥5 papers:", sum(author_counts$n_papers >= 5), "\n")
cat("  Authors with ≥3 papers:", sum(author_counts$n_papers >= 3), "\n")
cat("  Authors with ≥2 papers:", sum(author_counts$n_papers >= 2), "\n\n")

# Keep only productive authors (≥3 papers)
min_papers <- 3
active_authors <- author_counts %>%
  filter(n_papers >= min_papers) %>%
  pull(author_id)

cat("Selected threshold: ≥", min_papers, "papers\n")
cat("Active authors:", length(active_authors), "\n\n")

# Save active authors
saveRDS(active_authors, "data/processed/active_authors.rds")
cat("✓ Active authors saved to: data/processed/active_authors.rds\n\n")

# ==============================================================================
# STEP 4: Summary
# ==============================================================================

cat("=== Download and filtering complete ===\n\n")
cat("Summary:\n")
cat("  Papers in target venues (", paste(year_start, "-", year_end), "):", 
    nrow(papers_filtered), "\n")
cat("  Active authors (≥", min_papers, "papers):", length(active_authors), "\n\n")

cat("Next step: Run '02_build_network.R' to construct co-authorship network\n")
