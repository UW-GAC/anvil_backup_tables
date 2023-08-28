version 1.0

workflow anvil_backup_tables {
  input {
    String workspace_namespace
    String workspace_name
    String bucket_path
  }
  call backup_tables {
    input: workspace_namespace=workspace_namespace,
      workspace_name=workspace_name,
      output_bucket_path=output_bucket_path
  }
  output {
    # Files.
    Array[File] tables = backup_tables.tables
  }
}


task backup_tables {
  input {
    String workspace_namespace
    String workspace_name
    String output_bucket_path
  }
  command {
    set -e
    Rscript /usr/local/anvil_backup_tables/anvil_backup_tables.R \
        --workspace-namespace ~{workspace_namespace} \
        --workspace-name ~{workspace_name} \
        --output-bucket-path ~{output_bucket_path}
  }
  output {
    # Files.
    Array[File] tables = glob("*.tsv")
  }
  runtime {
    # Pull from DockerHub
    docker: "amstilp/anvil-backup-tables-devel:latest"
  }
}
