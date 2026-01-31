locals {
  # --- Naming Convention Strategy ---
  # Generates IDs like: namespace-stage-name (e.g., "finops-dev-payment-gateway")
  enabled     = var.enabled
  id          = "${var.namespace}-${var.stage}-${var.name}"
  
  # Standardized Tags for Governance
  tags = merge(
    var.tags,
    {
      "Name"        = local.id
      "Namespace"   = var.namespace
      "Stage"       = var.stage
      "Application" = var.name
      "ManagedBy"   = "Terraform"
      "Owner"       = "DevOps-Core"
    }
  )
}