resource "aws_ecr_repository" "speech2text-lambda" {
  name                 = "speech2text-lambda"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_lambda_function" "speech2text" {
  function_name = "speech2text"

  runtime = "go1.x"
  image_uri = "${aws_ecr_repository.speech2text-lambda.repository_url}:latest"
  package_type = "Image"

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "speech2text_handler" {
  name = "/aws/lambda/${aws_lambda_function.speech2text.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}