#!/bin/bash
. "$BIN/common.sh"

# credemtials
TF_SA_CREDENTIALS="$DIR_SERVICES/auth.json"

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

  gcloud iam service-accounts keys create "$DIR_SERVICES/tf.json" \
    --iam-account terraform@${TF_PROJECT_ID}.iam.gserviceaccount.com

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
fi

gsutil mb -p ${TF_PROJECT_ID} gs://${TF_PROJECT_ID}

gsutil versioning set on gs://${TF_ADMIN}

export GOOGLE_APPLICATION_CREDENTIALS=${TF_SA_CREDENTIALS}
export GOOGLE_PROJECT=${TF_PROJECT_ID}

export TF_VAR_bucket_name=${TF_PROJECT_ID}

template_compile setup.tf.template setup.tf

terraform init
