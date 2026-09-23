variable "name" {
  type        = string
  description = "Short lowercase identifier for this resource."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,40}$", var.name))
    error_message = "name must be a short lowercase identifier."
  }
}

variable "kubernetes_version" {
  type        = string
  description = "Patch version returned by ACK for this region. Confirm with DescribeKubernetesVersionMetadata before apply."

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+-aliyun\\.[0-9]+$", var.kubernetes_version))
    error_message = "kubernetes_version must look like 1.32.1-aliyun.1 and must be a version ACK offers in the target region."
  }
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR. Check it against current routes before apply."
}

variable "service_cidr" {
  type        = string
  description = "ClusterIP range outside the VPC. A /24 provides 254 ClusterIP addresses and cannot be resized later."

  validation {
    condition     = can(cidrhost(var.service_cidr, 0))
    error_message = "service_cidr must be a valid CIDR."
  }
}

variable "control_plane_vswitch_ids" {
  type        = list(string)
  description = "Management vSwitches, one per zone, for the private API ENIs. These are not the node vSwitches."

  validation {
    condition     = length(var.control_plane_vswitch_ids) >= 3
    error_message = "Provide one control-plane vSwitch in each of three zones."
  }
}

variable "pod_vswitch_ids" {
  type        = list(string)
  description = "Terway ENIIP pod vSwitches, one per zone, distinct from the control-plane vSwitches."

  validation {
    condition     = length(var.pod_vswitch_ids) >= 3
    error_message = "Provide one pod vSwitch in each of three zones."
  }
}

variable "resource_group_id" {
  type        = string
  description = "Resource group ID. Supply it from the resource-groups stack."
}

variable "secret_encryption_key_id" {
  type        = string
  description = "User-created KMS key used by ACK to encrypt Secrets in etcd. Do not pass alias/acs/ecs."

  validation {
    condition     = length(var.secret_encryption_key_id) > 8 && !strcontains(var.secret_encryption_key_id, "alias/acs/")
    error_message = "secret_encryption_key_id must be a user-created CMK id, not an ECS service key alias."
  }
}

variable "sls_project_name" {
  type        = string
  description = "Existing SLS project for control plane logs. Creating the project does not prove logs are arriving."
}

variable "tags" {
  type        = map(string)
  description = "Ownership tags. Include project, environment, owner and managed-by."
}

variable "addons" {
  type = list(object({
    name   = string
    config = string
  }))
  description = "ACK add-ons installed with the cluster. The internet ingress add-on is rejected."
  default = [
    { name = "terway-eniip", config = "" },
    { name = "csi-plugin", config = "" },
    { name = "csi-provisioner", config = "" },
    { name = "logtail-ds", config = "" },
    { name = "ack-node-problem-detector", config = "" },
    { name = "arms-prometheus", config = "" },
  ]

  validation {
    condition = alltrue([
      for required in ["terway-eniip", "csi-plugin", "csi-provisioner", "logtail-ds", "ack-node-problem-detector"] :
      contains([for addon in var.addons : addon.name], required)
    ])
    error_message = "The cluster must install terway-eniip, csi-plugin, csi-provisioner, logtail-ds and ack-node-problem-detector."
  }

  validation {
    condition     = !contains([for addon in var.addons : addon.name], "nginx-ingress-controller")
    error_message = "Do not install the internet nginx ingress controller in this baseline. Put application entry on a reviewed ALB or WAF."
  }

  validation {
    condition     = length([for addon in var.addons : addon if strcontains(addon.config, "internet")]) == 0
    error_message = "Addon config must not request an internet SLB."
  }
}
