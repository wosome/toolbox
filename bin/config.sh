DIR_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export $(grep -v '^#' "$DIR_ROOT/../.env" | xargs -d '\n')

TF_SA_CREDENTIALS="$DIR_ROOT/../.auth"

export GOOGLE_APPLICATION_CREDENTIALS=${TF_SA_CREDENTIALS}
export GOOGLE_PROJECT=${TF_PROJECT_ID}
