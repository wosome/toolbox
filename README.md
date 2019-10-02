# toolbox
> From scratch
- Create GCP project for terraform backend, declare project and organization in `.env`  using `.env.example.env` as a template.
- Run `./bin/init.sh` to generate `backend.tf` and service account credentials
> After init is ran once, going forward source `./config.sh` to prepare `teraform`'s GCP provider
```
. ./bin/config.sh
```
## deploy
```
terraform init
terraform plan
terraform apply
```

## destroy
```
terraform destroy
```
