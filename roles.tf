# resource "aws_iam_role" "GithubActionsRole" {
#   name = "GithubActionsRole"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Principal" : {
#           "Federated" : "arn:aws:iam::390844773286:oidc-provider/token.actions.githubusercontent.com"
#         },
#         "Action" : "sts:AssumeRoleWithWebIdentity",
#         "Condition" : {
#           "StringLike" : {
#             "token.actions.githubusercontent.com:sub" : "repo:alextonkovid/aws-devops:*",
#             "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_policy_attachment" "AmazonEC2FullAccess" {
#   name       = "attach-ec2-full-access"
#   roles      = [aws_iam_role.GithubActionsRole.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }

# resource "aws_iam_policy_attachment" "AmazonRoute53FullAccess" {
#   name       = "attach-route53-full-access"
#   roles      = [aws_iam_role.GithubActionsRole.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
# }

# resource "aws_iam_policy_attachment" "AmazonS3FullAccess" {
#   name       = "attach-s3-full-access"
#   roles      = [aws_iam_role.GithubActionsRole.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
# }

# resource "aws_iam_policy_attachment" "IAMFullAccess" {
#   name       = "attach-iam-full-access"
#   roles      = [aws_iam_role.GithubActionsRole.name]
#   policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
# }

# resource "aws_iam_policy_attachment" "AmazonVPCFullAccess" {
#   name       = "attach-vpc-full-access"
#   roles      = [aws_iam_role.GithubActionsRole.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
# }

# resource "aws_iam_policy_attachment" "AmazonSQSFullAccess" {
#   name       = "attach-sqs-full-access"
#   roles      = [aws_iam_role.GithubActionsRole.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
# }

# resource "aws_iam_policy_attachment" "AmazonEventBridgeFullAccess" {
#   name       = "attach-eventbridge-full-access"
#   roles      = [aws_iam_role.GithubActionsRole.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEventBridgeFullAccess"
# }
