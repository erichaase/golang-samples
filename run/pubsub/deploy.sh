set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

gcloud builds submit --tag gcr.io/wpe-cr-dev/bigquery-slack-notifier
gcloud run deploy bigquery-slack-notifier --image gcr.io/wpe-cr-dev/bigquery-slack-notifier:latest --no-allow-unauthenticated --region us-east1 --update-secrets SLACK_WEBHOOK_URL=slack-webhook-url-bigquery-notifier:latest