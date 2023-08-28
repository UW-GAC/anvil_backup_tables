library(argparser)
library(magrittr)
library(readr)
library(jsonlite)
library(AnVIL)
sessionInfo()

argp <- arg_parser("anvil_backup_tables") %>%
    add_argument("--workspace-name", help="Name of workspace to operate on") %>%
    add_argument("--workspace-namespace", help="Namespace of workspace to operate on") %>%
    add_argument("--output-bucket-path", help="Output directory in cloud bucket")
argv <- parse_args(argp)
print(argv)

# Loop over tables and write a tsv.
table_json <- list()
tables <- avtables(namespace=argv$workspace_namespace, name=argv$workspace_name)$table
for (t in tables) {
    message(sprintf("Backing up %s", t))
    table_data <- avtable(t, namespace=argv$workspace_namespace, name=argv$workspace_name)
    # outfile <- file.path(tmpdir, sprintf("%s.tsv", table))
    outfile <- sprintf("%s.tsv", t)
    write_tsv(table_data, outfile)
    table_json[[t]] <- file.path(argv$output_bucket_path, outfile)
}

# Print the files out (for testing?).
list.files()

# Copy the output to the final destination.
gsutil_cp("*.tsv", argv$output_bucket_path)

# Save the json file with table inputs.
outfile <- "table_files.json"
writeLines(toJSON(table_json), outfile)
gsutil_cp(outfile, argv$output_bucket_path)

message("Done!")
