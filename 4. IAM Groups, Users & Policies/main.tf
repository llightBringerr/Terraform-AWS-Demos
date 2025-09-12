resource "aws_iam_group" "demo_developers" { # Create an IAM group
  name = "developers"
  path = "/"
}

resource "aws_iam_group_policy" "developer_group_policy" { # Attach a policy to the group
  name  = "developer_group_policy"
  group = aws_iam_group.demo_developers.name
  policy = var.group-policy-json  # See variables.tf for the policy JSON
}

resource "aws_iam_user" "demo_user" {  # Create an IAM user
    name = "demouser"
    path = "/"
    force_destroy = true
}

resource "aws_iam_user_group_membership" "demo_membership" {    # Add the user to the group
  user = aws_iam_user.demo_user.name
  groups = [
    aws_iam_group.demo_developers.name
  ]
}

resource "aws_iam_user_login_profile" "demo_login" {    # Create a login profile for the user
   user = aws_iam_user.demo_user.name
   pgp_key = var.pgp_key                                # Use "gpg --full-generate-key" a 64-bit key, then "gpg --armor --export example@email.com" to get the key
                                                        # Then paste the output into the "pgp_key" variable in variables.tf
}

