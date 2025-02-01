resource "google_pubsub_topic" "msg_input" {
  name = "msg_input_topic"

  message_retention_duration = "86600s"
}

resource "google_pubsub_topic" "dead_letter_topic" {
  name = "dead_letter_topic"
}

resource "google_pubsub_subscription" "input_topic_sub" {
  name  = "input_topic_sub"
  topic = google_pubsub_topic.msg_input.name
  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dead_letter_topic.id
    max_delivery_attempts = 5
  }
}

resource "google_pubsub_subscription" "dead_letter_topic_sub" {
  name  = "dead_letter_topic_sub"
  topic = google_pubsub_topic.dead_letter_topic.name
}
