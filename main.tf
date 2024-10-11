# resource "aws_s3_bucket" "terraform-test" {
#   bucket = "terraform-test-alextonkovid"
# }

# resource "aws_s3_bucket_ownership_controls" "terraform-test" {
#   bucket = aws_s3_bucket.terraform-test.id

#   rule {
#     object_ownership = "ObjectWriter"
#   }
# }

# resource "aws_s3_bucket_versioning" "versioning_terraform-test" {
#   bucket = aws_s3_bucket.terraform-test.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# resource "aws_s3_bucket_acl" "terraform-test" {
#   depends_on = [aws_s3_bucket_ownership_controls.terraform-test]

#   bucket = aws_s3_bucket.terraform-test.id
#   acl    = "private"
# }