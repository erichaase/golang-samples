set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

gcloud builds submit --tag gcr.io/wpe-cr-dev/bigquery-slack-notifier
gcloud run deploy bigquery-slack-notifier --image gcr.io/wpe-cr-dev/bigquery-slack-notifier:latest --no-allow-unauthenticated --region us-east1 --update-secrets SLACK_WEBHOOK_URL=slack-webhook-url-bigquery-notifier:latest
gcloud pubsub topics publish projects/wpe-platform-one-dev/topics/cron-monitoring --message '{ "state": "SUCCEEDED", "params": { "destination_table_name_template": "daily_usage_metrics_summary" } }'
gcloud pubsub topics publish projects/wpe-platform-one-dev/topics/cron-monitoring --message '{ "state": "FAILED", "params": { "destination_table_name_template": "p1adb_current_vs_last_week_comparison" }, "errorStatus": { "code": 3, "message": "On 2023-03-29 the difference between this week and last week metrics was not calculated ; JobID: 892230234532:scheduled_query_6454f936-0000-2289-811e-f403045e5844" } }'