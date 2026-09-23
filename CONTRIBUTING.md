# Contributing

Fork the repository and create a branch for one change.

Keep each hand-written file under 200 lines. Put variables in `variables.tf`, outputs in `outputs.tf`, locals in `locals.tf` and provider settings in `providers.tf`. A comment should say why, not repeat the resource.

Run `./scripts/validate.sh` before you open a pull request. Do not commit state files, plan files, kubeconfigs or credentials.

In the pull request, name the `aliyun/alicloud` provider version you used for `tofu validate`.
