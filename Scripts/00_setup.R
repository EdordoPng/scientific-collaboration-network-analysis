# ==============================================================================
# Script 00: Setup and Package Installation
# Checks for existing packages before installing
# ==============================================================================

cat("=== Checking and installing required packages ===\n\n")

packages <- c(
  "igraph",        # Network analysis
  "dplyr",         # Data manipulation
  "ggplot2",       # Visualization
  "tidyr",         # Data tidying
  "knitr",         # R Markdown support
  "GGally",        # Network visualization
  "visNetwork",    # Interactive networks
  "ggraph",        # ggplot2 for networks
  "tidygraph",     # Tidy network analysis
  "patchwork"      # Combine plots
)

# Check which packages are missing
installed <- packages %in% installed.packages()[,"Package"]
missing <- packages[!installed]

# Install only missing packages
if(length(missing) > 0) {
  cat("📦 Installing missing packages:", paste(missing, collapse = ", "), "\n")
  install.packages(missing, dependencies = TRUE, quiet = TRUE)
  cat("✓ Installation complete\n\n")
} else {
  cat("✓ All required packages already installed\n\n")
}

# Load all packages
cat("Loading packages...\n")
loaded <- sapply(packages, function(pkg) {
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
  cat("  ✓", pkg, "\n")
  return(TRUE)
})

cat("\n=== Setup complete ===\n")
cat("Total packages loaded:", length(packages), "\n")
