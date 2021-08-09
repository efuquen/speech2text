resource "aws_sqs_queue" "speech2text" {
  name                      = "speech2text-transform"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}

resource "aws_sns_topic" "speech2text" {
  name = "speech2text-transform"
}

resource "aws_sns_topic_subscription" "speech2text" {
  topic_arn = aws_sns_topic.speech2text.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.speech2text.arn
}

resource "aws_lambda_event_source_mapping" "speech2text" {
  event_source_arn = aws_sqs_queue.speech2text.arn
  function_name    = aws_lambda_function.speech2text.arn
}