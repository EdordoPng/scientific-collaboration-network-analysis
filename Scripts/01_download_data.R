# ==============================================================================
# Script 01: Download arXiv Collaboration Network Dataset
# Automatically creates directories if missing
# ==============================================================================

library(igraph)

cat("=== Downloading arXiv GR-QC Collaboration Network ===\n\n")

# Create directories (recursive, no warnings if exist)
cat("Checking directory structure...\n")
dir.create("data/raw", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("output/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("output/reports", recursive = TRUE, showWarnings = FALSE)
cat("✓ Directories ready\n\n")

# Dataset URL
url <- "https://snap.stanford.edu/data/ca-GrQc.txt.gz"
dest_file <- "data/raw/ca-GrQc.txt.gz"

# Download if not exists
if (!file.exists(dest_file)) {
  cat("📥 Downloading from SNAP...\n")
  tryCatch({
    download.file(url, dest_file, mode = "wb", quiet = TRUE)
    cat("✓ Downloaded:", dest_file, "\n")
  }, error = function(e) {
    stop("❌ Download failed: ", e$message)
  })
} else {
  cat("✓ File already exists:", dest_file, "\n")
}

# Decompress if not exists
txt_file <- "data/raw/ca-GrQc.txt"
if (!file.exists(txt_file)) {
  cat("\n📦 Decompressing...\n")
  tryCatch({
    # Cross-platform decompression
    if (.Platform$OS.type == "windows") {
      R.utils::gunzip(dest_file, destname = txt_file, remove = FALSE)
    } else {
      system(paste("gunzip -k", dest_file))
    }
    cat("✓ Decompressed:", txt_file, "\n")
  }, error = function(e) {
    stop("❌ Decompression failed: ", e$message)
  })
} else {
  cat("✓ File already decompressed:", txt_file, "\n")
}

# Load as igraph object
cat("\n📊 Loading network...\n")
g <- read_graph(txt_file, format = "edgelist", directed = FALSE)

# Basic stats
cat("\n=== Network Summary ===\n")
cat("Nodes (authors):", vcount(g), "\n")
cat("Edges (collaborations):", ecount(g), "\n")
cat("Density:", round(edge_density(g), 6), "\n")
cat("Connected:", is_connected(g), "\n")
cat("Components:", components(g)$no, "\n")

# Ensure processed directory exists before saving
if (!dir.exists("data/processed")) {
  dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
}

# Save as RDS for faster loading
output_file <- "data/processed/network.rds"
saveRDS(g, output_file)
cat("\n✓ Network saved to:", output_file, "\n")

cat("\n=== Download and preparation complete ===\n")
