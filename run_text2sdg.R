# Auto-generated R script to run text2sdg
# Setup user library paths
user_lib <- Sys.getenv("R_LIBS_USER")
if (user_lib != "" && dir.exists(user_lib)) {
  .libPaths(c(user_lib, .libPaths()))
}

# Ensure text2sdg is installed
if (!requireNamespace("text2sdg", quietly = TRUE)) {
  message("Installing text2sdg in user library...")
  install.packages("text2sdg", repos = "https://cloud.r-project.org")
}

suppressPackageStartupMessages(library(text2sdg))

sent_file <- "C:/Users/Admin/OneDrive/Desktop/SDG_credability/sentences.csv"
hits_file <- "C:/Users/Admin/OneDrive/Desktop/SDG_credability/text2sdg_hits.csv"

message("Reading sentences from: ", sent_file)
sent <- read.csv(sent_file, stringsAsFactors = FALSE, encoding = "UTF-8")

message("Detecting SDGs across systems: Aurora, Elsevier, SIRIS")
hits <- detect_sdg_systems(
  sent$sentence,
  systems = c("Aurora", "Elsevier", "SIRIS"),
  output = "documents"
)

if (!is.null(hits) && nrow(hits) > 0) {
  hits$document_idx <- as.integer(as.character(hits$document))
  hits$sent_id <- sent$sent_id[hits$document_idx]
  out <- hits[, c("sent_id", "sdg", "system")]
} else {
  out <- data.frame(sent_id = integer(0), sdg = character(0), system = character(0))
}

write.csv(out, hits_file, row.names = FALSE)
message("text2sdg identification complete. Hits saved to: ", hits_file)
