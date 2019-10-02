#!/bin/bash

DIR_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export $(grep -v '^#' "$DIR_ROOT/../.env" | xargs -d '\n')

wk '{
  while (match($0, /\$\{[^\}]+}/)) {
      search = substr($0, RSTART + 2, RLENGTH - 3)
       $0 = substr($0, 1, RSTART - 1)    \
         ENVIRON[search]              \
         substr($0, RSTART + RLENGTH)
  }
  print
}' < "$DIR_ROOT/template/backend.tf" > "$DIR_ROOT/../service/backend.tf"

TF_SA_CREDENTIALS="$DIR_ROOT/../.auth"

echo "TF_PROJECT_ID  = $TF_PROJECT_ID"
echo "TF_PROJECT_ORG = $TF_PROJECT_ORG"

gcloud config set project "$TF_PROJECT_ID"

gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable serviceusage.googleapis.com


if [ ! -f "$TF_SA_CREDENTIALS" ]; then
  gcloud iam service-accounts create terraform \
    --display-name "Terraform admin account"

  gcloud iam service-accounts keys create "$TF_SA_CREDENTIALS" \
    --iam-account terraform@${TF_PROJECT_ID}.iam.gserviceaccount.com
fi

gcloud projects add-iam-policy-binding ${TF_PROJECT_ID} \
    --member serviceAccount:terraform@${TF_PROJECT_ID}.iam.gserviceaccount.com \
    --role roles/viewer

gcloud projects add-iam-policy-binding ${TF_PROJECT_ID} \
  --member serviceAccount:terraform@${TF_PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/storage.admin

gcloud organizations add-iam-policy-binding ${TF_PROJECT_ORG} \
  --member serviceAccount:terraform@${TF_PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding ${TF_PROJECT_ORG} \
  --member serviceAccount:terraform@${TF_PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/billing.user

gcloud organizations add-iam-policy-binding ${TF_PROJECT_ORG} \
  --member serviceAccount:terraform@${TF_PROJECT_ID}.iam.gserviceaccount.com \
  --role roles/compute.admin

gsutil mb -p ${TF_PROJECT_ID} gs://${TF_PROJECT_ID}

gsutil versioning set on gs://${TF_ADMIN}

. "$DIR_ROOT/config.sh"

