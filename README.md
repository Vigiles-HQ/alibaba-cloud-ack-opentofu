# Alibaba Cloud ACK OpenTofu Modules

[![Validate](https://github.com/Vigiles-HQ/alibaba-cloud-ack-opentofu/actions/workflows/validate.yml/badge.svg)](https://github.com/Vigiles-HQ/alibaba-cloud-ack-opentofu/actions/workflows/validate.yml)
[![OpenTofu 1.12](https://img.shields.io/badge/OpenTofu-1.12.x-1C4E80)](https://opentofu.org/docs/intro/install/)
[![Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-6B7280)](LICENSE)

OpenTofu modules and examples for private Alibaba Cloud ACK clusters. The repository covers multi-zone networking, controlled NAT egress, encrypted node pools, autoscaling, OSS remote state, TableStore locking and private Argo CD.

The examples use placeholder IDs and CIDR ranges. Check your account, region, network plan, quotas and service roles before applying.

This is an independent open-source project maintained by Vigiles Pte. Ltd. It is not an official Alibaba Cloud repository.

## What this repository creates

- Resource groups and tags for the example platform
- A three-zone VPC and vSwitches
- A NAT Gateway, an EIP and SNAT
- A private ACK Pro cluster
- Terway pod networking
- Fixed subscription system pools
- An autoscaling Spot application pool
- Encrypted ESSD system disks
- SLS integration for control-plane logs
- An OSS bucket for remote state
- A TableStore lock table
- Private Argo CD

Application ingress, databases, DNS and CEN connectivity are separate design decisions. This repository does not create them.

## Architecture

![Private ACK layout. OpenTofu writes state to OSS with a TableStore lock. A three-zone VPC holds a private control plane, subscription system pools, a Spot application pool and Terway pod vSwitches. Egress leaves through a NAT Gateway and an EIP. There is no public Kubernetes API.](docs/architecture.svg)

## Security defaults

- Private Kubernetes API (`slb_internet_enabled = false`)
- No public IPs on nodes (`internet_max_bandwidth_out = 0`)
- Node and pod default routes use the NAT Gateway
- No DNAT. The modules do not create `alicloud_forward_entry`
- No CEN attachment and no VPC peering in the VPC module
- Three availability zones
- Encrypted ESSD system disks
- RRSA enabled
- Terway ENIIP installed. Example NetworkPolicy files are in `manifests/` and are not applied by OpenTofu
- Deletion protection on the cluster
- Separate subscription system pools and a Spot application pool
- State in a private, versioned OSS bucket with AES256 encryption
- TableStore locking. The primary key is a string named `LockID`
- Provider and backend files contain no credentials

Review RBAC, security groups, application policies and database access yourself.

## Repository structure

```text
modules/     one job per module
examples/    production, nonproduction and the remote-state block
bootstrap/   resource groups and the state backend
backend/     OSS backend config examples
manifests/   example NetworkPolicy files
scripts/     local checks
tests/       contract checks
ci/          optional GitLab plan, then a manual apply
```

## Requirements

OpenTofu 1.12.x. The provider constraint is `aliyun/alicloud` `>= 1.241.0, < 2.0.0`. The lock file in this repository is 1.293.0. Helm is `>= 2.12.0, < 3.0.0`.

ACK service roles, including `AliyunCSManagedKubernetesRole` and `AliyunCSManagedSecurityRole`, must already exist. This repository does not create them.

## Quick start

```bash
cd examples/nonproduction/network
tofu init -backend=false
tofu validate
```

`-backend=false` does not create cloud resources. `tofu plan` needs credentials and a configured backend.

## Deployment order

1. `bootstrap/resource-groups`
2. `bootstrap/state-backend`
3. Copy a file from `backend/` and set the bucket and lock endpoint
4. `examples/<environment>/network`
5. `examples/<environment>/egress`
6. `examples/<environment>/cluster`
7. `examples/<environment>/argocd`

The network stack refuses to plan until `allow_example_cidrs` is true. Production examples use `172.21.0.0/16`. Non-production examples use `172.22.0.0/16`. Compare those ranges with your own networks before you turn that flag on.

## Remote state

`bootstrap/state-backend` creates the bucket and the lock table. Its first apply uses local state, because the bucket does not exist yet. Later stacks use `backend "oss"` with encryption, a private ACL and the TableStore lock. Keep access keys in the environment, not in the backend file.

## Testing

GitHub Actions runs `./scripts/validate.sh` with no cloud credentials. The script checks formatting, file length, forbidden files, secret patterns, shell syntax, `tofu init -backend=false`, `tofu validate` and the contract tests. It does not run `tofu apply`.

## Cost-sensitive resources

The NAT Gateway, EIP bandwidth, the private API load balancer, SLS storage, subscription system nodes and Spot application nodes all bill. The example egress sets the EIP cap at 200 Mbps. Change that before apply.

## Technical guides

[CloudArch Pro](https://www.cloudarchpro.com/) explains the architecture decisions, deployment order, failure modes and validation steps used by these modules.

- [Building a Secure Alibaba Cloud ACK Cluster with OpenTofu](https://www.cloudarchpro.com/guides/kubernetes-and-containers/secure-alibaba-cloud-ack-opentofu/)
- [Alibaba Cloud ACK Node Pools: Subscription, Spot and Autoscaling](https://www.cloudarchpro.com/guides/kubernetes-and-containers/alibaba-ack-node-pools-spot-autoscaling/)
- [OpenTofu Remote State and Private GitOps on Alibaba Cloud](https://www.cloudarchpro.com/guides/kubernetes-and-containers/opentofu-oss-state-argocd-alibaba-cloud/)

## Questions

**What does this repository create?** The resources in the list above. Ingress, databases, DNS and CEN are out of scope.

**Is the Kubernetes API public?** No. `slb_internet_enabled` is false.

**Does it assign public IPs to nodes?** No. Node public bandwidth is 0.

**How is OpenTofu state stored?** In a private OSS bucket, encrypted with AES256, with versioning on.

**How are state operations locked?** A TableStore table whose primary key is the string `LockID`.

**Are Spot instances used?** Yes, on the application pool. System pools are subscription nodes.

**Can the modules be used in another region?** Yes. `region` is an input. Check the ACK version, instance stock and TableStore in that region before apply.

**Is this an official Alibaba Cloud repository?** No. Vigiles Pte. Ltd. maintains it. Alibaba Cloud does not.

## Maintained by Vigiles

This project is maintained by [Vigiles Pte. Ltd.](https://vigileshq.com/about). Vigiles builds [monitoring and incident-management tools](https://vigileshq.com/) for production teams.

## Related Vigiles projects

Database architecture and OceanBase engineering guides are available at [OceanDB Pro](https://www.oceandbpro.com/).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## Security

See [SECURITY.md](SECURITY.md).

## Licence

Licensed under the Apache License 2.0. You may use, modify and distribute this project under the terms of the licence.
