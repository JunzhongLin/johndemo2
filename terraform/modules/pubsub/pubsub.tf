resource "google_pubsub_topic" "msg_input" {
  name = "msg_input_topic"

  message_retention_duration = "86600s"
}
