library(argparser)
library(magrittr)
library(readr)
library(AnVIL)
sessionInfo()

argp <- arg_parser("anvil_backup_tables") %>%
    add_argument("--workspace-name", help="Name of workspace to operate on") %>%
    add_argument("--workspace-namespace", help="Namespace of workspace to operate on") %>%
    add_argument("--bucket-path", help="Output directory in cloud bucket")
argv <- parse_args(argp)
print(argv)

# # Create a tempdir in which to store the data tables.
tmpdir <- tempdir()

# Loop over tables and write a tsv.
tables <- avtables(namespace=argv$workspace_namespace, name=argv$workspace_name)$table
for (t in tables) {
    message(sprintf("Backing up %s", t))
    table_data <- avtable(t, namespace=argv$workspace_namespace, name=argv$workspace_name)
    outfile <- file.path(tmpdir, sprintf("%s.tsv", table))
    # outfile <- sprintf("%s.tsv", t)
    write_tsv(table_data, outfile)
}

# Print the files out (for testing?).
list.files(tmpdir)

# # Copy the output to the final destination.
gsutil_cp(file.path(tmpdir, "*"), bucket_path)

message("Done!")
