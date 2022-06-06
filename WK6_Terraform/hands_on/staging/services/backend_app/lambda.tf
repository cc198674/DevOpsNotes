# Create a bucket
resource "aws_s3_bucket" "b1" {
  bucket = "terraform-serverless-jrdevops-rex"
  acl    = "private"   # or can be "public-read"
  tags = {
    Name  = "My bucket"
    Environment = "Dev"
  }
}

# Upload an object
resource "aws_s3_object" "object" {
  bucket  = "${aws_s3_bucket.b1.id}"
  key    = "v1.0.0/example.zip"
  acl    = "private"  # or can be "public-read"
  source = "example.zip"
}

resource "aws_lambda_function" "example" {
  function_name = "ServerlessExample"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = aws_s3_bucket.b1.id
  s3_key    = aws_s3_object.object.key

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.handler"
  runtime = "nodejs14.x"
  role=aws_iam_role.lambda_exec.arn
  depends_on = [
    aws_s3_object.object,
    aws_s3_bucket.b1,
  ]
}
# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"
  # Each Lambda function must have an associated IAM role which dictates what access it has to other AWS services.
  # The above configuration specifies a role with no access policy,
  # effectively giving the function no access to any AWS services,
  # since our example application requires no such access.
  assume_role_policy=<<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF

}
