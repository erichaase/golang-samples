set -o errexit   # abort on nonzero exitstatus
set -o nounset   # abort on unbound variable
set -o pipefail  # don't hide errors within pipes

# echo "################################################################################"
# date
# gcloud builds submit --tag gcr.io/wpe-cr-dev/bigquery-slack-notifier
# gcloud run deploy bigquery-slack-notifier --image gcr.io/wpe-cr-dev/bigquery-slack-notifier:latest --no-allow-unauthenticated --region us-east1
# gcloud pubsub topics publish projects/wpe-platform-one-dev/topics/cron-monitoring --message '{ "state": "SUCCEEDED", "params": { "destination_table_name_template": "daily_usage_metrics_summary" } }'
# gcloud pubsub topics publish projects/wpe-platform-one-dev/topics/cron-monitoring --message '{ "state": "FAILED", "params": { "destination_table_name_template": "p1adb_current_vs_last_week_comparison" }, "errorStatus": { "code": 3, "message": "On 2023-03-29 the difference between this week and last week metrics was not calculated ; JobID: 892230234532:scheduled_query_6454f936-0000-2289-811e-f403045e5844" } }'
# date
# echo "################################################################################"

echo -n '{"message":{"data":"eyAic3RhdGUiOiAiRkFJTEVEIiwgInBhcmFtcyI6IHsgImRlc3RpbmF0aW9uX3RhYmxlX25hbWVfdGVtcGxhdGUiOiAicDFhZGJfY3VycmVudF92c19sYXN0X3dlZWtfY29tcGFyaXNvbiIgfSwgImVycm9yU3RhdHVzIjogeyAiY29kZSI6IDMsICJtZXNzYWdlIjogIk9uIDIwMjMtMDMtMjkgdGhlIGRpZmZlcmVuY2UgYmV0d2VlbiB0aGlzIHdlZWsgYW5kIGxhc3Qgd2VlayBtZXRyaWNzIHdhcyBub3QgY2FsY3VsYXRlZCA7IEpvYklEOiA4OTIyMzAyMzQ1MzI6c2NoZWR1bGVkX3F1ZXJ5XzY0NTRmOTM2LTAwMDAtMjI4OS04MTFlLWY0MDMwNDVlNTg0NCIgfSB9","messageId":"7309667661985806","message_id":"7309667661985806","publishTime":"2023-03-30T23:44:32.209Z","publish_time":"2023-03-30T23:44:32.209Z"},"subscription":"projects/wpe-platform-one-dev/subscriptions/bigquery-slack-notifier"}' | http post localhost:8080
echo -n '{"message":{"data":"eyAic3RhdGUiOiAiU1VDQ0VFREVEIiwgInBhcmFtcyI6IHsgImRlc3RpbmF0aW9uX3RhYmxlX25hbWVfdGVtcGxhdGUiOiAiZGFpbHlfdXNhZ2VfbWV0cmljc19zdW1tYXJ5IiB9IH0=","messageId":"7309663548866999","message_id":"7309663548866999","publishTime":"2023-03-30T23:44:31.686Z","publish_time":"2023-03-30T23:44:31.686Z"},"subscription":"projects/wpe-platform-one-dev/subscriptions/bigquery-slack-notifier"}' | http post localhost:8080