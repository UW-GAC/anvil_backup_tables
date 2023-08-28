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
      bucket_path=bucket_path
  }
  output {
    # Files.
    Array[File] tables = backup_tables.tables
    File testfile = backup_tables.testfile
  }
}


task backup_tables {
  input {
    String workspace_namespace
    String workspace_name
    String bucket_path
  }
  command {
    set -e
    Rscript /usr/local/anvil_backup_tables/anvil_backup_tables.R \
        --workspace-namespace ~{workspace_namespace} \
        --workspace-name ~{workspace_name} \
        --bucket-path ~{bucket_path}
  }
  output {
    # Files.
    Array[File] tables = glob("*.tsv")
    File testfile = "analysis.tsv"
  }
  runtime {
    # Pull from DockerHub
    docker: "amstilp/anvil-backup-tables-devel:latest"
  }
}
