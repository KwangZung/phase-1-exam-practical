terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Tạo ra một chuỗi ngẫu nhiên dài 6 ký tự
resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

# Sinh ra file local chứa nội dung tượng trưng cho release artifact
resource "local_file" "release_artifact" {
  content  = "Release contents for Phase 1 Exam"
  filename = "${path.module}/release-artifact-${random_string.suffix.result}.txt"
}

# In ra đường dẫn file vừa tạo
output "artifact_path" {
  value = local_file.release_artifact.filename
}