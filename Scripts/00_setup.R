# ==============================================================================
# Script 00: Setup and Package Installation
# Checks for existing packages before installing
# Updated for AMiner Citation Network dataset
# ==============================================================================

cat("=== Checking and installing required packages ===\n\n")

packages <- c(
  # Network analysis
  "igraph",        # Core network analysis
  "tidygraph",     # Tidy network analysis
  "ggraph",        # ggplot2 for networks
  
  # Data manipulation
  "dplyr",         # Data wrangling
  "tidyr",         # Data tidying
  "purrr",         # Functional programming
  "stringr",       # String manipulation
  
  # Visualization
  "ggplot2",       # Plotting
  "patchwork",     # Combine plots
  "scales",        # Scale functions
  
  # Data import/export
  "jsonlite",      # JSON parsing (for AMiner data)
  "readr",         # Fast data reading
  
  # R Markdown
  "knitr",         # R Markdown support
  "rmarkdown"      # Document rendering
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
cat("\n📊 Ready for AMiner Citation Network analysis\n")
